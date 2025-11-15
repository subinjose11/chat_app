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
  ConsumerState<ServiceOrdersListScreen> createState() =>
      _ServiceOrdersListScreenState();
}

class _ServiceOrdersListScreenState
    extends ConsumerState<ServiceOrdersListScreen>
    with SingleTickerProviderStateMixin {
  String? _expandedOrderId;
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _currentStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _currentStatusFilter = 'all';
          break;
        case 1:
          _currentStatusFilter = 'pending';
          break;
        case 2:
          _currentStatusFilter = 'in_progress';
          break;
        case 3:
          _currentStatusFilter = 'completed';
          break;
        case 4:
          _currentStatusFilter = 'delivered';
          break;
      }
    });
    ref.read(orderStatusFilterProvider.notifier).state = _currentStatusFilter;
    ref.read(serviceOrdersPaginationProvider.notifier).refresh();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(serviceOrdersPaginationProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paginationState = ref.watch(serviceOrdersPaginationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Orders'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: isDark ? AppColors.gray900 : AppColors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryBlue,
                ),
                labelColor: AppColors.white,
                unselectedLabelColor:
                    isDark ? AppColors.gray400 : AppColors.gray600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tabs: [
                  _buildTab(
                    'All',
                    Icons.dashboard_rounded,
                    _tabController.index == 0,
                    isDark,
                  ),
                  _buildTab(
                    'Pending',
                    Icons.pending_actions_rounded,
                    _tabController.index == 1,
                    isDark,
                  ),
                  _buildTab(
                    'In Progress',
                    Icons.build_circle_rounded,
                    _tabController.index == 2,
                    isDark,
                  ),
                  _buildTab(
                    'Completed',
                    Icons.check_circle_rounded,
                    _tabController.index == 3,
                    isDark,
                  ),
                  _buildTab(
                    'Delivered',
                    Icons.local_shipping_rounded,
                    _tabController.index == 4,
                    isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Orders List
          Expanded(
            child: paginationState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Error: ${paginationState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(serviceOrdersPaginationProvider.notifier)
                                .refresh();
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
                              color: isDark
                                  ? AppColors.gray600
                                  : AppColors.gray400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Orders Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your first service order',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref
                              .read(serviceOrdersPaginationProvider.notifier)
                              .refresh();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: paginationState.orders.length +
                              (paginationState.hasMore ? 1 : 0),
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

  Widget _buildOrderCard(
      BuildContext context, ServiceOrder order, bool isDark) {
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
              color:
                  isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
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
                            color: isDark
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order #${order.id.substring(0, 8)}',
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                              ? DateFormat('MMM dd, yyyy')
                                  .format(order.createdAt!)
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
                  if ((order.description.isNotEmpty) ||
                      order.partsUsed.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedOrderId =
                              _expandedOrderId == order.id ? null : order.id;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.gray800.withOpacity(0.3)
                              : AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _expandedOrderId == order.id
                                  ? 'Hide Details'
                                  : 'Show Details',
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
                          color: isDark
                              ? AppColors.gray800.withOpacity(0.3)
                              : AppColors.gray100,
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
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textPrimary,
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
                          color: isDark
                              ? AppColors.gray800.withOpacity(0.3)
                              : AppColors.gray100,
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
                                  color: isDark
                                      ? AppColors.gray400
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Parts Used',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...order.partsUsed
                                .map((part) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: isDark
                                                ? AppColors.gray500
                                                : AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              part,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark
                                                    ? AppColors.white
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
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
                  color: valueColor ??
                      (isDark ? AppColors.white : AppColors.textPrimary),
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
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget _buildTab(String label, IconData icon, bool isSelected, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? AppColors.primaryBlue
            : isDark
                ? AppColors.gray800.withOpacity(0.5)
                : AppColors.gray100,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryBlue
              : isDark
                  ? AppColors.gray700
                  : AppColors.gray300,
          width: 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? AppColors.white
                : isDark
                    ? AppColors.gray400
                    : AppColors.gray600,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
