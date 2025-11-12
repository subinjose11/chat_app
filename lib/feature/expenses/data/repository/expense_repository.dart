import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/expense.dart';

final expenseRepositoryProvider = Provider((ref) {
  return ExpenseRepository(
    firestore: FirebaseFirestore.instance,
  );
});

final expensesStreamProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  return ref.read(expenseRepositoryProvider).getExpensesStream();
});

class ExpenseRepository {
  final FirebaseFirestore firestore;

  ExpenseRepository({required this.firestore});

  // Create Expense
  Future<void> createExpense(BuildContext context, Expense expense) async {
    try {
      final docId = expense.id.isNotEmpty
          ? expense.id
          : firestore.collection('expenses').doc().id;
      final docRef = firestore.collection('expenses').doc(docId);
      final expenseWithId = expense.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );
      await docRef.set(expenseWithId.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Expense added successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get All Expenses Stream
  Stream<List<Expense>> getExpensesStream() {
    return firestore
        .collection('expenses')
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromJson(doc.data());
      }).toList();
    });
  }

  // Update Expense
  Future<void> updateExpense(BuildContext context, Expense expense) async {
    try {
      await firestore
          .collection('expenses')
          .doc(expense.id)
          .update(expense.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Expense updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Delete Expense
  Future<void> deleteExpense(BuildContext context, String expenseId) async {
    try {
      await firestore.collection('expenses').doc(expenseId).delete();
      if (context.mounted) {
        showSnackBar(context: context, content: 'Expense deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get Total Expenses
  Future<double> getTotalExpenses() async {
    try {
      final snapshot = await firestore.collection('expenses').get();
      double total = 0;
      for (var doc in snapshot.docs) {
        final expense = Expense.fromJson(doc.data());
        total += expense.amount;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get Expenses by Date Range
  Future<double> getExpensesByDateRange(DateTime start, DateTime end) async {
    try {
      final snapshot = await firestore
          .collection('expenses')
          .where('expenseDate', isGreaterThanOrEqualTo: start)
          .where('expenseDate', isLessThanOrEqualTo: end)
          .get();
      double total = 0;
      for (var doc in snapshot.docs) {
        final expense = Expense.fromJson(doc.data());
        total += expense.amount;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }
}

