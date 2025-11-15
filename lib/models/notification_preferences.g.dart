// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesImpl _$$NotificationPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferencesImpl(
      enabled: json['enabled'] as bool? ?? true,
      newOrderNotifications: json['newOrderNotifications'] as bool? ?? true,
      statusChangeNotifications:
          json['statusChangeNotifications'] as bool? ?? true,
      dailySummaryNotifications:
          json['dailySummaryNotifications'] as bool? ?? true,
      monthlyReminderNotifications:
          json['monthlyReminderNotifications'] as bool? ?? true,
      overdueOrderNotifications:
          json['overdueOrderNotifications'] as bool? ?? true,
      dailySummaryHour: (json['dailySummaryHour'] as num?)?.toInt() ?? 9,
      dailySummaryMinute: (json['dailySummaryMinute'] as num?)?.toInt() ?? 0,
      monthlyReminderDays: (json['monthlyReminderDays'] as num?)?.toInt() ?? 30,
      overdueThresholdDays:
          (json['overdueThresholdDays'] as num?)?.toInt() ?? 3,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStartHour: (json['quietHoursStartHour'] as num?)?.toInt() ?? 22,
      quietHoursEndHour: (json['quietHoursEndHour'] as num?)?.toInt() ?? 8,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      lastDailySummary: json['lastDailySummary'] == null
          ? null
          : DateTime.parse(json['lastDailySummary'] as String),
      lastOverdueCheck: json['lastOverdueCheck'] == null
          ? null
          : DateTime.parse(json['lastOverdueCheck'] as String),
    );

Map<String, dynamic> _$$NotificationPreferencesImplToJson(
        _$NotificationPreferencesImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'newOrderNotifications': instance.newOrderNotifications,
      'statusChangeNotifications': instance.statusChangeNotifications,
      'dailySummaryNotifications': instance.dailySummaryNotifications,
      'monthlyReminderNotifications': instance.monthlyReminderNotifications,
      'overdueOrderNotifications': instance.overdueOrderNotifications,
      'dailySummaryHour': instance.dailySummaryHour,
      'dailySummaryMinute': instance.dailySummaryMinute,
      'monthlyReminderDays': instance.monthlyReminderDays,
      'overdueThresholdDays': instance.overdueThresholdDays,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStartHour': instance.quietHoursStartHour,
      'quietHoursEndHour': instance.quietHoursEndHour,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'lastDailySummary': instance.lastDailySummary?.toIso8601String(),
      'lastOverdueCheck': instance.lastOverdueCheck?.toIso8601String(),
    };
