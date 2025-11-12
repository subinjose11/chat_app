import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

void _showEditDialog(BuildContext context, WidgetRef ref, Vehicle vehicle) {
  // TODO: Implement edit dialog with form
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Edit functionality - To be implemented')),
  );
}

void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Vehicle vehicle) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Vehicle'),
      content: const Text('Are you sure you want to delete this vehicle? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // ref.read(vehicleControllerProvider).deleteVehicle(context, vehicle.id);
            Navigator.pop(context);
            context.pop(); // Go back to list
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

class VehicleDetailScreen extends ConsumerWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Fetch actual service orders from Firebase
    final serviceOrdersAsync = ref.watch(vehicleServiceOrdersStreamProvider(vehicle.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.numberPlate),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(context, ref, vehicle);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, ref, vehicle);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                image: vehicle.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(vehicle.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: vehicle.imageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.directions_car,
                        size: 80,
                        color: AppColors.gray500,
                      ),
                    )
                  : null,
            ),

            // Vehicle Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Info Card
                  _buildInfoSection(
                    isDark,
                    'Customer Information',
                    [
                      _buildInfoRow(Icons.person, 'Customer ID', vehicle.customerId),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Specs Card
                  _buildInfoSection(
                    isDark,
                    'Vehicle Specifications',
                    [
                      _buildInfoRow(Icons.confirmation_number, 'Number Plate',
                          vehicle.numberPlate),
                      _buildInfoRow(Icons.directions_car, 'Make & Model',
                          '${vehicle.make} ${vehicle.model}'),
                      _buildInfoRow(Icons.calendar_today, 'Year', vehicle.year),
                      if (vehicle.fuelType != null)
                        _buildInfoRow(Icons.local_gas_station, 'Fuel Type',
                            vehicle.fuelType!),
                      if (vehicle.vin != null)
                        _buildInfoRow(Icons.numbers, 'VIN', vehicle.vin!),
                      if (vehicle.color != null)
                        _buildInfoRow(Icons.palette, 'Color', vehicle.color!),
                      if (vehicle.mileage != null)
                        _buildInfoRow(Icons.speed, 'Mileage',
                            '${vehicle.mileage} km'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service Status
                  Row(
                    children: [
                      Text(
                        'Service Status:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(vehicle.serviceStatus).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vehicle.serviceStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(vehicle.serviceStatus),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service History Timeline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Show all history
                        },
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Display service orders from Firebase
                  serviceOrdersAsync.when(
                    data: (orders) {
                      if (orders.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 48,
                                  color: isDark
                                      ? AppColors.gray600
                                      : AppColors.gray400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No service history',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.gray500
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final service = orders[index];
                          return Container(
                            key: ValueKey('service_order_${service.id}'),
                            child: _buildTimelineItem(isDark, service, index),
                          );
                        },
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
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading service history',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.gray400
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black26
                  : AppColors.gray300.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            context.push('/service-order', extra: vehicle);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Service'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'in_progress':
        return AppColors.warning;
      case 'pending':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }

  Widget _buildInfoSection(
    bool isDark,
    String title,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.gray500),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
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
              // Always show line connector except for last item (handled by ListView)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.serviceType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '\$${service.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.gray400
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (service.createdAt != null)
                    Text(
                      DateFormat('MMM dd, yyyy').format(service.createdAt!),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.gray500 : AppColors.textHint,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getServiceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return AppColors.warning;
      case 'pending':
        return AppColors.info;
      default:
        return AppColors.gray500;
    }
  }
}

