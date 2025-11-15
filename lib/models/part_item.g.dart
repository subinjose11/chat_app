// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartItemImpl _$$PartItemImplFromJson(Map<String, dynamic> json) =>
    _$PartItemImpl(
      name: json['name'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$PartItemImplToJson(_$PartItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'quantity': instance.quantity,
    };
