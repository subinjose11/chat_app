import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/widget/summary_card.dart';
import 'package:chat_app/core/widget/action_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
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
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to AutoTrack Pro',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your workshop efficiently',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                SummaryCard(
                  title: 'Vehicles Serviced',
                  value: '156',
                  icon: Icons.directions_car,
                  iconColor: AppColors.primaryBlue,
                ),
                SummaryCard(
                  title: 'Active Orders',
                  value: '12',
                  icon: Icons.build,
                  iconColor: AppColors.warning,
                ),
                SummaryCard(
                  title: 'Pending Jobs',
                  value: '8',
                  icon: Icons.pending_actions,
                  iconColor: AppColors.info,
                ),
                SummaryCard(
                  title: 'Revenue (Month)',
                  value: '\$12.5K',
                  icon: Icons.attach_money,
                  iconColor: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Add Vehicle',
              icon: Icons.add_circle_outline,
              onTap: () {
                // TODO: Navigate to add vehicle
              },
            ),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Create Order',
              icon: Icons.receipt_long,
              onTap: () {
                // TODO: Navigate to create order
              },
            ),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Generate Report',
              icon: Icons.analytics,
              onTap: () {
                // TODO: Navigate to reports
              },
            ),
            const SizedBox(height: 32),

            // Recent Activity
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              isDark,
              Icons.directions_car,
              'New vehicle added',
              'Honda Civic - ABC 1234',
              '2 hours ago',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              isDark,
              Icons.build,
              'Service completed',
              'Oil change for Toyota Camry',
              '5 hours ago',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              isDark,
              Icons.receipt,
              'Invoice generated',
              'Invoice #1234 - \$450.00',
              '1 day ago',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    bool isDark,
    IconData icon,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 24,
            ),
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
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.gray500 : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

