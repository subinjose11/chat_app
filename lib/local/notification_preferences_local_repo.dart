import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/models/notification_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesLocalRepository {
  static const String _key = 'notification_preferences';

  // Save preferences
  Future<void> savePreferences(NotificationPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(preferences.toJson());
      await prefs.setString(_key, json);
    } catch (e) {
      log('Error saving notification preferences: $e');
    }
  }

  // Load preferences
  Future<NotificationPreferences> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_key);

      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return NotificationPreferences.fromJson(map);
      }
    } catch (e) {
      log('Error loading notification preferences: $e');
    }

    // Return default preferences if not found or error
    return const NotificationPreferences();
  }

  // Update specific preference
  Future<void> updateEnabled(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(enabled: enabled));
  }

  Future<void> updateNewOrderNotifications(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(newOrderNotifications: enabled));
  }

  Future<void> updateStatusChangeNotifications(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(
        preferences.copyWith(statusChangeNotifications: enabled));
  }

  Future<void> updateDailySummaryNotifications(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(
        preferences.copyWith(dailySummaryNotifications: enabled));
  }

  Future<void> updateMonthlyReminderNotifications(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(
        preferences.copyWith(monthlyReminderNotifications: enabled));
  }

  Future<void> updateOverdueOrderNotifications(bool enabled) async {
    final preferences = await loadPreferences();
    await savePreferences(
        preferences.copyWith(overdueOrderNotifications: enabled));
  }

  Future<void> updateDailySummaryTime(int hour, int minute) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(
      dailySummaryHour: hour,
      dailySummaryMinute: minute,
    ));
  }

  Future<void> updateMonthlyReminderDays(int days) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(monthlyReminderDays: days));
  }

  Future<void> updateOverdueThresholdDays(int days) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(overdueThresholdDays: days));
  }

  Future<void> updateQuietHours({
    required bool enabled,
    int? startHour,
    int? endHour,
  }) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(
      quietHoursEnabled: enabled,
      quietHoursStartHour: startHour ?? preferences.quietHoursStartHour,
      quietHoursEndHour: endHour ?? preferences.quietHoursEndHour,
    ));
  }

  Future<void> updateLastDailySummary(DateTime timestamp) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(lastDailySummary: timestamp));
  }

  Future<void> updateLastOverdueCheck(DateTime timestamp) async {
    final preferences = await loadPreferences();
    await savePreferences(preferences.copyWith(lastOverdueCheck: timestamp));
  }
}

final notificationPreferencesLocalRepoProvider = Provider((ref) {
  return NotificationPreferencesLocalRepository();
});
