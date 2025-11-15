import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:chat_app/local/notification_history_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(dashboardAnalyticsProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/drawables/app_logo.png',
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text('RN Auto Garage'),
          ],
        ),
        actions: [
          _buildNotificationIcon(ref, context),
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
              //Carousel
              CarouselSlider(
                items: [
                  _buildCarouselCard(
                    context,
                    'assets/drawables/img_01.webp',
                    isDark,
                  ),
                  _buildCarouselCard(
                    context,
                    'assets/drawables/img_02.webp',
                    isDark,
                  ),
                  _buildCarouselCard(
                    context,
                    'assets/drawables/img_03.webp',
                    isDark,
                  ),
                  _buildCarouselCard(
                    context,
                    'assets/drawables/img_04.webp',
                    isDark,
                  ),
                  _buildCarouselCard(
                    context,
                    'assets/drawables/img_05.webp',
                    isDark,
                  ),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              ),
              const SizedBox(height: 16),
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
                      _buildInteractiveSummaryCard(
                        context: context,
                        ref: ref,
                        key: const ValueKey('summary_vehicles'),
                        title: 'Total Vehicles',
                        value: analytics['totalVehicles']?.toString() ?? '0',
                        icon: Icons.directions_car,
                        iconColor: AppColors.primaryBlue,
                        gradient: [
                          AppColors.primaryBlue.withOpacity(0.1),
                          AppColors.primaryBlue.withOpacity(0.05)
                        ],
                        onTap: () =>
                            ref.read(navIndexProvider.notifier).state = 1,
                      ),
                      _buildInteractiveSummaryCard(
                        context: context,
                        ref: ref,
                        key: const ValueKey('summary_active'),
                        title: 'Active Orders',
                        value: analytics['activeOrders']?.toString() ?? '0',
                        icon: Icons.build_circle,
                        iconColor: AppColors.warning,
                        gradient: [
                          AppColors.warning.withOpacity(0.1),
                          AppColors.warning.withOpacity(0.05)
                        ],
                        onTap: () =>
                            ref.read(navIndexProvider.notifier).state = 2,
                      ),
                      _buildInteractiveSummaryCard(
                        context: context,
                        ref: ref,
                        key: const ValueKey('summary_completed'),
                        title: 'Completed',
                        value: analytics['completedOrders']?.toString() ?? '0',
                        icon: Icons.check_circle,
                        iconColor: AppColors.success,
                        gradient: [
                          AppColors.success.withOpacity(0.1),
                          AppColors.success.withOpacity(0.05)
                        ],
                        onTap: () =>
                            ref.read(navIndexProvider.notifier).state = 3,
                      ),
                      _buildInteractiveSummaryCard(
                        context: context,
                        ref: ref,
                        key: const ValueKey('summary_revenue'),
                        title: 'Total Revenue',
                        value:
                            '₹${(analytics['totalRevenue'] ?? 0.0).toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet,
                        iconColor: const Color(0xFF00C853),
                        gradient: [
                          const Color(0xFF00C853).withOpacity(0.1),
                          const Color(0xFF00C853).withOpacity(0.05)
                        ],
                        onTap: () {
                          // Could navigate to payments/analytics
                        },
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
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.error),
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

              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.directions_car_outlined,
                      label: 'Register\nVehicle',
                      color: AppColors.primaryBlue,
                      onTap: () {
                        context.push('/vehicle-registration');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.build_circle_outlined,
                      label: 'Create\nOrder',
                      color: AppColors.warning,
                      onTap: () {
                        context.push('/service-order');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.analytics_outlined,
                      label: 'View\nReports',
                      color: AppColors.success,
                      onTap: () {
                        ref.read(navIndexProvider.notifier).state = 3;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.people_outline,
                      label: 'View\nCustomers',
                      color: AppColors.info,
                      onTap: () {
                        ref.read(navIndexProvider.notifier).state = 4;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Today's Stats
              analyticsAsync.when(
                data: (analytics) {
                  return _buildTodayStats(context, isDark, analytics);
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),

              // Recent Activity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(navIndexProvider.notifier).state = 2;
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View All'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              recentActivityAsync.when(
                data: (ordersAsync) {
                  return ordersAsync.when(
                    data: (orders) {
                      if (orders.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardBackgroundDark
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.gray700
                                  : AppColors.gray300,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: isDark
                                    ? AppColors.gray600
                                    : AppColors.gray400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No recent activity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.gray500
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create a service order to get started',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.gray600
                                      : AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Show only last 5 activities
                      final recentOrders = orders.take(5).toList();

                      return Column(
                        children: recentOrders.map((order) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildActivityItem(
                              context: context,
                              isDark: isDark,
                              icon: _getActivityIcon(order.status),
                              title: _getActivityTitle(order.status),
                              subtitle:
                                  '${order.serviceType} - ₹${order.totalCost.toStringAsFixed(2)}',
                              time: order.createdAt != null
                                  ? _getTimeAgo(order.createdAt!)
                                  : 'Recently',
                              statusColor: _getStatusColor(order.status),
                              onTap: () {
                                context.push('/report-detail', extra: {
                                  'serviceOrder': order,
                                });
                              },
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${error.toString()}'),
                      ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading activity: ${error.toString()}'),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(WidgetRef ref, BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return unreadCountAsync.when(
      data: (unreadCount) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              iconSize: 36,
              onPressed: () {
                context.push('/notifications');
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          context.push('/notifications');
        },
      ),
      error: (error, stack) => IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          context.push('/notifications');
        },
      ),
    );
  }

  Widget _buildTodayStats(
      BuildContext context, bool isDark, Map<String, dynamic> analytics) {
    final todayOrders = analytics['todayOrders'] ?? 0;
    final todayRevenue = analytics['todayRevenue'] ?? 0.0;
    final pendingOrders = analytics['pendingOrders'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.2),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.today,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Today\'s Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.receipt_long,
                  label: 'Orders',
                  value: todayOrders.toString(),
                  color: AppColors.primaryBlue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.gray700 : AppColors.gray300,
              ),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.currency_rupee,
                  label: 'Revenue',
                  value: '₹${todayRevenue.toStringAsFixed(0)}',
                  color: AppColors.success,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.gray700 : AppColors.gray300,
              ),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.pending_actions,
                  label: 'Pending',
                  value: pendingOrders.toString(),
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
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
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.gray500 : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveSummaryCard({
    required BuildContext context,
    required WidgetRef ref,
    required Key key,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        key: key,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark ? AppColors.gray600 : AppColors.gray400,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray400 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.2),
              blurRadius: 6,
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
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.build_circle;
      case 'pending':
        return Icons.pending_actions;
      default:
        return Icons.receipt_long;
    }
  }

  String _getActivityTitle(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Service Completed';
      case 'delivered':
        return 'Service Delivered';
      case 'in_progress':
        return 'In Progress';
      case 'pending':
        return 'Pending Service';
      default:
        return 'Service Order';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return const Color(0xFFFF9800); // Orange - Work in progress
      case 'pending':
        return const Color(0xFF2196F3); // Blue - Waiting to start
      case 'completed':
        return const Color(0xFF4CAF50); // Green - Work finished
      case 'delivered':
        return const Color(0xFF00C853); // Bright Green - Vehicle handed over
      case 'cancelled':
        return const Color(0xFFEF5350); // Red - Service cancelled
      default:
        return AppColors.gray500; // Gray - Unknown status
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildActivityItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.gray700 : AppColors.gray200,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: statusColor,
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
                      color:
                          isDark ? AppColors.gray400 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.gray500 : AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: isDark ? AppColors.gray600 : AppColors.gray400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselCard(
    BuildContext context,
    String imagePath,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : AppColors.gray300.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.gray200,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: AppColors.gray400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
