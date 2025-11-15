// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationPreferences _$NotificationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferences {
  bool get enabled => throw _privateConstructorUsedError;
  bool get newOrderNotifications => throw _privateConstructorUsedError;
  bool get statusChangeNotifications => throw _privateConstructorUsedError;
  bool get dailySummaryNotifications => throw _privateConstructorUsedError;
  bool get monthlyReminderNotifications => throw _privateConstructorUsedError;
  bool get overdueOrderNotifications => throw _privateConstructorUsedError;
  int get dailySummaryHour => throw _privateConstructorUsedError; // 9 AM
  int get dailySummaryMinute => throw _privateConstructorUsedError;
  int get monthlyReminderDays => throw _privateConstructorUsedError; // 30 days
  int get overdueThresholdDays => throw _privateConstructorUsedError; // 3 days
  bool get quietHoursEnabled => throw _privateConstructorUsedError;
  int get quietHoursStartHour => throw _privateConstructorUsedError; // 10 PM
  int get quietHoursEndHour => throw _privateConstructorUsedError; // 8 AM
  bool get soundEnabled => throw _privateConstructorUsedError;
  bool get vibrationEnabled => throw _privateConstructorUsedError;
  DateTime? get lastDailySummary => throw _privateConstructorUsedError;
  DateTime? get lastOverdueCheck => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value,
          $Res Function(NotificationPreferences) then) =
      _$NotificationPreferencesCopyWithImpl<$Res, NotificationPreferences>;
  @useResult
  $Res call(
      {bool enabled,
      bool newOrderNotifications,
      bool statusChangeNotifications,
      bool dailySummaryNotifications,
      bool monthlyReminderNotifications,
      bool overdueOrderNotifications,
      int dailySummaryHour,
      int dailySummaryMinute,
      int monthlyReminderDays,
      int overdueThresholdDays,
      bool quietHoursEnabled,
      int quietHoursStartHour,
      int quietHoursEndHour,
      bool soundEnabled,
      bool vibrationEnabled,
      DateTime? lastDailySummary,
      DateTime? lastOverdueCheck});
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res,
        $Val extends NotificationPreferences>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? newOrderNotifications = null,
    Object? statusChangeNotifications = null,
    Object? dailySummaryNotifications = null,
    Object? monthlyReminderNotifications = null,
    Object? overdueOrderNotifications = null,
    Object? dailySummaryHour = null,
    Object? dailySummaryMinute = null,
    Object? monthlyReminderDays = null,
    Object? overdueThresholdDays = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStartHour = null,
    Object? quietHoursEndHour = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? lastDailySummary = freezed,
    Object? lastOverdueCheck = freezed,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      newOrderNotifications: null == newOrderNotifications
          ? _value.newOrderNotifications
          : newOrderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      statusChangeNotifications: null == statusChangeNotifications
          ? _value.statusChangeNotifications
          : statusChangeNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySummaryNotifications: null == dailySummaryNotifications
          ? _value.dailySummaryNotifications
          : dailySummaryNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      monthlyReminderNotifications: null == monthlyReminderNotifications
          ? _value.monthlyReminderNotifications
          : monthlyReminderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      overdueOrderNotifications: null == overdueOrderNotifications
          ? _value.overdueOrderNotifications
          : overdueOrderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySummaryHour: null == dailySummaryHour
          ? _value.dailySummaryHour
          : dailySummaryHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailySummaryMinute: null == dailySummaryMinute
          ? _value.dailySummaryMinute
          : dailySummaryMinute // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyReminderDays: null == monthlyReminderDays
          ? _value.monthlyReminderDays
          : monthlyReminderDays // ignore: cast_nullable_to_non_nullable
              as int,
      overdueThresholdDays: null == overdueThresholdDays
          ? _value.overdueThresholdDays
          : overdueThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStartHour: null == quietHoursStartHour
          ? _value.quietHoursStartHour
          : quietHoursStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEndHour: null == quietHoursEndHour
          ? _value.quietHoursEndHour
          : quietHoursEndHour // ignore: cast_nullable_to_non_nullable
              as int,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDailySummary: freezed == lastDailySummary
          ? _value.lastDailySummary
          : lastDailySummary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastOverdueCheck: freezed == lastOverdueCheck
          ? _value.lastOverdueCheck
          : lastOverdueCheck // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesImplCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$$NotificationPreferencesImplCopyWith(
          _$NotificationPreferencesImpl value,
          $Res Function(_$NotificationPreferencesImpl) then) =
      __$$NotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      bool newOrderNotifications,
      bool statusChangeNotifications,
      bool dailySummaryNotifications,
      bool monthlyReminderNotifications,
      bool overdueOrderNotifications,
      int dailySummaryHour,
      int dailySummaryMinute,
      int monthlyReminderDays,
      int overdueThresholdDays,
      bool quietHoursEnabled,
      int quietHoursStartHour,
      int quietHoursEndHour,
      bool soundEnabled,
      bool vibrationEnabled,
      DateTime? lastDailySummary,
      DateTime? lastOverdueCheck});
}

