// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceOrder _$ServiceOrderFromJson(Map<String, dynamic> json) {
  return _ServiceOrder.fromJson(json);
}

/// @nodoc
mixin _$ServiceOrder {
  String get id => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get partsUsed =>
      throw _privateConstructorUsedError; // Deprecated: kept for backward compatibility
  @PartItemListConverter()
  List<PartItem> get parts =>
      throw _privateConstructorUsedError; // New: parts with individual costs
  double get laborCost => throw _privateConstructorUsedError;
  double get partsCost => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'in_progress', 'completed', 'cancelled'
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<String> get beforePhotos => throw _privateConstructorUsedError;
  List<String> get afterPhotos => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ServiceOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceOrderCopyWith<ServiceOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceOrderCopyWith<$Res> {
  factory $ServiceOrderCopyWith(
          ServiceOrder value, $Res Function(ServiceOrder) then) =
      _$ServiceOrderCopyWithImpl<$Res, ServiceOrder>;
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String customerId,
      String serviceType,
      String description,
      List<String> partsUsed,
      @PartItemListConverter() List<PartItem> parts,
      double laborCost,
      double partsCost,
      double totalCost,
      String status,
      DateTime? createdAt,
      DateTime? completedAt,
      List<String> beforePhotos,
      List<String> afterPhotos,
      String? notes});
}

/// @nodoc
class _$ServiceOrderCopyWithImpl<$Res, $Val extends ServiceOrder>
    implements $ServiceOrderCopyWith<$Res> {
  _$ServiceOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? customerId = null,
    Object? serviceType = null,
    Object? description = null,
    Object? partsUsed = null,
    Object? parts = null,
    Object? laborCost = null,
    Object? partsCost = null,
    Object? totalCost = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? beforePhotos = null,
    Object? afterPhotos = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      partsUsed: null == partsUsed
          ? _value.partsUsed
          : partsUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parts: null == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartItem>,
      laborCost: null == laborCost
          ? _value.laborCost
          : laborCost // ignore: cast_nullable_to_non_nullable
              as double,
      partsCost: null == partsCost
          ? _value.partsCost
          : partsCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beforePhotos: null == beforePhotos
          ? _value.beforePhotos
          : beforePhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      afterPhotos: null == afterPhotos
          ? _value.afterPhotos
          : afterPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceOrderImplCopyWith<$Res>
    implements $ServiceOrderCopyWith<$Res> {
  factory _$$ServiceOrderImplCopyWith(
          _$ServiceOrderImpl value, $Res Function(_$ServiceOrderImpl) then) =
      __$$ServiceOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vehicleId,
      String customerId,
      String serviceType,
      String description,
      List<String> partsUsed,
      @PartItemListConverter() List<PartItem> parts,
      double laborCost,
      double partsCost,
      double totalCost,
      String status,
      DateTime? createdAt,
      DateTime? completedAt,
      List<String> beforePhotos,
      List<String> afterPhotos,
      String? notes});
}

