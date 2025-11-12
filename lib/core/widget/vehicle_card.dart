import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:intl/intl.dart';

class VehicleCard extends ConsumerWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

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
      case 'active':
        return const Color(0xFF1976D2); // Dark Blue - No active service
      case 'cancelled':
        return const Color(0xFFEF5350); // Red - Service cancelled
      default:
        return AppColors.gray500; // Gray - Unknown status
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return 'IN SERVICE';
      case 'pending':
        return 'PENDING';
      case 'completed':
        return 'COMPLETED';
      case 'delivered':
        return 'DELIVERED';
      case 'active':
        return 'AVAILABLE';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get the latest service order for this vehicle
    final serviceOrdersAsync = ref.watch(vehicleServiceOrdersStreamProvider(vehicle.id));
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Vehicle Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(12),
                  image: vehicle.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(vehicle.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: vehicle.imageUrl == null
                    ? const Icon(
                        Icons.directions_car,
                        size: 40,
                        color: AppColors.gray500,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Vehicle Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.numberPlate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark 
                                  ? AppColors.white 
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Dynamic status based on latest service order
                        serviceOrdersAsync.when(
                          data: (orders) {
                            String status = 'active';
                            
                            if (orders.isNotEmpty) {
                              // Try to find the most recent non-completed/delivered order
                              try {
                                final activeOrder = orders.firstWhere(
                                  (order) => order.status != 'completed' && order.status != 'delivered',
                                );
                                status = activeOrder.status;
                              } catch (e) {
                                // If no active order, use the most recent order status
                                status = orders.first.status;
                              }
                            }
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(status),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _formatStatus(status),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(status),
                                ),
                              ),
                            );
                          },
                          loading: () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray500.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          error: (_, __) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor('active').withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor('active'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.make} ${vehicle.model} (${vehicle.year})',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark 
                            ? AppColors.gray400 
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Show last service date from latest order
                    serviceOrdersAsync.when(
                      data: (orders) {
                        if (orders.isEmpty) {
                          return Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: isDark 
                                    ? AppColors.gray500 
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'No service history',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark 
                                      ? AppColors.gray500 
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        }
                        
                        final latestOrder = orders.first;
                        return Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: isDark 
                                  ? AppColors.gray500 
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              latestOrder.createdAt != null
                                  ? 'Last Service: ${DateFormat('MMM dd, yyyy').format(latestOrder.createdAt!)}'
                                  : 'Recent service',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark 
                                    ? AppColors.gray500 
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isDark 
                                ? AppColors.gray500 
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark 
                                  ? AppColors.gray500 
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      error: (_, __) => Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isDark 
                                ? AppColors.gray500 
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'No service history',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark 
                                  ? AppColors.gray500 
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.gray500 : AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

