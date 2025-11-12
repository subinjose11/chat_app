import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    @Default('') String id,
    @Default('') String serviceOrderId,
    @Default('') String customerId,
    @Default('') String vehicleId,
    @Default('') String invoiceNumber,
    DateTime? issueDate,
    DateTime? dueDate,
    @Default(0.0) double subtotal,
    @Default(0.0) double tax,
    @Default(0.0) double discount,
    @Default(0.0) double totalAmount,
    @Default('unpaid') String status, // 'paid', 'unpaid', 'overdue'
    String? paymentMethod,
    DateTime? paidAt,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
