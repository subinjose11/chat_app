import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/customer.dart';
import 'package:chat_app/models/part_item.dart';
import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:go_router/go_router.dart';

class ServiceOrderScreen extends ConsumerStatefulWidget {
  final Vehicle? vehicle;
  final ServiceOrder? existingOrder; // For editing

  const ServiceOrderScreen({
    super.key,
    this.vehicle,
    this.existingOrder,
  });

  @override
  ConsumerState<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends ConsumerState<ServiceOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Order fields
  final _descriptionController = TextEditingController();
  final _partsUsedController = TextEditingController();
  final _partsCostController = TextEditingController();
  final _notesController = TextEditingController();

  // Parts breakdown
  List<PartItem> _parts = [];
  final _partNameController = TextEditingController();
  final _partCostController = TextEditingController();
  final _partQuantityController = TextEditingController();

  // Labor breakdown
  List<PartItem> _laborItems = [];
  final _laborNameController = TextEditingController();
  final _laborItemCostController = TextEditingController();

  // Vehicle & Customer fields
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();

  // Dropdown values
  String? _selectedServiceType;
  final _customServiceTypeController = TextEditingController();
  String _selectedWorkStatus = 'pending';
  String _selectedFuelType = 'Petrol';

  // Track if editing existing order
  String? _existingVehicleId;
  String? _existingCustomerId;

  final List<String> _serviceTypes = [
    'Oil Change',
    'Brake Service',
    'Engine Repair',
    'Tire Rotation',
    'Battery Replacement',
    'AC Service',
    'General Maintenance',
    'Body Work',
    'Electrical Work',
    'Other',
  ];

