import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

void _showEditDialog(BuildContext context, WidgetRef ref, Vehicle vehicle) {
  showDialog(
    context: context,
    builder: (context) => _EditVehicleDialog(vehicle: vehicle),
  );
}

class _EditVehicleDialog extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const _EditVehicleDialog({required this.vehicle});

  @override
  ConsumerState<_EditVehicleDialog> createState() => _EditVehicleDialogState();
}

class _EditVehicleDialogState extends ConsumerState<_EditVehicleDialog> {
  final _formKey = GlobalKey<FormState>();

  // Customer fields
  late final TextEditingController _customerNameController;
  late final TextEditingController _customerPhoneController;
  late final TextEditingController _customerEmailController;
  late final TextEditingController _customerAddressController;

  // Vehicle fields
  late final TextEditingController _numberPlateController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _vinController;
  late final TextEditingController _colorController;
  late final TextEditingController _mileageController;
  late String? _fuelType;

  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize customer controllers (will be populated from async data)
    _customerNameController = TextEditingController();
    _customerPhoneController = TextEditingController();
    _customerEmailController = TextEditingController();
    _customerAddressController = TextEditingController();

    // Initialize vehicle controllers
    _numberPlateController =
        TextEditingController(text: widget.vehicle.numberPlate);
    _makeController = TextEditingController(text: widget.vehicle.make);
    _modelController = TextEditingController(text: widget.vehicle.model);
    _yearController = TextEditingController(text: widget.vehicle.year);
    _vinController = TextEditingController(text: widget.vehicle.vin);
    _colorController = TextEditingController(text: widget.vehicle.color);
    _mileageController =
        TextEditingController(text: widget.vehicle.mileage?.toString() ?? '');
    _fuelType = widget.vehicle.fuelType;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _customerAddressController.dispose();
    _numberPlateController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _colorController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _saveChanges(String customerId) async {
    if (_formKey.currentState!.validate()) {
      // Update customer info
      final customerAsync =
          await ref.read(customerStreamProvider(customerId).future);
      if (customerAsync != null) {
        final updatedCustomer = customerAsync.copyWith(
          name: _customerNameController.text,
          phone: _customerPhoneController.text,
          email: _customerEmailController.text,
          address: _customerAddressController.text.isEmpty
              ? null
              : _customerAddressController.text,
        );
        ref
            .read(customerControllerProvider)
            .updateCustomer(context, updatedCustomer);
      }

      // Update vehicle info
      final updatedVehicle = widget.vehicle.copyWith(
        numberPlate: _numberPlateController.text,
        make: _makeController.text,
        model: _modelController.text,
        year: _yearController.text,
        vin: _vinController.text.isEmpty ? null : _vinController.text,
        color: _colorController.text.isEmpty ? null : _colorController.text,
        mileage: _mileageController.text.isEmpty
            ? null
            : int.tryParse(_mileageController.text),
        fuelType: _fuelType,
      );

      // Call vehicle controller to update
      ref
          .read(vehicleControllerProvider)
          .updateVehicle(context, updatedVehicle);

      if (mounted) {
        Navigator.pop(context, updatedVehicle);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customerAsync =
        ref.watch(customerStreamProvider(widget.vehicle.customerId));

    // Load customer data when available
    customerAsync.whenData((customer) {
      if (customer != null && _customerNameController.text.isEmpty) {
        _customerNameController.text = customer.name;
        _customerPhoneController.text = customer.phone;
        _customerEmailController.text = customer.email;
        _customerAddressController.text = customer.address ?? '';
      }
    });

    return AlertDialog(
      title: const Text('Edit Vehicle & Customer'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information Section
                Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Name
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Customer Phone
                TextFormField(
                  controller: _customerPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Customer Email (Optional)
                TextFormField(
                  controller: _customerEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Customer Address (Optional)
                TextFormField(
                  controller: _customerAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Address (Optional)',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Vehicle Specifications Section
                Text(
                  'Vehicle Specifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Number Plate
                TextFormField(
                  controller: _numberPlateController,
                  decoration: const InputDecoration(
                    labelText: 'Number Plate',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number plate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Make
                TextFormField(
                  controller: _makeController,
                  decoration: const InputDecoration(
                    labelText: 'Make/Brand',
                    prefixIcon: Icon(Icons.directions_car),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter make';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Model
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    prefixIcon: Icon(Icons.car_repair),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Year
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year';
                    }
                    final year = int.tryParse(value);
                    if (year == null ||
                        year < 1900 ||
                        year > DateTime.now().year + 1) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fuel Type
                DropdownButtonFormField<String>(
                  value: _fuelType,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Type',
                    prefixIcon: Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(),
                  ),
                  items: _fuelTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _fuelType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // VIN (Optional)
                TextFormField(
                  controller: _vinController,
                  decoration: const InputDecoration(
                    labelText: 'VIN (Optional)',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),

                // Color (Optional)
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color (Optional)',
                    prefixIcon: Icon(Icons.palette),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Mileage (Optional)
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(
                    labelText: 'Mileage (km) (Optional)',
                    prefixIcon: Icon(Icons.speed),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final mileage = int.tryParse(value);
                      if (mileage == null || mileage < 0) {
                        return 'Please enter a valid mileage';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _saveChanges(widget.vehicle.customerId),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}

void _showDeleteConfirmation(
    BuildContext context, WidgetRef ref, Vehicle vehicle) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Vehicle'),
      content: const Text(
          'Are you sure you want to delete this vehicle? This action cannot be undone.'),
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
    final serviceOrdersAsync =
        ref.watch(vehicleServiceOrdersStreamProvider(vehicle.id));

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
                  Consumer(
                    builder: (context, ref, child) {
                      final customerAsync = ref.watch(
                        customerStreamProvider(vehicle.customerId),
                      );

                      return customerAsync.when(
                        data: (customer) {
                          if (customer == null) {
                            return _buildInfoSection(
                              isDark,
                              'Customer Information',
                              [
                                _buildInfoRow(Icons.person, 'Customer ID',
                                    vehicle.customerId),
                              ],
                            );
                          }

                          return _buildInfoSection(
                            isDark,
                            'Customer Information',
                            [
                              _buildInfoRow(
                                  Icons.person, 'Name', customer.name),
                              _buildInfoRow(
                                  Icons.phone, 'Phone', customer.phone),
                              if (customer.email.isNotEmpty)
                                _buildInfoRow(
                                    Icons.email, 'Email', customer.email),
                              if (customer.address != null &&
                                  customer.address!.isNotEmpty)
                                _buildInfoRow(Icons.location_on, 'Address',
                                    customer.address!),
                            ],
                          );
                        },
                        loading: () => _buildInfoSection(
                          isDark,
                          'Customer Information',
                          [
                            _buildInfoRow(Icons.person, 'Loading...', ''),
                          ],
                        ),
                        error: (_, __) => _buildInfoSection(
                          isDark,
                          'Customer Information',
                          [
                            _buildInfoRow(Icons.person, 'Customer ID',
                                vehicle.customerId),
                          ],
                        ),
                      );
                    },
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
                        _buildInfoRow(
                            Icons.speed, 'Mileage', '${vehicle.mileage} km'),
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
                          color:
                              isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      serviceOrdersAsync.when(
                        data: (orders) {
                          if (orders.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return TextButton.icon(
                            onPressed: () {
                              // Navigate to vehicle service history screen
                              context.push('/vehicle-service-history',
                                  extra: vehicle);
                            },
                            icon: const Icon(Icons.history, size: 18),
                            label: const Text('View All'),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Display service orders from Firebase (last 5 only)
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

                      // Show only last 5 orders
                      final last5Orders = orders.take(5).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: last5Orders.length,
                        itemBuilder: (context, index) {
                          final service = last5Orders[index];
                          return Container(
                            key: ValueKey('service_order_${service.id}'),
                            child: _buildTimelineItem(
                                isDark, service, index, context),
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
                    error: (error, stack) {
                      // Log the actual error for debugging
                      print('❌ Error loading service history: $error');
                      print('Stack trace: $stack');

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
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
                              const SizedBox(height: 8),
                              Text(
                                error.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.error.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
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
              color:
                  isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
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
            color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
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
    BuildContext context,
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
                            'vehicle': vehicle,
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
