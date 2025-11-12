// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceOrderImpl _$$ServiceOrderImplFromJson(Map<String, dynamic> json) =>
    _$ServiceOrderImpl(
      id: json['id'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      serviceType: json['serviceType'] as String? ?? '',
      description: json['description'] as String? ?? '',
      partsUsed: (json['partsUsed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parts: json['parts'] == null
          ? const []
          : const PartItemListConverter().fromJson(json['parts'] as List?),
      laborCost: (json['laborCost'] as num?)?.toDouble() ?? 0.0,
      partsCost: (json['partsCost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      beforePhotos: (json['beforePhotos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      afterPhotos: (json['afterPhotos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      mechanicNotes: json['mechanicNotes'] as String?,
    );

Map<String, dynamic> _$$ServiceOrderImplToJson(_$ServiceOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'customerId': instance.customerId,
      'serviceType': instance.serviceType,
      'description': instance.description,
      'partsUsed': instance.partsUsed,
      'parts': const PartItemListConverter().toJson(instance.parts),
      'laborCost': instance.laborCost,
      'partsCost': instance.partsCost,
      'totalCost': instance.totalCost,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'beforePhotos': instance.beforePhotos,
      'afterPhotos': instance.afterPhotos,
      'notes': instance.notes,
      'mechanicNotes': instance.mechanicNotes,
    };