  final List<String> _workStatuses = [
    'pending',
    'in_progress',
    'completed',
    'delivered',
    'cancelled',
  ];

  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG',
  ];

  @override
  void initState() {
    super.initState();

    // If editing existing order
    if (widget.existingOrder != null) {
      final order = widget.existingOrder!;
      _existingVehicleId = order.vehicleId;
      _existingCustomerId = order.customerId;
      _descriptionController.text = order.description;
      _partsUsedController.text = order.partsUsed.join(', ');
      _partsCostController.text = order.partsCost.toString();
      _notesController.text = order.notes ?? '';

      // Handle custom service types
      if (order.serviceType.isNotEmpty) {
        if (_serviceTypes.contains(order.serviceType)) {
          // It's a predefined service type
          _selectedServiceType = order.serviceType;
        } else {
          // It's a custom service type
          _selectedServiceType = 'Other';
          _customServiceTypeController.text = order.serviceType;
        }
      }

      _selectedWorkStatus = order.status;

      // Load parts breakdown
      _parts = List<PartItem>.from(order.parts);

      // Load labor breakdown
      if (order.laborItems.isNotEmpty) {
        // Load from new laborItems field
        _laborItems = List<PartItem>.from(order.laborItems);
      } else if (order.laborCost > 0) {
        // Backward compatibility: create a single labor item from old laborCost field
        _laborItems = [
          PartItem(
            name: 'Labor Cost',
            cost: order.laborCost,
          ),
        ];
      }

      // Load vehicle and customer details for editing
      _loadExistingData();
    } else if (widget.vehicle != null) {
      // If creating new order from vehicle
      _existingVehicleId = widget.vehicle!.id;
      _existingCustomerId = widget.vehicle!.customerId;
      _vehicleNumberController.text = widget.vehicle!.numberPlate;
      _vehicleMakeController.text = widget.vehicle!.make;
      _vehicleModelController.text = widget.vehicle!.model;
      _vehicleYearController.text = widget.vehicle!.year;
      _selectedFuelType = widget.vehicle!.fuelType ?? 'Petrol';
    }
  }

  Future<void> _loadExistingData() async {
    // Load vehicle and customer data from Firebase for editing
    // This is a placeholder - implement actual data fetching
  }

  double get _totalCost {
    final labor = _totalLaborCost;
    final parts = _totalPartsCost;
    return labor + parts;
  }

  double get _totalPartsCost {
    return _parts.fold<double>(
        0, (sum, part) => sum + (part.cost * part.quantity));
  }

  double get _totalLaborCost {
    return _laborItems.fold<double>(0, (sum, item) => sum + item.cost);
  }

  void _addPart() {
    if (_partNameController.text.isEmpty || _partCostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter part name and cost')),
      );
      return;
    }

    final cost = double.tryParse(_partCostController.text);
    if (cost == null || cost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid cost')),
      );
      return;
    }

    final quantity = int.tryParse(_partQuantityController.text) ?? 1;
    if (quantity < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    setState(() {
      _parts.add(PartItem(
        name: _partNameController.text,
        cost: cost,
        quantity: quantity,
      ));
      _partNameController.clear();
      _partCostController.clear();
      _partQuantityController.clear();
    });
  }

  void _removePart(int index) {
    setState(() {
      _parts.removeAt(index);
    });
  }

  void _addLabor() {
    if (_laborNameController.text.isEmpty ||
        _laborItemCostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter labor name and cost')),
      );
      return;
    }

    final cost = double.tryParse(_laborItemCostController.text);
    if (cost == null || cost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid cost')),
      );
      return;
    }

    setState(() {
      _laborItems.add(PartItem(
        name: _laborNameController.text,
        cost: cost,
      ));
      _laborNameController.clear();
      _laborItemCostController.clear();
    });
  }

  void _removeLabor(int index) {
    setState(() {
      _laborItems.removeAt(index);
    });
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      // Show loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      String vehicleId = _existingVehicleId ?? '';
      String customerId = _existingCustomerId ?? '';

      try {
        // Create customer and vehicle if new order (not editing)
        if (widget.existingOrder == null && _existingVehicleId == null) {
          // Generate IDs using timestamp
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          customerId = 'customer_$timestamp';
          vehicleId = 'vehicle_$timestamp';

          // Create customer
          final customer = Customer(
            id: customerId,
            name: _customerNameController.text,
            phone: _customerPhoneController.text,
            email: '',
            address: _customerAddressController.text.isNotEmpty
                ? _customerAddressController.text
                : null,
            createdAt: DateTime.now(),
          );

          ref
              .read(customerControllerProvider)
              .createCustomer(context, customer);

          // Create vehicle
          final vehicle = Vehicle(
            id: vehicleId,
            numberPlate: _vehicleNumberController.text,
            make: _vehicleMakeController.text,
            model: _vehicleModelController.text,
            year: _vehicleYearController.text,
            fuelType: _selectedFuelType,
            customerId: customerId,
            serviceStatus: _selectedWorkStatus,
            createdAt: DateTime.now(),
          );

          ref.read(vehicleControllerProvider).createVehicle(context, vehicle);

          // Small delay to ensure Firestore saves complete
          await Future.delayed(const Duration(milliseconds: 500));
        }

        // Determine final service type
        final finalServiceType = _selectedServiceType == 'Other'
            ? _customServiceTypeController.text
            : _selectedServiceType!;

        final serviceOrder = ServiceOrder(
          id: widget.existingOrder?.id ??
              '', // Keep existing ID or empty for new
          serviceType: finalServiceType,
          description: _descriptionController.text,
          partsUsed: _parts
              .map((p) => p.name)
              .toList(), // Keep for backward compatibility
          parts: _parts, // New: parts with individual costs
          laborCost: _totalLaborCost, // Keep for backward compatibility
          laborItems: _laborItems, // New: labor items with individual costs
          partsCost: _totalPartsCost,
          totalCost: _totalCost,
          vehicleId: vehicleId,
          customerId: customerId,
          status: _selectedWorkStatus,
          createdAt: widget.existingOrder?.createdAt ?? DateTime.now(),
          notes: _notesController.text,
        );

        if (widget.existingOrder != null) {
          // Update existing order
          ref.read(serviceOrderControllerProvider).updateServiceOrder(
                context,
                serviceOrder,
              );
        } else {
          // Create new order
          ref.read(serviceOrderControllerProvider).createServiceOrder(
            context,
            serviceOrder,
            [],
            [],
          );
        }

        if (mounted) {
          // Close loading dialog
          Navigator.pop(context);
          // Go back to orders tab
          context.go('/home?index=2');
        }
        // Refresh the list when returning from create screen
        if (mounted) {
          ref.read(serviceOrdersPaginationProvider.notifier).refresh();
        }
      } catch (e) {
        if (mounted) {
          // Close loading dialog
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
      appBar: AppBar(
        title: Text(widget.existingOrder != null
            ? 'Edit Service Order'
            : 'Create Service Order'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle & Customer Information Section (Only for new orders without vehicle context)
              if (widget.existingOrder == null && widget.vehicle == null) ...[
                _buildSectionHeader(
                  'Vehicle & Customer Information',
                  Icons.person_pin_circle,
                  isDark,
                ),
                const SizedBox(height: 16),

                // Customer Information Card
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray800 : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : Colors.grey)
                            .withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
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
                              Icons.person,
                              color: AppColors.primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Customer Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Customer Name
                      TextFormField(
                        controller: _customerNameController,
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: 'Enter customer name',
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray700.withOpacity(0.5)
                              : AppColors.gray50,
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
                        decoration: InputDecoration(
                          labelText: 'Customer Phone',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          hintText: 'Enter phone number',
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray700.withOpacity(0.5)
                              : AppColors.gray50,
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

                      // Customer Address
                      TextFormField(
                        controller: _customerAddressController,
                        decoration: InputDecoration(
                          labelText: 'Customer Address (Optional)',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          hintText: 'Enter address',
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray700.withOpacity(0.5)
                              : AppColors.gray50,
                        ),
                        maxLines: 2,
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Vehicle Information Card
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray800 : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : Colors.grey)
                            .withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: AppColors.success,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Vehicle Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Vehicle Number
                      TextFormField(
                        controller: _vehicleNumberController,
                        decoration: InputDecoration(
                          labelText: 'Vehicle Number',
                          prefixIcon: const Icon(Icons.pin_outlined),
                          hintText: 'e.g., ABC 1234',
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray700.withOpacity(0.5)
                              : AppColors.gray50,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Make and Model Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _vehicleMakeController,
                              decoration: InputDecoration(
                                labelText: 'Make/Brand',
                                hintText: 'e.g., Honda',
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.gray700.withOpacity(0.5)
                                    : AppColors.gray50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _vehicleModelController,
                              decoration: InputDecoration(
                                labelText: 'Model',
                                hintText: 'e.g., Civic',
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.gray700.withOpacity(0.5)
                                    : AppColors.gray50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Year and Fuel Type Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _vehicleYearController,
                              decoration: InputDecoration(
                                labelText: 'Year',
                                hintText: 'e.g., 2020',
                                prefixIcon:
                                    const Icon(Icons.calendar_today_outlined),
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.gray700.withOpacity(0.5)
                                    : AppColors.gray50,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final year = int.tryParse(value);
                                if (year == null ||
                                    year < 1900 ||
                                    year > DateTime.now().year + 1) {
                                  return 'Invalid year';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedFuelType,
                              decoration: InputDecoration(
                                labelText: 'Fuel Type',
                                prefixIcon: const Icon(Icons.local_gas_station),
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.gray700.withOpacity(0.5)
                                    : AppColors.gray50,
                              ),
                              items: _fuelTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFuelType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Work Status Section
              _buildSectionHeader(
                'Work Status',
                Icons.query_stats,
                isDark,
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey)
                          .withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: DropdownButtonFormField<String>(
                  value: _selectedWorkStatus,
                  decoration: InputDecoration(
                    labelText: 'Current Status',
                    prefixIcon: const Icon(Icons.query_stats_outlined),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.gray700.withOpacity(0.5)
                        : AppColors.gray50,
                  ),
                  items: _workStatuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(_formatStatus(status)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkStatus = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Service Information Section
              _buildSectionHeader(
                'Service Information',
                Icons.build_circle,
                isDark,
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey)
                          .withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedServiceType,
                      decoration: InputDecoration(
                        labelText: 'Service Type',
                        prefixIcon: const Icon(Icons.build_outlined),
                        hintText: 'Select service type',
                        filled: true,
                        fillColor: isDark
                            ? AppColors.gray700.withOpacity(0.5)
                            : AppColors.gray50,
                      ),
                      items: _serviceTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedServiceType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a service type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Custom Service Type Input (shown when "Other" is selected)
                    if (_selectedServiceType == 'Other') ...[
                      TextFormField(
                        controller: _customServiceTypeController,
                        decoration: InputDecoration(
                          labelText: 'Custom Service Type',
                          hintText: 'Enter custom service type',
                          prefixIcon: const Icon(Icons.edit_outlined),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.gray700.withOpacity(0.5)
                              : AppColors.gray50,
                        ),
                        validator: (value) {
                          if (_selectedServiceType == 'Other' &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter custom service type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Describe the service work...',
                        prefixIcon: const Icon(Icons.description_outlined),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.gray700.withOpacity(0.5)
                            : AppColors.gray50,
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Cost Section
              _buildSectionHeader(
                'Cost Breakdown',
                Icons.receipt_long,
                isDark,
              ),
              const SizedBox(height: 16),

              // Cost Breakdown Card
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey)
                          .withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Labor Cost Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.gray700.withOpacity(0.3)
                            : AppColors.gray50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
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
                                  Icons.engineering,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Labor Cost',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              if (_laborItems.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '₹${_totalLaborCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Labor Items List
                          if (_laborItems.isNotEmpty) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.gray900.withOpacity(0.5)
                                    : AppColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _laborItems.length,
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: isDark
                                      ? AppColors.gray700
                                      : AppColors.gray300,
                                ),
                                itemBuilder: (context, index) {
                                  final labor = _laborItems[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryBlue
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.handyman,
                                            size: 16,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            labor.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹${labor.cost.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _removeLabor(index),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Add Labor Form
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gray700.withOpacity(0.3)
                                  : AppColors.primaryBlue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.gray600
                                    : AppColors.primaryBlue.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _laborNameController,
                                        decoration: InputDecoration(
                                          labelText: 'Labor Type',
                                          hintText: 'e.g., Engine Repair',
                                          prefixIcon: const Icon(
                                            Icons.handyman,
                                            size: 20,
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: isDark
                                              ? AppColors.gray800
                                              : AppColors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _laborItemCostController,
                                        decoration: InputDecoration(
                                          hintText: '0.00',
                                          prefixIcon: const Icon(
                                            Icons.currency_rupee,
                                            size: 20,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? AppColors.gray800
                                              : AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.gray600
                                                  : AppColors.gray300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryBlue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d{0,2}')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _addLabor,
                                    icon: const Icon(Icons.add, size: 20),
                                    label: const Text('Add Labor'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      foregroundColor: AppColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),

                    // Parts Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.build_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Parts & Materials',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              if (_parts.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '₹${_totalPartsCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Parts List
                          if (_parts.isNotEmpty) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.gray900.withOpacity(0.5)
                                    : AppColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _parts.length,
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: isDark
                                      ? AppColors.gray700
                                      : AppColors.gray300,
                                ),
                                itemBuilder: (context, index) {
                                  final part = _parts[index];
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryBlue
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.inventory_2,
                                            size: 16,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                part.name,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? AppColors.white
                                                      : AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Qty: ${part.quantity}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? AppColors.gray400
                                                      : AppColors.gray600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₹${(part.cost * part.quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _removePart(index),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Add Part Form
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gray800.withOpacity(0.5)
                                  : AppColors.gray50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.gray700
                                    : AppColors.gray300,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add_circle_outline,
                                        color: AppColors.primaryBlue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Add New Part',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Part Name - Full Width
                                TextFormField(
                                  controller: _partNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Part Name',
                                    hintText: 'e.g., Oil Filter',
                                    prefixIcon: const Icon(
                                      Icons.inventory_2_outlined,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? AppColors.gray800
                                        : AppColors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? AppColors.gray600
                                            : AppColors.gray300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryBlue,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Quantity and Cost in Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _partQuantityController,
                                        decoration: InputDecoration(
                                          labelText: 'Quantity',
                                          hintText: '1',
                                          prefixIcon: const Icon(
                                            Icons.numbers,
                                            size: 20,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? AppColors.gray800
                                              : AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.gray600
                                                  : AppColors.gray300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryBlue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _partCostController,
                                        decoration: InputDecoration(
                                          hintText: '0.00',
                                          prefixIcon: const Icon(
                                            Icons.currency_rupee,
                                            size: 20,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? AppColors.gray800
                                              : AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark
                                                  ? AppColors.gray600
                                                  : AppColors.gray300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryBlue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d{0,2}')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Add Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _addPart,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, size: 22),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add Part',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),

                    // Total Cost Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.05),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Labor Cost Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.engineering,
                                    size: 16,
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.gray600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Labor (${_laborItems.length})',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isDark
                                          ? AppColors.gray300
                                          : AppColors.gray700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹${_totalLaborCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.gray300
                                      : AppColors.gray700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Parts Cost Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.build_circle,
                                    size: 16,
                                    color: isDark
                                        ? AppColors.gray400
                                        : AppColors.gray600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Parts (${_parts.length})',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isDark
                                          ? AppColors.gray300
                                          : AppColors.gray700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹${_totalPartsCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.gray300
                                      : AppColors.gray700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            thickness: 1,
                            color:
                                isDark ? AppColors.gray700 : AppColors.gray300,
                          ),
                          const SizedBox(height: 12),
                          // Total Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 20,
                                    color: AppColors.primaryBlue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Total Cost',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryBlue
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '₹${_totalCost.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryBlue.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _submitOrder,
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: Text(
                    widget.existingOrder != null
                        ? 'Update Service Order'
                        : 'Submit Service Order',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.primaryBlue;
      case 'completed':
        return AppColors.success;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.gray500;
    }
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _partsUsedController.dispose();
    _partsCostController.dispose();
    _notesController.dispose();
    _customServiceTypeController.dispose();
    _partNameController.dispose();
    _partCostController.dispose();
    _partQuantityController.dispose();
    _laborNameController.dispose();
    _laborItemCostController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _vehicleNumberController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }
}