/// @nodoc
class __$$ServiceOrderImplCopyWithImpl<$Res>
    extends _$ServiceOrderCopyWithImpl<$Res, _$ServiceOrderImpl>
    implements _$$ServiceOrderImplCopyWith<$Res> {
  __$$ServiceOrderImplCopyWithImpl(
      _$ServiceOrderImpl _value, $Res Function(_$ServiceOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = null,
    Object? customerId = null,
    Object? serviceType = null,
    Object? description = null,
    Object? partsUsed = null,
    Object? parts = null,
    Object? laborCost = null,
    Object? partsCost = null,
    Object? totalCost = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? beforePhotos = null,
    Object? afterPhotos = null,
    Object? notes = freezed,
  }) {
    return _then(_$ServiceOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      partsUsed: null == partsUsed
          ? _value._partsUsed
          : partsUsed // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parts: null == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartItem>,
      laborCost: null == laborCost
          ? _value.laborCost
          : laborCost // ignore: cast_nullable_to_non_nullable
              as double,
      partsCost: null == partsCost
          ? _value.partsCost
          : partsCost // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beforePhotos: null == beforePhotos
          ? _value._beforePhotos
          : beforePhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      afterPhotos: null == afterPhotos
          ? _value._afterPhotos
          : afterPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceOrderImpl implements _ServiceOrder {
  const _$ServiceOrderImpl(
      {this.id = '',
      this.vehicleId = '',
      this.customerId = '',
      this.serviceType = '',
      this.description = '',
      final List<String> partsUsed = const [],
      @PartItemListConverter() final List<PartItem> parts = const [],
      this.laborCost = 0.0,
      this.partsCost = 0.0,
      this.totalCost = 0.0,
      this.status = 'pending',
      this.createdAt,
      this.completedAt,
      final List<String> beforePhotos = const [],
      final List<String> afterPhotos = const [],
      this.notes})
      : _partsUsed = partsUsed,
        _parts = parts,
        _beforePhotos = beforePhotos,
        _afterPhotos = afterPhotos;

  factory _$ServiceOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceOrderImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String vehicleId;
  @override
  @JsonKey()
  final String customerId;
  @override
  @JsonKey()
  final String serviceType;
  @override
  @JsonKey()
  final String description;
  final List<String> _partsUsed;
  @override
  @JsonKey()
  List<String> get partsUsed {
    if (_partsUsed is EqualUnmodifiableListView) return _partsUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partsUsed);
  }

// Deprecated: kept for backward compatibility
  final List<PartItem> _parts;
// Deprecated: kept for backward compatibility
  @override
  @JsonKey()
  @PartItemListConverter()
  List<PartItem> get parts {
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parts);
  }

// New: parts with individual costs
  @override
  @JsonKey()
  final double laborCost;
  @override
  @JsonKey()
  final double partsCost;
  @override
  @JsonKey()
  final double totalCost;
  @override
  @JsonKey()
  final String status;
// 'pending', 'in_progress', 'completed', 'cancelled'
  @override
  final DateTime? createdAt;
  @override
  final DateTime? completedAt;
  final List<String> _beforePhotos;
  @override
  @JsonKey()
  List<String> get beforePhotos {
    if (_beforePhotos is EqualUnmodifiableListView) return _beforePhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beforePhotos);
  }

  final List<String> _afterPhotos;
  @override
  @JsonKey()
  List<String> get afterPhotos {
    if (_afterPhotos is EqualUnmodifiableListView) return _afterPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_afterPhotos);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'ServiceOrder(id: $id, vehicleId: $vehicleId, customerId: $customerId, serviceType: $serviceType, description: $description, partsUsed: $partsUsed, parts: $parts, laborCost: $laborCost, partsCost: $partsCost, totalCost: $totalCost, status: $status, createdAt: $createdAt, completedAt: $completedAt, beforePhotos: $beforePhotos, afterPhotos: $afterPhotos, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._partsUsed, _partsUsed) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            (identical(other.laborCost, laborCost) ||
                other.laborCost == laborCost) &&
            (identical(other.partsCost, partsCost) ||
                other.partsCost == partsCost) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality()
                .equals(other._beforePhotos, _beforePhotos) &&
            const DeepCollectionEquality()
                .equals(other._afterPhotos, _afterPhotos) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vehicleId,
      customerId,
      serviceType,
      description,
      const DeepCollectionEquality().hash(_partsUsed),
      const DeepCollectionEquality().hash(_parts),
      laborCost,
      partsCost,
      totalCost,
      status,
      createdAt,
      completedAt,
      const DeepCollectionEquality().hash(_beforePhotos),
      const DeepCollectionEquality().hash(_afterPhotos),
      notes);

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceOrderImplCopyWith<_$ServiceOrderImpl> get copyWith =>
      __$$ServiceOrderImplCopyWithImpl<_$ServiceOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceOrderImplToJson(
      this,
    );
  }
}

abstract class _ServiceOrder implements ServiceOrder {
  const factory _ServiceOrder(
      {final String id,
      final String vehicleId,
      final String customerId,
      final String serviceType,
      final String description,
      final List<String> partsUsed,
      @PartItemListConverter() final List<PartItem> parts,
      final double laborCost,
      final double partsCost,
      final double totalCost,
      final String status,
      final DateTime? createdAt,
      final DateTime? completedAt,
      final List<String> beforePhotos,
      final List<String> afterPhotos,
      final String? notes}) = _$ServiceOrderImpl;

  factory _ServiceOrder.fromJson(Map<String, dynamic> json) =
      _$ServiceOrderImpl.fromJson;

  @override
  String get id;
  @override
  String get vehicleId;
  @override
  String get customerId;
  @override
  String get serviceType;
  @override
  String get description;
  @override
  List<String> get partsUsed; // Deprecated: kept for backward compatibility
  @override
  @PartItemListConverter()
  List<PartItem> get parts; // New: parts with individual costs
  @override
  double get laborCost;
  @override
  double get partsCost;
  @override
  double get totalCost;
  @override
  String get status; // 'pending', 'in_progress', 'completed', 'cancelled'
  @override
  DateTime? get createdAt;
  @override
  DateTime? get completedAt;
  @override
  List<String> get beforePhotos;
  @override
  List<String> get afterPhotos;
  @override
  String? get notes;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceOrderImplCopyWith<_$ServiceOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
