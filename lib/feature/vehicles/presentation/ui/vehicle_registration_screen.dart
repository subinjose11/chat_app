import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ConsumerState<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState
    extends ConsumerState<VehicleRegistrationScreen> {
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
  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG'
  ];

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
          email: _customerEmailController.text.isEmpty
              ? ''
              : _customerEmailController.text,
          address: _customerAddressController.text.isEmpty
              ? null
              : _customerAddressController.text,
          createdAt: DateTime.now(),
        );

        // Save customer
        await ref
            .read(customerControllerProvider)
            .createCustomer(context, customer);

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
        await ref
            .read(vehicleControllerProvider)
            .createVehicle(context, vehicle);

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
      backgroundColor: isDark ? AppColors.gray900 : AppColors.gray50,
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              _buildSectionHeader(
                'Customer Information',
                Icons.person_pin_circle,
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
                    TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        hintText: 'Enter customer full name',
                        prefixIcon: const Icon(Icons.person_outline),
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
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        prefixIcon: const Icon(Icons.phone_outlined),
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
                    TextFormField(
                      controller: _customerEmailController,
                      decoration: InputDecoration(
                        labelText: 'Email (Optional)',
                        hintText: 'Enter email address',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.gray700.withOpacity(0.5)
                            : AppColors.gray50,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _customerAddressController,
                      decoration: InputDecoration(
                        labelText: 'Address (Optional)',
                        hintText: 'Enter customer address',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.gray700.withOpacity(0.5)
                            : AppColors.gray50,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Vehicle Information Section
              _buildSectionHeader(
                'Vehicle Information',
                Icons.directions_car,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9]')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => TextEditingValue(
                            text: newValue.text.toUpperCase(),
                            selection: newValue.selection,
                          ),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle number';
                        }
                        // Validate that it contains only uppercase letters and numbers
                        if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                          return 'Only uppercase letters and numbers are allowed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _brandController,
                            decoration: InputDecoration(
                              labelText: 'Brand',
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
                            controller: _modelController,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _yearController,
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Any additional information',
                        prefixIcon: const Icon(Icons.note_outlined),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: isDark
                            ? AppColors.gray700.withOpacity(0.5)
                            : AppColors.gray50,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
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
                  onPressed: _saveVehicle,
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: const Text(
                    'Register Vehicle',
                    style: TextStyle(
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
}
