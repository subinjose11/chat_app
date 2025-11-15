import 'dart:async';
import 'dart:developer';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:chat_app/local/notification_preferences_local_repo.dart';
import 'package:chat_app/models/notification_preferences.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationController extends StateNotifier<NotificationPreferences> {
  final NotificationPreferencesLocalRepository _localRepo;
  final FirebaseFirestore _firestore;

  StreamSubscription<QuerySnapshot>? _serviceOrdersSubscription;
  Timer? _dailyCheckTimer;
  Set<String> _processedOrders = {};

  NotificationController(this._localRepo, this._firestore)
      : super(const NotificationPreferences()) {
    _loadPreferences();
    _startListeningToOrders();
    _startDailyChecks();
  }

  // Load preferences from local storage
  Future<void> _loadPreferences() async {
    try {
      final prefs = await _localRepo.loadPreferences();
      state = prefs;

      // Schedule daily summary if enabled
      if (prefs.dailySummaryNotifications) {
        await NotificationService.scheduleDailySummary(
          hour: prefs.dailySummaryHour,
          minute: prefs.dailySummaryMinute,
        );
      }
    } catch (e) {
      log('Error loading notification preferences: $e');
    }
  }

  // Start listening to service orders for real-time notifications
  void _startListeningToOrders() {
    _serviceOrdersSubscription = _firestore
        .collection('service_orders')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      _handleServiceOrderChanges(snapshot);
    });
  }

  // Handle service order changes
  Future<void> _handleServiceOrderChanges(QuerySnapshot snapshot) async {
    if (!state.enabled) return;

    for (var change in snapshot.docChanges) {
      try {
        final data = {
          ...change.doc.data() as Map<String, dynamic>,
          'id': change.doc.id
        };
        final order = ServiceOrder.fromJson(data);

        // New order created
        if (change.type == DocumentChangeType.added) {
          // Check if we've already processed this order (to avoid duplicates on app start)
          if (_processedOrders.contains(order.id)) continue;
          _processedOrders.add(order.id);

          if (state.newOrderNotifications) {
            await _showNewOrderNotification(order);
          }
        }

        // Order modified
        if (change.type == DocumentChangeType.modified) {
          if (state.statusChangeNotifications) {
            await _showStatusChangeNotification(order);
          }

          // Schedule 30-day reminder if order completed
          if (order.status == 'completed' &&
              order.completedAt != null &&
              state.monthlyReminderNotifications) {
            await _schedule30DayReminder(order);
          }
        }
      } catch (e) {
        log('Error handling service order change: $e');
      }
    }
  }

  // Show new order notification
  Future<void> _showNewOrderNotification(ServiceOrder order) async {
    if (_isInQuietHours()) return;

    try {
      // Get vehicle number
      final vehicleDoc =
          await _firestore.collection('vehicles').doc(order.vehicleId).get();
      final vehicleNumber = vehicleDoc.exists
          ? (vehicleDoc.data()?['numberPlate'] ?? 'Unknown')
          : 'Unknown';

      await NotificationService.showNewOrderNotification(
        orderId: order.id,
        vehicleNumber: vehicleNumber,
        serviceType: order.serviceType,
      );
    } catch (e) {
      log('Error showing new order notification: $e');
    }
  }

  // Show status change notification
  Future<void> _showStatusChangeNotification(ServiceOrder order) async {
    if (_isInQuietHours()) return;

    try {
      final vehicleDoc =
          await _firestore.collection('vehicles').doc(order.vehicleId).get();
      final vehicleNumber = vehicleDoc.exists
          ? (vehicleDoc.data()?['numberPlate'] ?? 'Unknown')
          : 'Unknown';

      await NotificationService.showStatusChangeNotification(
        orderId: order.id,
        vehicleNumber: vehicleNumber,
        oldStatus: 'previous', // You may want to track this
        newStatus: order.status,
      );
    } catch (e) {
      log('Error showing status change notification: $e');
    }
  }

  // Schedule 30-day reminder
  Future<void> _schedule30DayReminder(ServiceOrder order) async {
    if (order.completedAt == null) return;

    try {
      final vehicleDoc =
          await _firestore.collection('vehicles').doc(order.vehicleId).get();
      final vehicleNumber = vehicleDoc.exists
          ? (vehicleDoc.data()?['numberPlate'] ?? 'Unknown')
          : 'Unknown';

      final customerDoc =
          await _firestore.collection('customers').doc(order.customerId).get();
      final customerName = customerDoc.exists
          ? (customerDoc.data()?['name'] ?? 'Customer')
          : 'Customer';

      // Calculate reminder date based on preferences
      final reminderDate = order.completedAt!.add(
        Duration(days: state.monthlyReminderDays),
      );

      await NotificationService.schedule30DayReminder(
        orderId: order.id,
        completedDate: reminderDate,
        customerName: customerName,
        vehicleNumber: vehicleNumber,
        serviceType: order.serviceType,
      );
    } catch (e) {
      log('Error scheduling 30-day reminder: $e');
    }
  }

  // Start daily checks for summary and overdue orders
  void _startDailyChecks() {
    // Check every hour
    _dailyCheckTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _performDailyChecks();
    });

    // Perform initial check
    _performDailyChecks();
  }

  // Perform daily checks
  Future<void> _performDailyChecks() async {
    if (!state.enabled) return;

    final now = DateTime.now();

    // Check if it's time for daily summary
    if (state.dailySummaryNotifications) {
      final shouldShowSummary = _shouldShowDailySummary(now);
      if (shouldShowSummary) {
        await _showDailySummary();
        await _localRepo.updateLastDailySummary(now);
        state = state.copyWith(lastDailySummary: now);
      }
    }

    // Check for overdue orders
    if (state.overdueOrderNotifications) {
      final shouldCheckOverdue = _shouldCheckOverdue(now);
      if (shouldCheckOverdue) {
        await _checkOverdueOrders();
        await _localRepo.updateLastOverdueCheck(now);
        state = state.copyWith(lastOverdueCheck: now);
      }
    }
  }

  // Check if should show daily summary
  bool _shouldShowDailySummary(DateTime now) {
    if (state.lastDailySummary == null) {
      // First time - check if it's the right hour
      return now.hour == state.dailySummaryHour &&
          now.minute >= state.dailySummaryMinute;
    }

    // Check if last summary was more than 23 hours ago and it's the right time
    final hoursSinceLastSummary =
        now.difference(state.lastDailySummary!).inHours;
    return hoursSinceLastSummary >= 23 &&
        now.hour == state.dailySummaryHour &&
        now.minute >= state.dailySummaryMinute;
  }

  // Check if should check overdue orders
  bool _shouldCheckOverdue(DateTime now) {
    if (state.lastOverdueCheck == null) return true;

    // Check once per day in the morning
    final hoursSinceLastCheck = now.difference(state.lastOverdueCheck!).inHours;
    return hoursSinceLastCheck >= 23 && now.hour >= 9;
  }

  // Show daily summary
  Future<void> _showDailySummary() async {
    if (_isInQuietHours()) return;

    try {
      final ordersSnapshot =
          await _firestore.collection('service_orders').get();

      int pendingOrders = 0;
      int inProgressOrders = 0;
      int completedToday = 0;

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      for (var doc in ordersSnapshot.docs) {
        final order = ServiceOrder.fromJson({...doc.data(), 'id': doc.id});

        if (order.status == 'pending') pendingOrders++;
        if (order.status == 'in_progress') inProgressOrders++;

        if (order.completedAt != null &&
            order.completedAt!.isAfter(todayStart) &&
            order.completedAt!.isBefore(todayEnd)) {
          completedToday++;
        }
      }

      await NotificationService.showDailySummaryNotification(
        pendingOrders: pendingOrders,
        inProgressOrders: inProgressOrders,
        completedToday: completedToday,
      );
    } catch (e) {
      log('Error showing daily summary: $e');
    }
  }

  // Check overdue orders
  Future<void> _checkOverdueOrders() async {
    if (_isInQuietHours()) return;

    try {
      final now = DateTime.now();
      final thresholdDate = now.subtract(
        Duration(days: state.overdueThresholdDays),
      );

      final ordersSnapshot = await _firestore
          .collection('service_orders')
          .where('status', isEqualTo: 'in_progress')
          .get();

      for (var doc in ordersSnapshot.docs) {
        final order = ServiceOrder.fromJson({...doc.data(), 'id': doc.id});

        if (order.createdAt != null &&
            order.createdAt!.isBefore(thresholdDate)) {
          final daysOverdue = now.difference(order.createdAt!).inDays;

          final vehicleDoc = await _firestore
              .collection('vehicles')
              .doc(order.vehicleId)
              .get();
          final vehicleNumber = vehicleDoc.exists
              ? (vehicleDoc.data()?['numberPlate'] ?? 'Unknown')
              : 'Unknown';

          await NotificationService.showOverdueOrderNotification(
            orderId: order.id,
            vehicleNumber: vehicleNumber,
            daysOverdue: daysOverdue,
          );
        }
      }
    } catch (e) {
      log('Error checking overdue orders: $e');
    }
  }

  // Check if current time is in quiet hours
  bool _isInQuietHours() {
    if (!state.quietHoursEnabled) return false;

    final now = DateTime.now();
    final currentHour = now.hour;

    final startHour = state.quietHoursStartHour;
    final endHour = state.quietHoursEndHour;

    if (startHour < endHour) {
      // e.g., 9 AM to 5 PM
      return currentHour >= startHour && currentHour < endHour;
    } else {
      // e.g., 10 PM to 8 AM (crosses midnight)
      return currentHour >= startHour || currentHour < endHour;
    }
  }

  // Update preferences methods
  Future<void> updateEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _localRepo.updateEnabled(enabled);
  }

  Future<void> updateNewOrderNotifications(bool enabled) async {
    state = state.copyWith(newOrderNotifications: enabled);
    await _localRepo.updateNewOrderNotifications(enabled);
  }

  Future<void> updateStatusChangeNotifications(bool enabled) async {
    state = state.copyWith(statusChangeNotifications: enabled);
    await _localRepo.updateStatusChangeNotifications(enabled);
  }

  Future<void> updateDailySummaryNotifications(bool enabled) async {
    state = state.copyWith(dailySummaryNotifications: enabled);
    await _localRepo.updateDailySummaryNotifications(enabled);

    if (enabled) {
      await NotificationService.scheduleDailySummary(
        hour: state.dailySummaryHour,
        minute: state.dailySummaryMinute,
      );
    } else {
      await NotificationService.cancelNotification(999);
    }
  }

  Future<void> updateMonthlyReminderNotifications(bool enabled) async {
    state = state.copyWith(monthlyReminderNotifications: enabled);
    await _localRepo.updateMonthlyReminderNotifications(enabled);
  }

  Future<void> updateOverdueOrderNotifications(bool enabled) async {
    state = state.copyWith(overdueOrderNotifications: enabled);
    await _localRepo.updateOverdueOrderNotifications(enabled);
  }

  Future<void> updateDailySummaryTime(int hour, int minute) async {
    state = state.copyWith(
      dailySummaryHour: hour,
      dailySummaryMinute: minute,
    );
    await _localRepo.updateDailySummaryTime(hour, minute);

    if (state.dailySummaryNotifications) {
      await NotificationService.scheduleDailySummary(
        hour: hour,
        minute: minute,
      );
    }
  }

  Future<void> updateMonthlyReminderDays(int days) async {
    state = state.copyWith(monthlyReminderDays: days);
    await _localRepo.updateMonthlyReminderDays(days);
  }

  Future<void> updateOverdueThresholdDays(int days) async {
    state = state.copyWith(overdueThresholdDays: days);
    await _localRepo.updateOverdueThresholdDays(days);
  }

  Future<void> updateQuietHours({
    required bool enabled,
    int? startHour,
    int? endHour,
  }) async {
    state = state.copyWith(
      quietHoursEnabled: enabled,
      quietHoursStartHour: startHour ?? state.quietHoursStartHour,
      quietHoursEndHour: endHour ?? state.quietHoursEndHour,
    );
    await _localRepo.updateQuietHours(
      enabled: enabled,
      startHour: startHour,
      endHour: endHour,
    );
  }

  // Test notification
  Future<void> sendTestNotification() async {
    await NotificationService.showLocalNotification(
      title: '🔔 Test Notification',
      body: 'Notifications are working correctly!',
    );
  }

  @override
  void dispose() {
    _serviceOrdersSubscription?.cancel();
    _dailyCheckTimer?.cancel();
    super.dispose();
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationPreferences>(
  (ref) {
    final localRepo = ref.watch(notificationPreferencesLocalRepoProvider);
    return NotificationController(
      localRepo,
      FirebaseFirestore.instance,
    );
  },
);
