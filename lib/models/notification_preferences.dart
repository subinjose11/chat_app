import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool enabled,
    @Default(true) bool newOrderNotifications,
    @Default(true) bool statusChangeNotifications,
    @Default(true) bool dailySummaryNotifications,
    @Default(true) bool monthlyReminderNotifications,
    @Default(true) bool overdueOrderNotifications,
    @Default(9) int dailySummaryHour, // 9 AM
    @Default(0) int dailySummaryMinute,
    @Default(30) int monthlyReminderDays, // 30 days
    @Default(3) int overdueThresholdDays, // 3 days
    @Default(false) bool quietHoursEnabled,
    @Default(22) int quietHoursStartHour, // 10 PM
    @Default(8) int quietHoursEndHour, // 8 AM
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    DateTime? lastDailySummary,
    DateTime? lastOverdueCheck,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

