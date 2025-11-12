import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/payments/data/repository/payment_repository.dart';
import 'package:chat_app/feature/payments/presentation/controller/payment_controller.dart';
import 'package:chat_app/models/payment.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paymentsAsync = ref.watch(paymentsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummarySection(isDark, paymentsAsync),
          
          // Payments List
          Expanded(
            child: paymentsAsync.when(
              data: (payments) {
                final filteredPayments = _filterPayments(payments);
                
                if (filteredPayments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment_outlined,
                          size: 64,
                          color: isDark ? AppColors.gray600 : AppColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Payments Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final payment = filteredPayments[index];
                    return _buildPaymentCard(context, payment, isDark);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text('Error: ${error.toString()}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddPaymentDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Payment'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildSummarySection(bool isDark, AsyncValue paymentsAsync) {
    return paymentsAsync.when(
      data: (payments) {
        final completedPayments = payments.where((p) => p.status == 'completed').toList();
        final totalRevenue = completedPayments.fold<double>(
          0.0,
          (double sum, payment) => sum + payment.amount,
        );
        final pendingPayments = payments.where((p) => p.status == 'pending').toList();
        final pendingAmount = pendingPayments.fold<double>(
          0.0,
          (double sum, payment) => sum + payment.amount,
        );

        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  isDark,
                  'Total Revenue',
                  '₹${totalRevenue.toStringAsFixed(2)}',
                  Icons.attach_money,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  isDark,
                  'Pending',
                  '\$${pendingAmount.toStringAsFixed(2)}',
                  Icons.pending_actions,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSummaryCard(
    bool isDark,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment, bool isDark) {
    return Container(
      key: ValueKey('payment_${payment.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(payment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payment.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(payment.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.payment, payment.paymentMethod.toUpperCase(), isDark),
          if (payment.transactionId != null)
            _buildInfoRow(Icons.receipt_long, payment.transactionId!, isDark),
          _buildInfoRow(
            Icons.calendar_today,
            DateFormat('MMM dd, yyyy').format(payment.paymentDate ?? DateTime.now()),
            isDark,
          ),
          if (payment.notes != null && payment.notes!.isNotEmpty)
            _buildInfoRow(Icons.note, payment.notes!, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.gray500 : AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.gray400 : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50); // Green - Payment completed
      case 'pending':
        return const Color(0xFF2196F3); // Blue - Payment pending
      case 'failed':
        return const Color(0xFFEF5350); // Red - Payment failed
      case 'refunded':
        return const Color(0xFFFF9800); // Orange - Payment refunded
      default:
        return AppColors.gray500; // Gray - Unknown status
    }
  }

  List<Payment> _filterPayments(List<Payment> payments) {
    if (_filterStatus == 'all') return payments;
    return payments.where((p) => p.status == _filterStatus).toList();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('all', 'All Payments'),
            _buildFilterOption('completed', 'Completed'),
            _buildFilterOption('pending', 'Pending'),
            _buildFilterOption('failed', 'Failed'),
            _buildFilterOption('refunded', 'Refunded'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _filterStatus,
      onChanged: (val) {
        setState(() => _filterStatus = val!);
        Navigator.pop(context);
      },
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final transactionIdController = TextEditingController();
    String paymentMethod = 'cash';
    String status = 'completed';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['cash', 'card', 'upi', 'bank_transfer']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m.toUpperCase())))
                    .toList(),
                onChanged: (val) => paymentMethod = val!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: transactionIdController,
                decoration: const InputDecoration(labelText: 'Transaction ID (Optional)'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 2,
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
              if (amountController.text.isEmpty) return;
              
              final payment = Payment(
                orderId: '', // Link to order in full implementation
                customerId: '', // Link to customer in full implementation
                amount: double.parse(amountController.text),
                paymentMethod: paymentMethod,
                status: status,
                transactionId: transactionIdController.text.isEmpty
                    ? null
                    : transactionIdController.text,
                notes: notesController.text.isEmpty ? null : notesController.text,
                paymentDate: DateTime.now(),
              );

              ref.read(paymentControllerProvider).createPayment(context, payment);
              Navigator.pop(context);
            },
            child: const Text('Add Payment'),
          ),
        ],
      ),
    );
  }
}