/// @nodoc
class __$$NotificationPreferencesImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesCopyWithImpl<$Res,
        _$NotificationPreferencesImpl>
    implements _$$NotificationPreferencesImplCopyWith<$Res> {
  __$$NotificationPreferencesImplCopyWithImpl(
      _$NotificationPreferencesImpl _value,
      $Res Function(_$NotificationPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? newOrderNotifications = null,
    Object? statusChangeNotifications = null,
    Object? dailySummaryNotifications = null,
    Object? monthlyReminderNotifications = null,
    Object? overdueOrderNotifications = null,
    Object? dailySummaryHour = null,
    Object? dailySummaryMinute = null,
    Object? monthlyReminderDays = null,
    Object? overdueThresholdDays = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStartHour = null,
    Object? quietHoursEndHour = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? lastDailySummary = freezed,
    Object? lastOverdueCheck = freezed,
  }) {
    return _then(_$NotificationPreferencesImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      newOrderNotifications: null == newOrderNotifications
          ? _value.newOrderNotifications
          : newOrderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      statusChangeNotifications: null == statusChangeNotifications
          ? _value.statusChangeNotifications
          : statusChangeNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySummaryNotifications: null == dailySummaryNotifications
          ? _value.dailySummaryNotifications
          : dailySummaryNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      monthlyReminderNotifications: null == monthlyReminderNotifications
          ? _value.monthlyReminderNotifications
          : monthlyReminderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      overdueOrderNotifications: null == overdueOrderNotifications
          ? _value.overdueOrderNotifications
          : overdueOrderNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      dailySummaryHour: null == dailySummaryHour
          ? _value.dailySummaryHour
          : dailySummaryHour // ignore: cast_nullable_to_non_nullable
              as int,
      dailySummaryMinute: null == dailySummaryMinute
          ? _value.dailySummaryMinute
          : dailySummaryMinute // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyReminderDays: null == monthlyReminderDays
          ? _value.monthlyReminderDays
          : monthlyReminderDays // ignore: cast_nullable_to_non_nullable
              as int,
      overdueThresholdDays: null == overdueThresholdDays
          ? _value.overdueThresholdDays
          : overdueThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStartHour: null == quietHoursStartHour
          ? _value.quietHoursStartHour
          : quietHoursStartHour // ignore: cast_nullable_to_non_nullable
              as int,
      quietHoursEndHour: null == quietHoursEndHour
          ? _value.quietHoursEndHour
          : quietHoursEndHour // ignore: cast_nullable_to_non_nullable
              as int,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDailySummary: freezed == lastDailySummary
          ? _value.lastDailySummary
          : lastDailySummary // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastOverdueCheck: freezed == lastOverdueCheck
          ? _value.lastOverdueCheck
          : lastOverdueCheck // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesImpl implements _NotificationPreferences {
  const _$NotificationPreferencesImpl(
      {this.enabled = true,
      this.newOrderNotifications = true,
      this.statusChangeNotifications = true,
      this.dailySummaryNotifications = true,
      this.monthlyReminderNotifications = true,
      this.overdueOrderNotifications = true,
      this.dailySummaryHour = 9,
      this.dailySummaryMinute = 0,
      this.monthlyReminderDays = 30,
      this.overdueThresholdDays = 3,
      this.quietHoursEnabled = false,
      this.quietHoursStartHour = 22,
      this.quietHoursEndHour = 8,
      this.soundEnabled = true,
      this.vibrationEnabled = true,
      this.lastDailySummary,
      this.lastOverdueCheck});

  factory _$NotificationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool newOrderNotifications;
  @override
  @JsonKey()
  final bool statusChangeNotifications;
  @override
  @JsonKey()
  final bool dailySummaryNotifications;
  @override
  @JsonKey()
  final bool monthlyReminderNotifications;
  @override
  @JsonKey()
  final bool overdueOrderNotifications;
  @override
  @JsonKey()
  final int dailySummaryHour;
// 9 AM
  @override
  @JsonKey()
  final int dailySummaryMinute;
  @override
  @JsonKey()
  final int monthlyReminderDays;
// 30 days
  @override
  @JsonKey()
  final int overdueThresholdDays;
// 3 days
  @override
  @JsonKey()
  final bool quietHoursEnabled;
  @override
  @JsonKey()
  final int quietHoursStartHour;
// 10 PM
  @override
  @JsonKey()
  final int quietHoursEndHour;
// 8 AM
  @override
  @JsonKey()
  final bool soundEnabled;
  @override
  @JsonKey()
  final bool vibrationEnabled;
  @override
  final DateTime? lastDailySummary;
  @override
  final DateTime? lastOverdueCheck;

  @override
  String toString() {
    return 'NotificationPreferences(enabled: $enabled, newOrderNotifications: $newOrderNotifications, statusChangeNotifications: $statusChangeNotifications, dailySummaryNotifications: $dailySummaryNotifications, monthlyReminderNotifications: $monthlyReminderNotifications, overdueOrderNotifications: $overdueOrderNotifications, dailySummaryHour: $dailySummaryHour, dailySummaryMinute: $dailySummaryMinute, monthlyReminderDays: $monthlyReminderDays, overdueThresholdDays: $overdueThresholdDays, quietHoursEnabled: $quietHoursEnabled, quietHoursStartHour: $quietHoursStartHour, quietHoursEndHour: $quietHoursEndHour, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, lastDailySummary: $lastDailySummary, lastOverdueCheck: $lastOverdueCheck)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.newOrderNotifications, newOrderNotifications) ||
                other.newOrderNotifications == newOrderNotifications) &&
            (identical(other.statusChangeNotifications, statusChangeNotifications) ||
                other.statusChangeNotifications == statusChangeNotifications) &&
            (identical(other.dailySummaryNotifications,
                    dailySummaryNotifications) ||
                other.dailySummaryNotifications == dailySummaryNotifications) &&
            (identical(other.monthlyReminderNotifications,
                    monthlyReminderNotifications) ||
                other.monthlyReminderNotifications ==
                    monthlyReminderNotifications) &&
            (identical(other.overdueOrderNotifications,
                    overdueOrderNotifications) ||
                other.overdueOrderNotifications == overdueOrderNotifications) &&
            (identical(other.dailySummaryHour, dailySummaryHour) ||
                other.dailySummaryHour == dailySummaryHour) &&
            (identical(other.dailySummaryMinute, dailySummaryMinute) ||
                other.dailySummaryMinute == dailySummaryMinute) &&
            (identical(other.monthlyReminderDays, monthlyReminderDays) ||
                other.monthlyReminderDays == monthlyReminderDays) &&
            (identical(other.overdueThresholdDays, overdueThresholdDays) ||
                other.overdueThresholdDays == overdueThresholdDays) &&
            (identical(other.quietHoursEnabled, quietHoursEnabled) ||
                other.quietHoursEnabled == quietHoursEnabled) &&
            (identical(other.quietHoursStartHour, quietHoursStartHour) ||
                other.quietHoursStartHour == quietHoursStartHour) &&
            (identical(other.quietHoursEndHour, quietHoursEndHour) ||
                other.quietHoursEndHour == quietHoursEndHour) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            (identical(other.lastDailySummary, lastDailySummary) ||
                other.lastDailySummary == lastDailySummary) &&
            (identical(other.lastOverdueCheck, lastOverdueCheck) ||
                other.lastOverdueCheck == lastOverdueCheck));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabled,
      newOrderNotifications,
      statusChangeNotifications,
      dailySummaryNotifications,
      monthlyReminderNotifications,
      overdueOrderNotifications,
      dailySummaryHour,
      dailySummaryMinute,
      monthlyReminderDays,
      overdueThresholdDays,
      quietHoursEnabled,
      quietHoursStartHour,
      quietHoursEndHour,
      soundEnabled,
      vibrationEnabled,
      lastDailySummary,
      lastOverdueCheck);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => __$$NotificationPreferencesImplCopyWithImpl<
          _$NotificationPreferencesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferences implements NotificationPreferences {
  const factory _NotificationPreferences(
      {final bool enabled,
      final bool newOrderNotifications,
      final bool statusChangeNotifications,
      final bool dailySummaryNotifications,
      final bool monthlyReminderNotifications,
      final bool overdueOrderNotifications,
      final int dailySummaryHour,
      final int dailySummaryMinute,
      final int monthlyReminderDays,
      final int overdueThresholdDays,
      final bool quietHoursEnabled,
      final int quietHoursStartHour,
      final int quietHoursEndHour,
      final bool soundEnabled,
      final bool vibrationEnabled,
      final DateTime? lastDailySummary,
      final DateTime? lastOverdueCheck}) = _$NotificationPreferencesImpl;

  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesImpl.fromJson;

  @override
  bool get enabled;
  @override
  bool get newOrderNotifications;
  @override
  bool get statusChangeNotifications;
  @override
  bool get dailySummaryNotifications;
  @override
  bool get monthlyReminderNotifications;
  @override
  bool get overdueOrderNotifications;
  @override
  int get dailySummaryHour; // 9 AM
  @override
  int get dailySummaryMinute;
  @override
  int get monthlyReminderDays; // 30 days
  @override
  int get overdueThresholdDays; // 3 days
  @override
  bool get quietHoursEnabled;
  @override
  int get quietHoursStartHour; // 10 PM
  @override
  int get quietHoursEndHour; // 8 AM
  @override
  bool get soundEnabled;
  @override
  bool get vibrationEnabled;
  @override
  DateTime? get lastDailySummary;
  @override
  DateTime? get lastOverdueCheck;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
