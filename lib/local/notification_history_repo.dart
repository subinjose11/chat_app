import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/models/in_app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHistoryRepository {
  static const String _key = 'notification_history';
  static const int _maxNotifications = 100; // Keep last 100 notifications

  // Save notification to history
  Future<void> addNotification(InAppNotification notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getAll();

      // Add new notification at the beginning
      notifications.insert(0, notification);

      // Keep only last 100 notifications
      if (notifications.length > _maxNotifications) {
        notifications.removeRange(_maxNotifications, notifications.length);
      }

      // Save to storage
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    } catch (e) {
      log('Error adding notification to history: $e');
    }
  }

  // Get all notifications
  Future<List<InAppNotification>> getAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);

      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList
            .map((json) =>
                InAppNotification.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log('Error loading notification history: $e');
    }

    return [];
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    final notifications = await getAll();
    return notifications.where((n) => !n.isRead).length;
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getAll();
      final index = notifications.indexWhere((n) => n.id == notificationId);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);

        final prefs = await SharedPreferences.getInstance();
        final jsonList = notifications.map((n) => n.toJson()).toList();
        await prefs.setString(_key, jsonEncode(jsonList));
      }
    } catch (e) {
      log('Error marking notification as read: $e');
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      final notifications = await getAll();
      final updatedNotifications =
          notifications.map((n) => n.copyWith(isRead: true)).toList();

      final prefs = await SharedPreferences.getInstance();
      final jsonList = updatedNotifications.map((n) => n.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    } catch (e) {
      log('Error marking all notifications as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final notifications = await getAll();
      notifications.removeWhere((n) => n.id == notificationId);

      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_key, jsonEncode(jsonList));
    } catch (e) {
      log('Error deleting notification: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      log('Error clearing notification history: $e');
    }
  }
}

// Provider
final notificationHistoryRepoProvider = Provider((ref) {
  return NotificationHistoryRepository();
});

// Unread count provider
final unreadNotificationCountProvider = StreamProvider<int>((ref) async* {
  final repo = ref.watch(notificationHistoryRepoProvider);

  // Initial count
  yield await repo.getUnreadCount();

  // Update every 5 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
    yield await repo.getUnreadCount();
  }
});

// All notifications provider
final allNotificationsProvider =
    FutureProvider<List<InAppNotification>>((ref) async {
  final repo = ref.watch(notificationHistoryRepoProvider);
  return await repo.getAll();
});
