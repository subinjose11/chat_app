import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:intl/intl.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
  });

  // Sample service history - replace with actual data
  List<ServiceOrder> get _serviceHistory => [
        ServiceOrder(
          id: '1',
          vehicleId: vehicle.id,
          customerId: vehicle.customerId,
          serviceType: 'Oil Change',
          description: 'Regular oil change and filter replacement',
          laborCost: 50,
          partsCost: 45,
          totalCost: 95,
          status: 'completed',
          createdAt: DateTime(2024, 10, 15),
          completedAt: DateTime(2024, 10, 15),
        ),
        ServiceOrder(
          id: '2',
          vehicleId: vehicle.id,
          customerId: vehicle.customerId,
          serviceType: 'Brake Service',
          description: 'Front brake pad replacement',
          laborCost: 100,
          partsCost: 150,
          totalCost: 250,
          status: 'completed',
          createdAt: DateTime(2024, 9, 5),
          completedAt: DateTime(2024, 9, 6),
        ),
        ServiceOrder(
          id: '3',
          vehicleId: vehicle.id,
          customerId: vehicle.customerId,
          serviceType: 'Tire Rotation',
          description: 'Rotate and balance all four tires',
          laborCost: 40,
          partsCost: 0,
          totalCost: 40,
          status: 'completed',
          createdAt: DateTime(2024, 8, 10),
          completedAt: DateTime(2024, 8, 10),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.numberPlate),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit vehicle
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
                          color: _getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vehicle.serviceStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(),
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
                  _serviceHistory.isEmpty
                      ? Center(
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
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _serviceHistory.length,
                          itemBuilder: (context, index) {
                            final service = _serviceHistory[index];
                            return _buildTimelineItem(isDark, service, index);
                          },
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
            // TODO: Navigate to create service order
          },
          icon: const Icon(Icons.add),
          label: const Text('Create New Order'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (vehicle.serviceStatus.toLowerCase()) {
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
              if (index < _serviceHistory.length - 1)
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
                  Text(
                    DateFormat('MMM dd, yyyy').format(service.createdAt),
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

