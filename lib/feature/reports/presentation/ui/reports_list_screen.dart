import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

// Filter Providers
final reportDateFilterProvider = StateProvider<String>((ref) => 'all'); // all, today, week, month
final reportStatusFilterProvider = StateProvider<String>((ref) => 'all'); // all, pending, in_progress, completed, delivered

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ordersAsync = ref.watch(serviceOrdersStreamProvider);
    final dateFilter = ref.watch(reportDateFilterProvider);
    final statusFilter = ref.watch(reportStatusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Active Filters Chips
          if (dateFilter != 'all' || statusFilter != 'all')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (dateFilter != 'all')
                    Chip(
                      label: Text('Date: ${_formatFilter(dateFilter)}'),
                      onDeleted: () {
                        ref.read(reportDateFilterProvider.notifier).state = 'all';
                      },
                    ),
                  if (statusFilter != 'all')
                    Chip(
                      label: Text('Status: ${_formatFilter(statusFilter)}'),
                      onDeleted: () {
                        ref.read(reportStatusFilterProvider.notifier).state = 'all';
                      },
                    ),
                ],
              ),
            ),

          // Reports List
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                // Apply filters
                final filteredOrders = _applyFilters(orders, dateFilter, statusFilter);

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: isDark ? AppColors.gray600 : AppColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Reports Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dateFilter != 'all' || statusFilter != 'all'
                              ? 'Try adjusting your filters'
                              : 'Create your first service order',
                          style: TextStyle(
                            color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return Container(
                      key: ValueKey('report_card_${order.id}'),
                      child: _buildReportCard(context, order, isDark),
                    );
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(serviceOrdersStreamProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ServiceOrder> _applyFilters(List<ServiceOrder> orders, String dateFilter, String statusFilter) {
    var filtered = orders;

    // Apply date filter
    if (dateFilter != 'all') {
      final now = DateTime.now();
      filtered = filtered.where((order) {
        if (order.createdAt == null) return false;
        
        switch (dateFilter) {
          case 'today':
            return order.createdAt!.year == now.year &&
                   order.createdAt!.month == now.month &&
                   order.createdAt!.day == now.day;
          case 'week':
            final weekAgo = now.subtract(const Duration(days: 7));
            return order.createdAt!.isAfter(weekAgo);
          case 'month':
            return order.createdAt!.year == now.year &&
                   order.createdAt!.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    // Apply status filter
    if (statusFilter != 'all') {
      filtered = filtered.where((order) => order.status == statusFilter).toList();
    }

    return filtered;
  }

  Widget _buildReportCard(BuildContext context, ServiceOrder order, bool isDark) {
    return GestureDetector(
      onTap: () {
        context.push('/report-detail', extra: order);
      },
      child: Container(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getStatusIcon(order.status),
                    color: _getStatusColor(order.status),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.serviceType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Order #${order.id.substring(0, 8)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatStatus(order.status),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: isDark ? AppColors.gray500 : AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  order.createdAt != null
                      ? DateFormat('MMM dd, yyyy').format(order.createdAt!)
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.directions_car, size: 14, color: isDark ? AppColors.gray500 : AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Vehicle ID: ${order.vehicleId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'delivered':
        return AppColors.primaryBlue;
      default:
        return AppColors.gray500;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_actions;
      case 'in_progress':
        return Icons.build_circle;
      case 'completed':
        return Icons.check_circle;
      case 'delivered':
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _formatFilter(String filter) {
    return filter.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Reports'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['all', 'today', 'week', 'month'].map((filter) {
                  return FilterChip(
                    label: Text(_formatFilter(filter)),
                    selected: ref.read(reportDateFilterProvider) == filter,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(reportDateFilterProvider.notifier).state = filter;
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['all', 'pending', 'in_progress', 'completed', 'delivered'].map((filter) {
                  return FilterChip(
                    label: Text(_formatFilter(filter)),
                    selected: ref.read(reportStatusFilterProvider) == filter,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(reportStatusFilterProvider.notifier).state = filter;
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(reportDateFilterProvider.notifier).state = 'all';
                ref.read(reportStatusFilterProvider.notifier).state = 'all';
              },
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

