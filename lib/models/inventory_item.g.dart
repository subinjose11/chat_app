// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      partNumber: json['partNumber'] as String,
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      minStockLevel: (json['minStockLevel'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      supplier: json['supplier'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      lastRestocked: json['lastRestocked'] == null
          ? null
          : DateTime.parse(json['lastRestocked'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'partNumber': instance.partNumber,
      'description': instance.description,
      'quantity': instance.quantity,
      'minStockLevel': instance.minStockLevel,
      'unitPrice': instance.unitPrice,
      'supplier': instance.supplier,
      'category': instance.category,
      'location': instance.location,
      'lastRestocked': instance.lastRestocked?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
