import 'dart:convert';
import 'package:chat_app/local/notification_history_repo.dart';
import 'package:chat_app/models/in_app_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;

// Notification payload model
class NotificationPayload {
  final String type;
  final String? orderId;
  final String? vehicleId;
  final String? customerId;
  final Map<String, dynamic>? data;

  NotificationPayload({
    required this.type,
    this.orderId,
    this.vehicleId,
    this.customerId,
    this.data,
  });

  String toJson() {
    return jsonEncode({
      'type': type,
      'orderId': orderId,
      'vehicleId': vehicleId,
      'customerId': customerId,
      'data': data,
    });
  }

  factory NotificationPayload.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return NotificationPayload(
      type: map['type'] as String,
      orderId: map['orderId'] as String?,
      vehicleId: map['vehicleId'] as String?,
      customerId: map['customerId'] as String?,
      data: map['data'] as Map<String, dynamic>?,
    );
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Callback for notification tap
  static Function(NotificationPayload)? onNotificationTap;

  // Notification channel IDs
  static const String _channelIdOrders = 'service_orders';
  static const String _channelIdReminders = 'reminders';
  static const String _channelIdSummary = 'daily_summary';
  static const String _channelIdStatus = 'status_updates';

  // Initialize notifications
  static Future<void> initialize({
    Function(NotificationPayload)? onTap,
  }) async {
    onNotificationTap = onTap;

    // Request permissions
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidIcon = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidIcon,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showLocalNotification(
          title: message.notification!.title ?? 'Notification',
          body: message.notification!.body ?? '',
          channelId: _channelIdOrders,
        );
      }
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle when user taps notification from background
      if (message.data.isNotEmpty) {
        _handleNotificationTap(jsonEncode(message.data));
      }
    });
  }

  // Create notification channels
  static Future<void> _createNotificationChannels() async {
    // Service Orders Channel
    const ordersChannel = AndroidNotificationChannel(
      _channelIdOrders,
      'Service Orders',
      description: 'Notifications for new and updated service orders',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Reminders Channel
    const remindersChannel = AndroidNotificationChannel(
      _channelIdReminders,
      'Reminders',
      description: 'Service reminders and follow-ups',
      importance: Importance.high,
      playSound: true,
    );

    // Daily Summary Channel
    const summaryChannel = AndroidNotificationChannel(
      _channelIdSummary,
      'Daily Summary',
      description: 'Daily work summary and statistics',
      importance: Importance.defaultImportance,
      playSound: false,
    );

    // Status Updates Channel
    const statusChannel = AndroidNotificationChannel(
      _channelIdStatus,
      'Status Updates',
      description: 'Order status change notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(ordersChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(remindersChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(summaryChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(statusChannel);
  }

  // Handle notification tap
  static void _handleNotificationTap(String? payload) {
    if (payload != null && onNotificationTap != null) {
      try {
        final notificationPayload = NotificationPayload.fromJson(payload);
        onNotificationTap!(notificationPayload);
      } catch (e) {
        // Handle parsing error
      }
    }
  }

  // Show local notification
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = _channelIdOrders,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Show new order notification
  static Future<void> showNewOrderNotification({
    required String orderId,
    required String vehicleNumber,
    required String serviceType,
  }) async {
    final payload = NotificationPayload(
      type: 'new_order',
      orderId: orderId,
    );

    // Save to in-app notification history
    await _saveToHistory(
      title: '🔧 New Service Order',
      body: '$vehicleNumber - $serviceType',
      type: 'new_order',
      orderId: orderId,
    );

    await showLocalNotification(
      title: '🔧 New Service Order',
      body: '$vehicleNumber - $serviceType',
      payload: payload.toJson(),
      channelId: _channelIdOrders,
    );
  }

  // Show status change notification
  static Future<void> showStatusChangeNotification({
    required String orderId,
    required String vehicleNumber,
    required String oldStatus,
    required String newStatus,
  }) async {
    final payload = NotificationPayload(
      type: 'status_change',
      orderId: orderId,
    );

    String emoji = '📝';
    if (newStatus == 'in_progress') emoji = '⚙️';
    if (newStatus == 'completed') emoji = '✅';
    if (newStatus == 'cancelled') emoji = '❌';

    final title = '$emoji Order Status Updated';
    final body = '$vehicleNumber is now $newStatus';

    // Save to in-app notification history
    await _saveToHistory(
      title: title,
      body: body,
      type: 'status_change',
      orderId: orderId,
    );

    await showLocalNotification(
      title: title,
      body: body,
      payload: payload.toJson(),
      channelId: _channelIdStatus,
    );
  }

  // Show daily summary notification
  static Future<void> showDailySummaryNotification({
    required int pendingOrders,
    required int inProgressOrders,
    required int completedToday,
  }) async {
    final payload = NotificationPayload(
      type: 'daily_summary',
    );

    final body =
        'Pending: $pendingOrders | In Progress: $inProgressOrders | Completed: $completedToday';

    // Save to in-app notification history
    await _saveToHistory(
      title: '📊 Daily Summary',
      body: body,
      type: 'summary',
    );

    await showLocalNotification(
      title: '📊 Daily Summary',
      body: body,
      payload: payload.toJson(),
      channelId: _channelIdSummary,
    );
  }

  // Show 30-day reminder notification
  static Future<void> showMonthlyReminderNotification({
    required String orderId,
    required String customerName,
    required String vehicleNumber,
    required String serviceType,
  }) async {
    final payload = NotificationPayload(
      type: 'monthly_reminder',
      orderId: orderId,
    );

    final body =
        'Check on $customerName\'s $vehicleNumber - $serviceType completed 30 days ago';

    // Save to in-app notification history
    await _saveToHistory(
      title: '🔔 Service Follow-up',
      body: body,
      type: 'reminder',
      orderId: orderId,
    );

    await showLocalNotification(
      title: '🔔 Service Follow-up',
      body: body,
      payload: payload.toJson(),
      channelId: _channelIdReminders,
    );
  }

  // Show overdue order notification
  static Future<void> showOverdueOrderNotification({
    required String orderId,
    required String vehicleNumber,
    required int daysOverdue,
  }) async {
    final payload = NotificationPayload(
      type: 'overdue_order',
      orderId: orderId,
    );

    final body = '$vehicleNumber has been in progress for $daysOverdue days';

    // Save to in-app notification history
    await _saveToHistory(
      title: '⚠️ Overdue Order',
      body: body,
      type: 'overdue',
      orderId: orderId,
    );

    await showLocalNotification(
      title: '⚠️ Overdue Order',
      body: body,
      payload: payload.toJson(),
      channelId: _channelIdStatus,
    );
  }

  // Helper method to save notification to history
  static Future<void> _saveToHistory({
    required String title,
    required String body,
    required String type,
    String? orderId,
    String? vehicleId,
    String? customerId,
  }) async {
    try {
      final repo = NotificationHistoryRepository();
      final notification = InAppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        orderId: orderId,
        vehicleId: vehicleId,
        customerId: customerId,
        isRead: false,
        createdAt: DateTime.now(),
      );

      await repo.addNotification(notification);
    } catch (e) {
      // Log error but don't block notification
      print('Error saving notification to history: $e');
    }
  }

  // Schedule notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = _channelIdReminders,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Schedule daily summary at specific time
  static Future<void> scheduleDailySummary({
    required int hour,
    required int minute,
  }) async {
    // Cancel existing daily summary
    await _notifications.cancel(999);

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Note: This schedules only once. For recurring, you'd need to reschedule
    // after each notification or use a background task
    await scheduleNotification(
      id: 999,
      title: '📊 Daily Summary',
      body: 'Tap to view your daily work summary',
      scheduledDate: scheduledDate,
      channelId: _channelIdSummary,
    );
  }

  // Schedule 30-day reminder for completed order
  static Future<void> schedule30DayReminder({
    required String orderId,
    required DateTime completedDate,
    required String customerName,
    required String vehicleNumber,
    required String serviceType,
  }) async {
    final reminderDate = completedDate.add(const Duration(days: 30));
    final id = orderId.hashCode % 100000;

    final payload = NotificationPayload(
      type: 'monthly_reminder',
      orderId: orderId,
    );

    await scheduleNotification(
      id: id,
      title: '🔔 Service Follow-up',
      body:
          'Check on $customerName\'s $vehicleNumber - $serviceType completed 30 days ago',
      scheduledDate: reminderDate,
      payload: payload.toJson(),
      channelId: _channelIdReminders,
    );
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Get pending notifications
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Get FCM token
  static Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }

  // Helper methods
  static String _getChannelName(String channelId) {
    switch (channelId) {
      case _channelIdOrders:
        return 'Service Orders';
      case _channelIdReminders:
        return 'Reminders';
      case _channelIdSummary:
        return 'Daily Summary';
      case _channelIdStatus:
        return 'Status Updates';
      default:
        return 'Notifications';
    }
  }

  static String _getChannelDescription(String channelId) {
    switch (channelId) {
      case _channelIdOrders:
        return 'Notifications for new and updated service orders';
      case _channelIdReminders:
        return 'Service reminders and follow-ups';
      case _channelIdSummary:
        return 'Daily work summary and statistics';
      case _channelIdStatus:
        return 'Order status change notifications';
      default:
        return 'General notifications';
    }
  }
}
