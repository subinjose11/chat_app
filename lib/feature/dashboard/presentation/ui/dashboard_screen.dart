import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/widget/summary_card.dart';
import 'package:chat_app/core/widget/action_button.dart';
import 'package:chat_app/feature/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(dashboardAnalyticsProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardAnalyticsProvider);
          ref.invalidate(recentActivityProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              analyticsAsync.when(
                data: (analytics) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      SummaryCard(
                        key: const ValueKey('summary_vehicles'),
                        title: 'Vehicles Serviced',
                        value: analytics['totalVehicles']?.toString() ?? '0',
                        icon: Icons.directions_car,
                        iconColor: AppColors.primaryBlue,
                      ),
                      SummaryCard(
                        key: const ValueKey('summary_active'),
                        title: 'Active Orders',
                        value: analytics['activeOrders']?.toString() ?? '0',
                        icon: Icons.build,
                        iconColor: AppColors.warning,
                      ),
                      SummaryCard(
                        key: const ValueKey('summary_pending'),
                        title: 'Pending Jobs',
                        value: analytics['pendingOrders']?.toString() ?? '0',
                        icon: Icons.pending_actions,
                        iconColor: AppColors.info,
                      ),
                      SummaryCard(
                        key: const ValueKey('summary_revenue'),
                        title: 'Revenue (Total)',
                        value: '\$${(analytics['totalRevenue'] ?? 0.0).toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        iconColor: AppColors.success,
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Error loading analytics: ${error.toString()}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(dashboardAnalyticsProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
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
                  // Navigate to vehicles tab
                  ref.read(navIndexProvider.notifier).state = 1;
                },
              ),
              const SizedBox(height: 12),
              ActionButton(
                label: 'Create Order',
                icon: Icons.receipt_long,
                onTap: () {
                  // Navigate to orders tab
                  ref.read(navIndexProvider.notifier).state = 2;
                },
              ),
              const SizedBox(height: 12),
              ActionButton(
                label: 'Generate Report',
                icon: Icons.analytics,
                onTap: () {
                  // Navigate to reports tab
                  ref.read(navIndexProvider.notifier).state = 3;
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
              
              recentActivityAsync.when(
                data: (ordersAsync) {
                  return ordersAsync.when(
                    data: (orders) {
                      if (orders.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'No recent activity',
                              style: TextStyle(
                                color: isDark ? AppColors.gray500 : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }

                      // Show only last 3 activities
                      final recentOrders = orders.take(3).toList();
                  
                      return Column(
                        children: recentOrders.map((order) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildActivityItem(
                              isDark,
                              _getActivityIcon(order.status),
                              _getActivityTitle(order.status),
                              '${order.serviceType} - \$${order.totalCost.toStringAsFixed(2)}',
                              order.createdAt != null 
                                  ? _getTimeAgo(order.createdAt!)
                                  : 'Recently',
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: ${error.toString()}'),
                    ),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text('Error loading activity: ${error.toString()}'),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.build;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.receipt;
    }
  }

  String _getActivityTitle(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Service completed';
      case 'in_progress':
        return 'Service in progress';
      case 'pending':
        return 'New service order';
      default:
        return 'Service order';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
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

