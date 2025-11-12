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
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

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
  final _laborCostController = TextEditingController();
  final _partsCostController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Parts breakdown
  List<PartItem> _parts = [];
  final _partNameController = TextEditingController();
  final _partCostController = TextEditingController();
  
  // Vehicle & Customer fields
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  
  // Dropdown values
  String? _selectedServiceType;
  final _customServiceTypeController = TextEditingController();
  String _selectedWorkStatus = 'pending';
  String _selectedFuelType = 'Petrol';
  DateTime _selectedDate = DateTime.now();
  
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
      _descriptionController.text = order.description ?? '';
      _partsUsedController.text = order.partsUsed.join(', ');
      _laborCostController.text = order.laborCost.toString();
      _partsCostController.text = order.partsCost.toString();
      _notesController.text = order.notes ?? '';
      _selectedServiceType = order.serviceType.isNotEmpty ? order.serviceType : 'Oil Change';
      _selectedWorkStatus = order.status;
      _selectedDate = order.createdAt ?? DateTime.now();
      
      // Load parts breakdown
      _parts = List<PartItem>.from(order.parts);
      
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
    final labor = double.tryParse(_laborCostController.text) ?? 0;
    final parts = _parts.fold<double>(0, (sum, part) => sum + part.cost);
    return labor + parts;
  }
  
  double get _totalPartsCost {
    return _parts.fold<double>(0, (sum, part) => sum + part.cost);
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
    
    setState(() {
      _parts.add(PartItem(
        name: _partNameController.text,
        cost: cost,
      ));
      _partNameController.clear();
      _partCostController.clear();
    });
  }
  
  void _removePart(int index) {
    setState(() {
      _parts.removeAt(index);
    });
  }

  Future<void> _pickImage(bool isBefore) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        if (isBefore) {
          final currentPhotos = ref.read(beforePhotosProvider);
          ref.read(beforePhotosProvider.notifier).state = [...currentPhotos, image];
        } else {
          final currentPhotos = ref.read(afterPhotosProvider);
          ref.read(afterPhotosProvider.notifier).state = [...currentPhotos, image];
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _removePhoto(int index, bool isBefore) {
    if (isBefore) {
      final currentPhotos = ref.read(beforePhotosProvider);
      final updatedPhotos = List<XFile>.from(currentPhotos)..removeAt(index);
      ref.read(beforePhotosProvider.notifier).state = updatedPhotos;
    } else {
      final currentPhotos = ref.read(afterPhotosProvider);
      final updatedPhotos = List<XFile>.from(currentPhotos)..removeAt(index);
      ref.read(afterPhotosProvider.notifier).state = updatedPhotos;
    }
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
            address: _customerAddressController.text.isNotEmpty ? _customerAddressController.text : null,
            createdAt: DateTime.now(),
          );
          
          ref.read(customerControllerProvider).createCustomer(context, customer);
          
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
          id: widget.existingOrder?.id ?? '', // Keep existing ID or empty for new
          serviceType: finalServiceType,
          description: _descriptionController.text,
          partsUsed: _parts.map((p) => p.name).toList(), // Keep for backward compatibility
          parts: _parts, // New: parts with individual costs
          laborCost: double.tryParse(_laborCostController.text) ?? 0.0,
          partsCost: _totalPartsCost,
          totalCost: _totalCost,
          vehicleId: vehicleId,
          customerId: customerId,
          status: _selectedWorkStatus,
          createdAt: widget.existingOrder?.createdAt ?? DateTime.now(),
          notes: _notesController.text,
        );

        final beforePhotos = ref.read(beforePhotosProvider);
        final afterPhotos = ref.read(afterPhotosProvider);

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
                beforePhotos,
                afterPhotos,
              );
        }

        // Clear the form and photos
        ref.read(beforePhotosProvider.notifier).state = [];
        ref.read(afterPhotosProvider.notifier).state = [];
        
        if (mounted) {
          // Close loading dialog
          Navigator.pop(context);
          // Go back to orders tab
          context.go('/home?index=2');
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
    final beforePhotos = ref.watch(beforePhotosProvider);
    final afterPhotos = ref.watch(afterPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingOrder != null ? 'Edit Service Order' : 'Create Service Order'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle & Customer Information Section (Only for new orders)
              if (widget.existingOrder == null) ...[
                Text(
                  'Vehicle & Customer Information',
                  style: TextStyle(
                    fontSize: 18,
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
                    hintText: 'Enter customer name',
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
                    labelText: 'Customer Phone',
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Enter phone number',
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
                  decoration: const InputDecoration(
                    labelText: 'Customer Address',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Enter address',
                  ),
                  maxLines: 2,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 16),
                
                // Vehicle Number
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number',
                    prefixIcon: Icon(Icons.confirmation_number),
                    hintText: 'e.g., ABC 1234',
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
                
                // Vehicle Make
                TextFormField(
                  controller: _vehicleMakeController,
                  decoration: const InputDecoration(
                    labelText: 'Make/Brand',
                    prefixIcon: Icon(Icons.directions_car),
                    hintText: 'e.g., Honda, Toyota',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle make';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Vehicle Model
                TextFormField(
                  controller: _vehicleModelController,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    prefixIcon: Icon(Icons.car_repair),
                    hintText: 'e.g., Civic, Camry',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Vehicle Year
                TextFormField(
                  controller: _vehicleYearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'e.g., 2020',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter year';
                    }
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Fuel Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedFuelType,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Type',
                    prefixIcon: Icon(Icons.local_gas_station),
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
                const SizedBox(height: 24),
              ],
              
              // Service Information Section
              Text(
                'Service Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Service Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: const InputDecoration(
                  labelText: 'Service Type',
                  prefixIcon: Icon(Icons.build),
                  hintText: 'Select service type',
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
                  decoration: const InputDecoration(
                    labelText: 'Custom Service Type',
                    hintText: 'Enter custom service type',
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (_selectedServiceType == 'Other' && (value == null || value.isEmpty)) {
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the service work...',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Work Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedWorkStatus,
                decoration: const InputDecoration(
                  labelText: 'Work Status',
                  prefixIcon: Icon(Icons.query_stats),
                ),
                items: _workStatuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_formatStatus(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWorkStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Cost Section
              Text(
                'Cost Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Labor Cost
              TextFormField(
                controller: _laborCostController,
                decoration: const InputDecoration(
                  labelText: 'Labor Cost',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.engineering),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  setState(() {}); // Update total
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Parts Breakdown Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Parts Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  if (_parts.isNotEmpty)
                    Text(
                      'Total: \$${_totalPartsCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Parts List
              if (_parts.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _parts.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark ? AppColors.gray700 : AppColors.gray300,
                    ),
                    itemBuilder: (context, index) {
                      final part = _parts[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.build_circle, size: 20),
                        title: Text(
                          part.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.white : AppColors.textPrimary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${part.cost.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: AppColors.error,
                              onPressed: () => _removePart(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              
              // Add Part Form
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _partNameController,
                      decoration: const InputDecoration(
                        labelText: 'Part Name',
                        hintText: 'e.g., Oil Filter',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _partCostController,
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        hintText: '0.00',
                        prefixText: '\$ ',
                        isDense: true,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addPart,
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primaryBlue,
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total Cost Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Cost',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Before Photos
              Text(
                'Before Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildPhotoSection(beforePhotos, true, isDark),
              const SizedBox(height: 24),

              // After Photos
              Text(
                'After Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildPhotoSection(afterPhotos, false, isDark),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save order first, then navigate to report
                          _submitOrder();
                        }
                      },
                      icon: const Icon(Icons.summarize),
                      label: const Text('Generate Report'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitOrder,
                      icon: const Icon(Icons.check),
                      label: Text(widget.existingOrder != null ? 'Update Order' : 'Submit Order'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(List<XFile> photos, bool isBefore, bool isDark) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add Photo Button
          GestureDetector(
            onTap: () => _pickImage(isBefore),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray800 : AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.gray700 : AppColors.gray300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: isDark ? AppColors.gray500 : AppColors.gray400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.gray500 : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Photos
          ...photos.asMap().entries.map((entry) {
            final index = entry.key;
            final photo = entry.value;
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(photo.path),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index, isBefore),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _partsUsedController.dispose();
    _laborCostController.dispose();
    _partsCostController.dispose();
    _notesController.dispose();
    _customServiceTypeController.dispose();
    _partNameController.dispose();
    _partCostController.dispose();
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




