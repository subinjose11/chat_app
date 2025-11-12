// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return _Vehicle.fromJson(json);
}

/// @nodoc
mixin _$Vehicle {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get numberPlate => throw _privateConstructorUsedError;
  String get make => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get year => throw _privateConstructorUsedError;
  String? get fuelType => throw _privateConstructorUsedError;
  String? get vin => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get lastServiceDate => throw _privateConstructorUsedError;
  String get serviceStatus =>
      throw _privateConstructorUsedError; // 'active', 'pending', 'completed'
  int? get mileage => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleCopyWith<Vehicle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleCopyWith<$Res> {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) then) =
      _$VehicleCopyWithImpl<$Res, Vehicle>;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String numberPlate,
      String make,
      String model,
      String year,
      String? fuelType,
      String? vin,
      String? color,
      String? imageUrl,
      DateTime? lastServiceDate,
      String serviceStatus,
      int? mileage,
      DateTime? createdAt});
}

/// @nodoc
class _$VehicleCopyWithImpl<$Res, $Val extends Vehicle>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? numberPlate = null,
    Object? make = null,
    Object? model = null,
    Object? year = null,
    Object? fuelType = freezed,
    Object? vin = freezed,
    Object? color = freezed,
    Object? imageUrl = freezed,
    Object? lastServiceDate = freezed,
    Object? serviceStatus = null,
    Object? mileage = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      numberPlate: null == numberPlate
          ? _value.numberPlate
          : numberPlate // ignore: cast_nullable_to_non_nullable
              as String,
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastServiceDate: freezed == lastServiceDate
          ? _value.lastServiceDate
          : lastServiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceStatus: null == serviceStatus
          ? _value.serviceStatus
          : serviceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mileage: freezed == mileage
          ? _value.mileage
          : mileage // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleImplCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$$VehicleImplCopyWith(
          _$VehicleImpl value, $Res Function(_$VehicleImpl) then) =
      __$$VehicleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String numberPlate,
      String make,
      String model,
      String year,
      String? fuelType,
      String? vin,
      String? color,
      String? imageUrl,
      DateTime? lastServiceDate,
      String serviceStatus,
      int? mileage,
      DateTime? createdAt});
}

/// @nodoc
class __$$VehicleImplCopyWithImpl<$Res>
    extends _$VehicleCopyWithImpl<$Res, _$VehicleImpl>
    implements _$$VehicleImplCopyWith<$Res> {
  __$$VehicleImplCopyWithImpl(
      _$VehicleImpl _value, $Res Function(_$VehicleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? numberPlate = null,
    Object? make = null,
    Object? model = null,
    Object? year = null,
    Object? fuelType = freezed,
    Object? vin = freezed,
    Object? color = freezed,
    Object? imageUrl = freezed,
    Object? lastServiceDate = freezed,
    Object? serviceStatus = null,
    Object? mileage = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$VehicleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      numberPlate: null == numberPlate
          ? _value.numberPlate
          : numberPlate // ignore: cast_nullable_to_non_nullable
              as String,
      make: null == make
          ? _value.make
          : make // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastServiceDate: freezed == lastServiceDate
          ? _value.lastServiceDate
          : lastServiceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceStatus: null == serviceStatus
          ? _value.serviceStatus
          : serviceStatus // ignore: cast_nullable_to_non_nullable
              as String,
      mileage: freezed == mileage
          ? _value.mileage
          : mileage // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleImpl implements _Vehicle {
  const _$VehicleImpl(
      {this.id = '',
      this.customerId = '',
      this.numberPlate = '',
      this.make = '',
      this.model = '',
      this.year = '',
      this.fuelType,
      this.vin,
      this.color,
      this.imageUrl,
      this.lastServiceDate,
      this.serviceStatus = 'completed',
      this.mileage,
      this.createdAt});

  factory _$VehicleImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String customerId;
  @override
  @JsonKey()
  final String numberPlate;
  @override
  @JsonKey()
  final String make;
  @override
  @JsonKey()
  final String model;
  @override
  @JsonKey()
  final String year;
  @override
  final String? fuelType;
  @override
  final String? vin;
  @override
  final String? color;
  @override
  final String? imageUrl;
  @override
  final DateTime? lastServiceDate;
  @override
  @JsonKey()
  final String serviceStatus;
// 'active', 'pending', 'completed'
  @override
  final int? mileage;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Vehicle(id: $id, customerId: $customerId, numberPlate: $numberPlate, make: $make, model: $model, year: $year, fuelType: $fuelType, vin: $vin, color: $color, imageUrl: $imageUrl, lastServiceDate: $lastServiceDate, serviceStatus: $serviceStatus, mileage: $mileage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.numberPlate, numberPlate) ||
                other.numberPlate == numberPlate) &&
            (identical(other.make, make) || other.make == make) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.lastServiceDate, lastServiceDate) ||
                other.lastServiceDate == lastServiceDate) &&
            (identical(other.serviceStatus, serviceStatus) ||
                other.serviceStatus == serviceStatus) &&
            (identical(other.mileage, mileage) || other.mileage == mileage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      customerId,
      numberPlate,
      make,
      model,
      year,
      fuelType,
      vin,
      color,
      imageUrl,
      lastServiceDate,
      serviceStatus,
      mileage,
      createdAt);

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      __$$VehicleImplCopyWithImpl<_$VehicleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleImplToJson(
      this,
    );
  }
}

abstract class _Vehicle implements Vehicle {
  const factory _Vehicle(
      {final String id,
      final String customerId,
      final String numberPlate,
      final String make,
      final String model,
      final String year,
      final String? fuelType,
      final String? vin,
      final String? color,
      final String? imageUrl,
      final DateTime? lastServiceDate,
      final String serviceStatus,
      final int? mileage,
      final DateTime? createdAt}) = _$VehicleImpl;

  factory _Vehicle.fromJson(Map<String, dynamic> json) = _$VehicleImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get numberPlate;
  @override
  String get make;
  @override
  String get model;
  @override
  String get year;
  @override
  String? get fuelType;
  @override
  String? get vin;
  @override
  String? get color;
  @override
  String? get imageUrl;
  @override
  DateTime? get lastServiceDate;
  @override
  String get serviceStatus; // 'active', 'pending', 'completed'
  @override
  int? get mileage;
  @override
  DateTime? get createdAt;

  /// Create a copy of Vehicle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleImplCopyWith<_$VehicleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
