import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/models/customer.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:go_router/go_router.dart';

class VehicleRegistrationScreen extends ConsumerStatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  ConsumerState<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends ConsumerState<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Customer fields
  final _customerNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerAddressController = TextEditingController();
  
  // Vehicle fields
  final _vehicleNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedFuelType = 'Petrol';
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG'];

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _customerEmailController.dispose();
    _customerAddressController.dispose();
    _vehicleNumberController.dispose();
    _modelController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Generate unique IDs
        final customerId = 'customer_${DateTime.now().millisecondsSinceEpoch}';
        final vehicleId = 'vehicle_${DateTime.now().millisecondsSinceEpoch}';

        // First create customer with generated ID
        final customer = Customer(
          id: customerId,
          name: _customerNameController.text,
          phone: _phoneNumberController.text,
          email: _customerEmailController.text.isEmpty ? '' : _customerEmailController.text,
          address: _customerAddressController.text.isEmpty ? null : _customerAddressController.text,
          createdAt: DateTime.now(),
        );

        // Save customer
        await ref.read(customerControllerProvider).createCustomer(context, customer);
        
        // Small delay to ensure customer is saved
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Create vehicle with proper customer reference
        final vehicle = Vehicle(
          id: vehicleId,
          numberPlate: _vehicleNumberController.text,
          make: _brandController.text,
          model: _modelController.text,
          year: _yearController.text,
          fuelType: _selectedFuelType,
          customerId: customerId,
          serviceStatus: 'active',
          createdAt: DateTime.now(),
        );

        // Save vehicle
        await ref.read(vehicleControllerProvider).createVehicle(context, vehicle);
        
        if (mounted) {
          // Close loading dialog
          Navigator.pop(context);
          
          // Navigate to vehicle details
          context.go('/home');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vehicle registered successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          // Close loading dialog
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error registering vehicle: ${e.toString()}'),
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
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  hintText: 'Enter customer full name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(Icons.phone),
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

              TextFormField(
                controller: _customerEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  hintText: 'Enter email address',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _customerAddressController,
                decoration: const InputDecoration(
                  labelText: 'Address (Optional)',
                  hintText: 'Enter customer address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Vehicle Information Section
              Text(
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'e.g., ABC 1234',
                  prefixIcon: Icon(Icons.confirmation_number),
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

              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  hintText: 'e.g., Honda, Toyota',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter brand';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  hintText: 'e.g., Civic, Camry',
                  prefixIcon: Icon(Icons.car_repair),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: 'e.g., 2020',
                  prefixIcon: Icon(Icons.calendar_today),
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
                items: _fuelTypes.map((fuelType) {
                  return DropdownMenuItem(
                    value: fuelType,
                    child: Text(fuelType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any additional information',
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveVehicle,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Vehicle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

