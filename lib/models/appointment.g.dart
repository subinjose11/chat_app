// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String,
      vehicleId: json['vehicleId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      serviceType: json['serviceType'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'scheduled',
      assignedMechanicId: json['assignedMechanicId'] as String?,
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'vehicleId': instance.vehicleId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'serviceType': instance.serviceType,
      'description': instance.description,
      'status': instance.status,
      'assignedMechanicId': instance.assignedMechanicId,
      'estimatedDuration': instance.estimatedDuration,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
