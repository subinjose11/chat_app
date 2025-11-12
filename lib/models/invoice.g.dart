// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String? ?? '',
      serviceOrderId: json['serviceOrderId'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      invoiceNumber: json['invoiceNumber'] as String? ?? '',
      issueDate: json['issueDate'] == null
          ? null
          : DateTime.parse(json['issueDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unpaid',
      paymentMethod: json['paymentMethod'] as String?,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceOrderId': instance.serviceOrderId,
      'customerId': instance.customerId,
      'vehicleId': instance.vehicleId,
      'invoiceNumber': instance.invoiceNumber,
      'issueDate': instance.issueDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'paidAt': instance.paidAt?.toIso8601String(),
    };
