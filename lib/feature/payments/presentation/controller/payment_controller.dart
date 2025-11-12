import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/feature/payments/data/repository/payment_repository.dart';
import 'package:chat_app/models/payment.dart';

final paymentControllerProvider = Provider((ref) {
  return PaymentController(
    paymentRepository: ref.read(paymentRepositoryProvider),
  );
});

class PaymentController {
  final PaymentRepository paymentRepository;

  PaymentController({required this.paymentRepository});

  void createPayment(BuildContext context, Payment payment) {
    paymentRepository.createPayment(context, payment);
  }

  void updatePayment(BuildContext context, Payment payment) {
    paymentRepository.updatePayment(context, payment);
  }

  void deletePayment(BuildContext context, String paymentId) {
    paymentRepository.deletePayment(context, paymentId);
  }
}

