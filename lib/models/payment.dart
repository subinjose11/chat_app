import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    @Default('') String id,
    required String orderId,
    required String customerId,
    required double amount,
    @Default('cash') String paymentMethod, // cash, card, upi, bank_transfer
    @Default('completed') String status, // pending, completed, failed, refunded
    String? transactionId,
    String? notes,
    DateTime? paymentDate,
    DateTime? createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

