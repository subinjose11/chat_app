import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ServiceOrdersListScreen extends ConsumerStatefulWidget {
  const ServiceOrdersListScreen({super.key});

  @override
  ConsumerState<ServiceOrdersListScreen> createState() => _ServiceOrdersListScreenState();
}

class _ServiceOrdersListScreenState extends ConsumerState<ServiceOrdersListScreen> {
  String? _expandedOrderId;
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
      ref.read(serviceOrdersPaginationProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paginationState = ref.watch(serviceOrdersPaginationProvider);
    final dateFilter = ref.watch(orderDateFilterProvider);
    final statusFilter = ref.watch(orderStatusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Orders'),
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
                        ref.read(orderDateFilterProvider.notifier).state = 'all';
                        ref.read(serviceOrdersPaginationProvider.notifier).refresh();
                      },
                    ),
                  if (statusFilter != 'all')
                    Chip(
                      label: Text('Status: ${_formatFilter(statusFilter)}'),
                      onDeleted: () {
                        ref.read(orderStatusFilterProvider.notifier).state = 'all';
                        ref.read(serviceOrdersPaginationProvider.notifier).refresh();
                      },
                    ),
                ],
              ),
            ),

          // Orders List
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
                            ref.read(serviceOrdersPaginationProvider.notifier).refresh();
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
                              Icons.assignment_outlined,
                              size: 64,
                              color: isDark ? AppColors.gray600 : AppColors.gray400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Orders Found',
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
                          ref.read(serviceOrdersPaginationProvider.notifier).refresh();
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
                              key: ValueKey('order_card_${order.id}'),
                              child: _buildOrderCard(context, order, isDark),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          context.push('/service-order');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }


  Widget _buildOrderCard(BuildContext context, ServiceOrder order, bool isDark) {
    return GestureDetector(
      onTap: () {
        // Navigate to edit screen
        context.push('/service-order-edit', extra: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
          children: [
            // Header with status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: AppColors.white,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatStatus(order.status),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Order details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vehicle and Customer info
                  Row(
                    children: [
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final vehicleAsync = ref.watch(
                              vehicleStreamProvider(order.vehicleId),
                            );
                            
                            return vehicleAsync.when(
                              data: (vehicle) => _buildInfoItem(
                                Icons.directions_car,
                                'Vehicle',
                                vehicle?.numberPlate ?? 'Unknown',
                                isDark,
                              ),
                              loading: () => _buildInfoItem(
                                Icons.directions_car,
                                'Vehicle',
                                'Loading...',
                                isDark,
                              ),
                              error: (_, __) => _buildInfoItem(
                                Icons.directions_car,
                                'Vehicle',
                                'Unknown',
                                isDark,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final customerAsync = ref.watch(
                              customerStreamProvider(order.customerId),
                            );
                            
                            return customerAsync.when(
                              data: (customer) => _buildInfoItem(
                                Icons.person,
                                'Customer',
                                customer?.name ?? 'Unknown',
                                isDark,
                              ),
                              loading: () => _buildInfoItem(
                                Icons.person,
                                'Customer',
                                'Loading...',
                                isDark,
                              ),
                              error: (_, __) => _buildInfoItem(
                                Icons.person,
                                'Customer',
                                'Unknown',
                                isDark,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date and Cost
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.calendar_today,
                          'Date',
                          order.createdAt != null
                              ? DateFormat('MMM dd, yyyy').format(order.createdAt!)
                              : 'N/A',
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.attach_money,
                          'Total Cost',
                          '₹${order.totalCost.toStringAsFixed(2)}',
                          isDark,
                          valueColor: AppColors.primaryBlue,
                          valueWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Expandable Details Button
                  if ((order.description.isNotEmpty) || order.partsUsed.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedOrderId = _expandedOrderId == order.id ? null : order.id;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.gray800.withOpacity(0.3) : AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _expandedOrderId == order.id ? 'Hide Details' : 'Show Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            Icon(
                              _expandedOrderId == order.id 
                                  ? Icons.expand_less 
                                  : Icons.expand_more,
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Expanded Details
                  if (_expandedOrderId == order.id) ...[
                    // Description (if available)
                    if (order.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.gray800.withOpacity(0.3) : AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Parts Used (if available)
                    if (order.partsUsed.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.gray800.withOpacity(0.3) : AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.build,
                                  size: 16,
                                  color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Parts Used',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...order.partsUsed.map((part) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: isDark ? AppColors.gray500 : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      part,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? AppColors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.gray500 : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.gray400 : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueWeight ?? FontWeight.w600,
                  color: valueColor ?? (isDark ? AppColors.white : AppColors.textPrimary),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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
          title: const Text('Filter Orders'),
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
                    selected: ref.read(orderDateFilterProvider) == filter,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(orderDateFilterProvider.notifier).state = filter;
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
                    selected: ref.read(orderStatusFilterProvider) == filter,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(orderStatusFilterProvider.notifier).state = filter;
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
                ref.read(orderDateFilterProvider.notifier).state = 'all';
                ref.read(orderStatusFilterProvider.notifier).state = 'all';
                ref.read(serviceOrdersPaginationProvider.notifier).refresh();
              },
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(serviceOrdersPaginationProvider.notifier).refresh();
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

