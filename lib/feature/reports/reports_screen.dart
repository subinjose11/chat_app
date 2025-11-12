import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'month'; // month, week, year
  
  // Sample data - replace with actual data from backend
  final Map<String, dynamic> _monthlyStats = {
    'revenue': 12450.00,
    'expenses': 5680.00,
    'profit': 6770.00,
    'orders': 45,
    'completedOrders': 38,
    'pendingOrders': 7,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profit = _monthlyStats['profit'] as double;
    final isProfitable = profit >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              _showPeriodSelector(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPeriodTitle(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.white),
                    onPressed: () {
                      _showPeriodSelector(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Financial Summary
            Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildFinancialCard(
              isDark,
              'Revenue',
              _monthlyStats['revenue'],
              Icons.trending_up,
              AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildFinancialCard(
              isDark,
              'Expenses',
              _monthlyStats['expenses'],
              Icons.trending_down,
              AppColors.error,
            ),
            const SizedBox(height: 12),
            _buildFinancialCard(
              isDark,
              'Net Profit',
              profit,
              isProfitable ? Icons.attach_money : Icons.money_off,
              isProfitable ? AppColors.primaryBlue : AppColors.error,
            ),
            const SizedBox(height: 24),

            // Order Statistics
            Text(
              'Order Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    isDark,
                    'Total Orders',
                    _monthlyStats['orders'].toString(),
                    Icons.receipt_long,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    isDark,
                    'Completed',
                    _monthlyStats['completedOrders'].toString(),
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    isDark,
                    'Pending',
                    _monthlyStats['pendingOrders'].toString(),
                    Icons.pending,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    isDark,
                    'Avg. Value',
                    '\$${(_monthlyStats['revenue'] / _monthlyStats['orders']).toStringAsFixed(0)}',
                    Icons.attach_money,
                    AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Generate Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildReportButton(
              isDark,
              'Monthly Revenue Report',
              'Generate detailed revenue breakdown',
              Icons.summarize,
              () => _generateReport('revenue'),
            ),
            const SizedBox(height: 12),
            _buildReportButton(
              isDark,
              'Service History Report',
              'Export all service records',
              Icons.history,
              () => _generateReport('service'),
            ),
            const SizedBox(height: 12),
            _buildReportButton(
              isDark,
              'Customer Report',
              'Generate customer analytics',
              Icons.people,
              () => _generateReport('customer'),
            ),
            const SizedBox(height: 12),
            _buildReportButton(
              isDark,
              'Expense Report',
              'Track all business expenses',
              Icons.money_off,
              () => _generateReport('expense'),
            ),
            const SizedBox(height: 24),

            // Recent Invoices
            Text(
              'Recent Invoices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInvoiceCard(isDark, 'INV-2024-001', '\$450.00', 'Paid', DateTime(2024, 11, 10)),
            const SizedBox(height: 12),
            _buildInvoiceCard(isDark, 'INV-2024-002', '\$285.00', 'Paid', DateTime(2024, 11, 9)),
            const SizedBox(height: 12),
            _buildInvoiceCard(isDark, 'INV-2024-003', '\$725.00', 'Pending', DateTime(2024, 11, 8)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getPeriodTitle() {
    switch (_selectedPeriod) {
      case 'week':
        return 'Weekly Report';
      case 'year':
        return 'Annual Report';
      case 'month':
      default:
        return 'Monthly Report';
    }
  }

  void _showPeriodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_view_week),
                title: const Text('Weekly'),
                onTap: () {
                  setState(() => _selectedPeriod = 'week');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_month),
                title: const Text('Monthly'),
                onTap: () {
                  setState(() => _selectedPeriod = 'month');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Yearly'),
                onTap: () {
                  setState(() => _selectedPeriod = 'year');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancialCard(
    bool isDark,
    String title,
    double amount,
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
            color: isDark
                ? Colors.black26
                : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.gray400
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
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
            color: isDark
                ? Colors.black26
                : AppColors.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.gray400 : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(
    bool isDark,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray300,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.download, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(
    bool isDark,
    String invoiceNumber,
    String amount,
    String status,
    DateTime date,
  ) {
    final statusColor = status == 'Paid' ? AppColors.success : AppColors.warning;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoiceNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.gray400
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.share, size: 20),
            onPressed: () {
              // TODO: Share invoice
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _generateReport(String type) {
    // TODO: Implement actual report generation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating ${type} report...')),
    );
  }
}

