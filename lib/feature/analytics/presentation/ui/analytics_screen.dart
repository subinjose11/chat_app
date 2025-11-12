import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/dashboard/presentation/controller/dashboard_controller.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(dashboardAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: analyticsAsync.when(
        data: (analytics) {
          final profitMargin = analytics['totalRevenue'] as double? ?? 0.0;
          final totalExpenses = analytics['totalExpenses'] as double? ?? 0.0;
          final profit = profitMargin - totalExpenses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profit/Loss Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Net Profit', style: TextStyle(
                          fontSize: 16, color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text('\$${profit.toStringAsFixed(2)}', style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Revenue', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text('\$${profitMargin.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Expenses', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text('\$${totalExpenses.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Revenue Chart
                Text('Revenue Trend', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary)),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                        color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
                        blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 3),
                            const FlSpot(1, 4),
                            const FlSpot(2, 3.5),
                            const FlSpot(3, 5),
                            const FlSpot(4, 4),
                            const FlSpot(5, 6),
                          ],
                          isCurved: true,
                          color: AppColors.primaryBlue,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primaryBlue.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Stats
                Text('Quick Stats', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        isDark, 'Active Orders',
                        '${analytics['activeOrders'] ?? 0}',
                        Icons.build_circle, AppColors.warning),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        isDark, 'Completed',
                        '${analytics['completedOrders'] ?? 0}',
                        Icons.check_circle, AppColors.success),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStatCard(bool isDark, String title, String value, IconData icon, Color color) {
    return Container(
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textPrimary)),
          Text(title, style: TextStyle(
              fontSize: 12, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
        ],
      ),
    );
  }
}

