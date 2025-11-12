import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/payment.dart';

final paymentRepositoryProvider = Provider((ref) {
  return PaymentRepository(
    firestore: FirebaseFirestore.instance,
  );
});

final paymentsStreamProvider = StreamProvider.autoDispose<List<Payment>>((ref) {
  return ref.read(paymentRepositoryProvider).getPaymentsStream();
});

final orderPaymentsStreamProvider = StreamProvider.autoDispose.family<List<Payment>, String>((ref, orderId) {
  return ref.read(paymentRepositoryProvider).getPaymentsByOrderStream(orderId);
});

class PaymentRepository {
  final FirebaseFirestore firestore;

  PaymentRepository({required this.firestore});

  // Create Payment
  Future<void> createPayment(BuildContext context, Payment payment) async {
    try {
      final docId = payment.id.isNotEmpty
          ? payment.id
          : firestore.collection('payments').doc().id;
      final docRef = firestore.collection('payments').doc(docId);
      final paymentWithId = payment.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );
      await docRef.set(paymentWithId.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Payment recorded successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get All Payments Stream
  Stream<List<Payment>> getPaymentsStream() {
    return firestore
        .collection('payments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Payment.fromJson(doc.data());
      }).toList();
    });
  }

  // Get Payments by Order Stream
  Stream<List<Payment>> getPaymentsByOrderStream(String orderId) {
    return firestore
        .collection('payments')
        .where('orderId', isEqualTo: orderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Payment.fromJson(doc.data());
      }).toList();
    });
  }

  // Update Payment
  Future<void> updatePayment(BuildContext context, Payment payment) async {
    try {
      await firestore
          .collection('payments')
          .doc(payment.id)
          .update(payment.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Payment updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Delete Payment
  Future<void> deletePayment(BuildContext context, String paymentId) async {
    try {
      await firestore.collection('payments').doc(paymentId).delete();
      if (context.mounted) {
        showSnackBar(context: context, content: 'Payment deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get Total Revenue
  Future<double> getTotalRevenue() async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .where('status', isEqualTo: 'completed')
          .get();
      double total = 0;
      for (var doc in snapshot.docs) {
        final payment = Payment.fromJson(doc.data());
        total += payment.amount;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get Revenue by Date Range
  Future<double> getRevenueByDateRange(DateTime start, DateTime end) async {
    try {
      final snapshot = await firestore
          .collection('payments')
          .where('status', isEqualTo: 'completed')
          .where('paymentDate', isGreaterThanOrEqualTo: start)
          .where('paymentDate', isLessThanOrEqualTo: end)
          .get();
      double total = 0;
      for (var doc in snapshot.docs) {
        final payment = Payment.fromJson(doc.data());
        total += payment.amount;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }
}

