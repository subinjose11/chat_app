// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InAppNotification _$InAppNotificationFromJson(Map<String, dynamic> json) {
  return _InAppNotification.fromJson(json);
}

/// @nodoc
mixin _$InAppNotification {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // new_order, status_change, reminder, summary, overdue
  String? get orderId => throw _privateConstructorUsedError;
  String? get vehicleId => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this InAppNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InAppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InAppNotificationCopyWith<InAppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InAppNotificationCopyWith<$Res> {
  factory $InAppNotificationCopyWith(
          InAppNotification value, $Res Function(InAppNotification) then) =
      _$InAppNotificationCopyWithImpl<$Res, InAppNotification>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String type,
      String? orderId,
      String? vehicleId,
      String? customerId,
      bool isRead,
      DateTime createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$InAppNotificationCopyWithImpl<$Res, $Val extends InAppNotification>
    implements $InAppNotificationCopyWith<$Res> {
  _$InAppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InAppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? orderId = freezed,
    Object? vehicleId = freezed,
    Object? customerId = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InAppNotificationImplCopyWith<$Res>
    implements $InAppNotificationCopyWith<$Res> {
  factory _$$InAppNotificationImplCopyWith(_$InAppNotificationImpl value,
          $Res Function(_$InAppNotificationImpl) then) =
      __$$InAppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String type,
      String? orderId,
      String? vehicleId,
      String? customerId,
      bool isRead,
      DateTime createdAt,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$InAppNotificationImplCopyWithImpl<$Res>
    extends _$InAppNotificationCopyWithImpl<$Res, _$InAppNotificationImpl>
    implements _$$InAppNotificationImplCopyWith<$Res> {
  __$$InAppNotificationImplCopyWithImpl(_$InAppNotificationImpl _value,
      $Res Function(_$InAppNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of InAppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? orderId = freezed,
    Object? vehicleId = freezed,
    Object? customerId = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? data = freezed,
  }) {
    return _then(_$InAppNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleId: freezed == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InAppNotificationImpl implements _InAppNotification {
  const _$InAppNotificationImpl(
      {this.id = '',
      required this.title,
      required this.body,
      this.type = 'info',
      this.orderId,
      this.vehicleId,
      this.customerId,
      this.isRead = false,
      required this.createdAt,
      final Map<String, dynamic>? data})
      : _data = data;

  factory _$InAppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$InAppNotificationImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  @JsonKey()
  final String type;
// new_order, status_change, reminder, summary, overdue
  @override
  final String? orderId;
  @override
  final String? vehicleId;
  @override
  final String? customerId;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime createdAt;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'InAppNotification(id: $id, title: $title, body: $body, type: $type, orderId: $orderId, vehicleId: $vehicleId, customerId: $customerId, isRead: $isRead, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InAppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      body,
      type,
      orderId,
      vehicleId,
      customerId,
      isRead,
      createdAt,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of InAppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InAppNotificationImplCopyWith<_$InAppNotificationImpl> get copyWith =>
      __$$InAppNotificationImplCopyWithImpl<_$InAppNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InAppNotificationImplToJson(
      this,
    );
  }
}

abstract class _InAppNotification implements InAppNotification {
  const factory _InAppNotification(
      {final String id,
      required final String title,
      required final String body,
      final String type,
      final String? orderId,
      final String? vehicleId,
      final String? customerId,
      final bool isRead,
      required final DateTime createdAt,
      final Map<String, dynamic>? data}) = _$InAppNotificationImpl;

  factory _InAppNotification.fromJson(Map<String, dynamic> json) =
      _$InAppNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String get type; // new_order, status_change, reminder, summary, overdue
  @override
  String? get orderId;
  @override
  String? get vehicleId;
  @override
  String? get customerId;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of InAppNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InAppNotificationImplCopyWith<_$InAppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
