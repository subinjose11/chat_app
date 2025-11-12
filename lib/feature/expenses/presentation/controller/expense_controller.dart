import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/feature/expenses/data/repository/expense_repository.dart';
import 'package:chat_app/models/expense.dart';

final expenseControllerProvider = Provider((ref) {
  return ExpenseController(
    expenseRepository: ref.read(expenseRepositoryProvider),
  );
});

class ExpenseController {
  final ExpenseRepository expenseRepository;

  ExpenseController({required this.expenseRepository});

  void createExpense(BuildContext context, Expense expense) {
    expenseRepository.createExpense(context, expense);
  }

  void updateExpense(BuildContext context, Expense expense) {
    expenseRepository.updateExpense(context, expense);
  }

  void deleteExpense(BuildContext context, String expenseId) {
    expenseRepository.deleteExpense(context, expenseId);
  }
}

