// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      numberPlate: json['numberPlate'] as String? ?? '',
      make: json['make'] as String? ?? '',
      model: json['model'] as String? ?? '',
      year: json['year'] as String? ?? '',
      fuelType: json['fuelType'] as String?,
      vin: json['vin'] as String?,
      color: json['color'] as String?,
      imageUrl: json['imageUrl'] as String?,
      lastServiceDate: json['lastServiceDate'] == null
          ? null
          : DateTime.parse(json['lastServiceDate'] as String),
      serviceStatus: json['serviceStatus'] as String? ?? 'completed',
      mileage: (json['mileage'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'numberPlate': instance.numberPlate,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'fuelType': instance.fuelType,
      'vin': instance.vin,
      'color': instance.color,
      'imageUrl': instance.imageUrl,
      'lastServiceDate': instance.lastServiceDate?.toIso8601String(),
      'serviceStatus': instance.serviceStatus,
      'mileage': instance.mileage,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
