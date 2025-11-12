import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/expenses/data/repository/expense_repository.dart';
import 'package:chat_app/feature/expenses/presentation/controller/expense_controller.dart';
import 'package:chat_app/models/expense.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64,
                      color: isDark ? AppColors.gray600 : AppColors.gray400),
                  const SizedBox(height: 16),
                  Text('No Expenses Recorded', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.textPrimary)),
                ],
              ),
            );
          }

          final totalExpenses = expenses.fold<double>(
              0.0, (double sum, expense) => sum + expense.amount);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? AppColors.cardBackgroundDark : AppColors.gray100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Expenses', style: TextStyle(
                        fontSize: 16, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                    Text('\$${totalExpenses.toStringAsFixed(2)}', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: AppColors.error)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Container(
                      key: ValueKey('expense_${expense.id}'),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
                            blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(expense.description, style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.white : AppColors.textPrimary)),
                              ),
                              Text('\$${expense.amount.toStringAsFixed(2)}', style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold,
                                  color: AppColors.error)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.category, size: 14, color: AppColors.gray500),
                              const SizedBox(width: 4),
                              Text(expense.category.toUpperCase(), style: TextStyle(
                                  fontSize: 12, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: AppColors.gray500),
                              const SizedBox(width: 4),
                              Text(DateFormat('MMM dd, yyyy').format(expense.expenseDate ?? DateTime.now()),
                                  style: TextStyle(fontSize: 12,
                                      color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddExpenseDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final vendorController = TextEditingController();
    String category = 'misc';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['rent', 'utilities', 'salaries', 'parts', 'tools', 'misc']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase())))
                    .toList(),
                onChanged: (val) => category = val!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: vendorController,
                decoration: const InputDecoration(labelText: 'Vendor (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (descriptionController.text.isEmpty || amountController.text.isEmpty) return;
              
              final expense = Expense(
                category: category,
                description: descriptionController.text,
                amount: double.parse(amountController.text),
                vendor: vendorController.text.isEmpty ? null : vendorController.text,
                expenseDate: DateTime.now(),
              );

              ref.read(expenseControllerProvider).createExpense(context, expense);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

