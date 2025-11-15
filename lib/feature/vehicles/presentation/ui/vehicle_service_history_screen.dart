import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class VehicleServiceHistoryScreen extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const VehicleServiceHistoryScreen({
    super.key,
    required this.vehicle,
  });

  @override
  ConsumerState<VehicleServiceHistoryScreen> createState() =>
      _VehicleServiceHistoryScreenState();
}

class _VehicleServiceHistoryScreenState
    extends ConsumerState<VehicleServiceHistoryScreen> {
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(vehicleServiceOrdersPaginationProvider(widget.vehicle.id)
              .notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paginationState =
        ref.watch(vehicleServiceOrdersPaginationProvider(widget.vehicle.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Service History - ${widget.vehicle.numberPlate}'),
      ),
      body: paginationState.isLoading && paginationState.orders.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : paginationState.orders.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: isDark ? AppColors.gray600 : AppColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No service history',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark
                                ? AppColors.gray500
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    ref
                        .read(vehicleServiceOrdersPaginationProvider(
                                widget.vehicle.id)
                            .notifier)
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

                      final service = paginationState.orders[index];
                      return _buildTimelineItem(isDark, service, index);
                    },
                  ),
                ),
    );
  }

  Widget _buildTimelineItem(
    bool isDark,
    ServiceOrder service,
    int index,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getServiceStatusColor(service.status),
                  shape: BoxShape.circle,
                ),
              ),
              // Show line connector except for last item (handled by ListView)
              Expanded(
                child: Container(
                  width: 2,
                  color: isDark ? AppColors.gray700 : AppColors.gray300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Service info
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.gray700 : AppColors.gray300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with service type and cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.serviceType,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '₹${service.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isDark ? AppColors.gray400 : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Status Badge and Date
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getServiceStatusColor(service.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _getServiceStatusColor(service.status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _formatStatus(service.status),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getServiceStatusColor(service.status),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Date
                      if (service.createdAt != null)
                        Text(
                          DateFormat('MMM dd, yyyy').format(service.createdAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDark ? AppColors.gray500 : AppColors.textHint,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit Button
                      OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to edit service order
                          context.push('/service-order-edit', extra: service);
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Report Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to report detail screen
                          context.push('/report-detail', extra: {
                            'serviceOrder': service,
                            'vehicle': widget.vehicle,
                          });
                        },
                        icon: const Icon(Icons.description, size: 16),
                        label: const Text('Report'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getServiceStatusColor(String status) {
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
}

