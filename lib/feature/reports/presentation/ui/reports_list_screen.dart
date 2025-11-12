import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ReportsListScreen extends ConsumerStatefulWidget {
  const ReportsListScreen({super.key});

  @override
  ConsumerState<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends ConsumerState<ReportsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(reportsPaginationProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paginationState = ref.watch(reportsPaginationProvider);
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
                        ref.read(reportsPaginationProvider.notifier).refresh();
                      },
                    ),
                  if (statusFilter != 'all')
                    Chip(
                      label: Text('Status: ${_formatFilter(statusFilter)}'),
                      onDeleted: () {
                        ref.read(reportStatusFilterProvider.notifier).state = 'all';
                        ref.read(reportsPaginationProvider.notifier).refresh();
                      },
                    ),
                ],
              ),
            ),

          // Reports List
          Expanded(
            child: paginationState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Error: ${paginationState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(reportsPaginationProvider.notifier).refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : paginationState.orders.isEmpty && !paginationState.isLoading
                    ? Center(
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
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.read(reportsPaginationProvider.notifier).refresh();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: paginationState.orders.length + (paginationState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == paginationState.orders.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final order = paginationState.orders[index];
                            return Container(
                              key: ValueKey('report_card_${order.id}'),
                              child: _buildReportCard(context, order, isDark),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
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
                        '₹${order.totalCost.toStringAsFixed(2)}',
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
                  child: Consumer(
                    builder: (context, ref, child) {
                      final vehicleAsync = ref.watch(
                        vehicleStreamProvider(order.vehicleId),
                      );
                      
                      return vehicleAsync.when(
                        data: (vehicle) => Text(
                          vehicle?.numberPlate ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        loading: () => Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                          ),
                        ),
                        error: (_, __) => Text(
                          'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
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
                ref.read(reportsPaginationProvider.notifier).refresh();
              },
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(reportsPaginationProvider.notifier).refresh();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

