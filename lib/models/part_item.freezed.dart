// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartItem _$PartItemFromJson(Map<String, dynamic> json) {
  return _PartItem.fromJson(json);
}

/// @nodoc
mixin _$PartItem {
  String get name => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;

  /// Serializes this PartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartItemCopyWith<PartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartItemCopyWith<$Res> {
  factory $PartItemCopyWith(PartItem value, $Res Function(PartItem) then) =
      _$PartItemCopyWithImpl<$Res, PartItem>;
  @useResult
  $Res call({String name, double cost});
}

/// @nodoc
class _$PartItemCopyWithImpl<$Res, $Val extends PartItem>
    implements $PartItemCopyWith<$Res> {
  _$PartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cost = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartItemImplCopyWith<$Res>
    implements $PartItemCopyWith<$Res> {
  factory _$$PartItemImplCopyWith(
          _$PartItemImpl value, $Res Function(_$PartItemImpl) then) =
      __$$PartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double cost});
}

/// @nodoc
class __$$PartItemImplCopyWithImpl<$Res>
    extends _$PartItemCopyWithImpl<$Res, _$PartItemImpl>
    implements _$$PartItemImplCopyWith<$Res> {
  __$$PartItemImplCopyWithImpl(
      _$PartItemImpl _value, $Res Function(_$PartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? cost = null,
  }) {
    return _then(_$PartItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartItemImpl implements _PartItem {
  const _$PartItemImpl({this.name = '', this.cost = 0.0});

  factory _$PartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartItemImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final double cost;

  @override
  String toString() {
    return 'PartItem(name: $name, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cost, cost) || other.cost == cost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, cost);

  /// Create a copy of PartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartItemImplCopyWith<_$PartItemImpl> get copyWith =>
      __$$PartItemImplCopyWithImpl<_$PartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartItemImplToJson(
      this,
    );
  }
}

abstract class _PartItem implements PartItem {
  const factory _PartItem({final String name, final double cost}) =
      _$PartItemImpl;

  factory _PartItem.fromJson(Map<String, dynamic> json) =
      _$PartItemImpl.fromJson;

  @override
  String get name;
  @override
  double get cost;

  /// Create a copy of PartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartItemImplCopyWith<_$PartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
