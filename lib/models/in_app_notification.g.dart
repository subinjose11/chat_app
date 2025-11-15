// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InAppNotificationImpl _$$InAppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$InAppNotificationImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'info',
      orderId: json['orderId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      customerId: json['customerId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InAppNotificationImplToJson(
        _$InAppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'orderId': instance.orderId,
      'vehicleId': instance.vehicleId,
      'customerId': instance.customerId,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'data': instance.data,
    };
