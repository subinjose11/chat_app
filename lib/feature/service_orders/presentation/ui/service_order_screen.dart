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
  final ServiceOrder? existingOrder;

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
  final _scrollController = ScrollController();

  // Order fields
  final _descriptionController = TextEditingController();
  final _partsUsedController = TextEditingController();
  final _partsCostController = TextEditingController();
  final _notesController = TextEditingController();
  final _kmRunController = TextEditingController();
  final _advancePaidController = TextEditingController();

  // Parts breakdown
  List<PartItem> _parts = [];
  final _partNameController = TextEditingController();
  final _partCostController = TextEditingController();
  final _partQuantityController = TextEditingController();

  // Labor breakdown
  List<PartItem> _laborItems = [];
  final _laborNameController = TextEditingController();
  final _laborCostController = TextEditingController();

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

  // Review mode
  bool _isReviewMode = false;

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

    if (widget.existingOrder != null) {
      final order = widget.existingOrder!;
      _existingVehicleId = order.vehicleId;
      _existingCustomerId = order.customerId;
      _descriptionController.text = order.description;
      _partsUsedController.text = order.partsUsed.join(', ');
      _partsCostController.text = order.partsCost.toString();
      _notesController.text = order.notes ?? '';

      if (order.serviceType.isNotEmpty) {
        if (_serviceTypes.contains(order.serviceType)) {
          _selectedServiceType = order.serviceType;
        } else {
          _selectedServiceType = 'Other';
          _customServiceTypeController.text = order.serviceType;
        }
      }

      _selectedWorkStatus = order.status;
      _kmRunController.text = order.kmRun?.toString() ?? '';
      _advancePaidController.text =
          order.advancePaid > 0 ? order.advancePaid.toString() : '';

      _parts = List<PartItem>.from(order.parts);

      if (order.laborItems.isNotEmpty) {
        _laborItems = List<PartItem>.from(order.laborItems);
      } else if (order.laborCost > 0) {
        _laborItems = [
          PartItem(name: 'Labor Cost', cost: order.laborCost),
        ];
      }
    } else if (widget.vehicle != null) {
      _existingVehicleId = widget.vehicle!.id;
      _existingCustomerId = widget.vehicle!.customerId;
      _vehicleNumberController.text = widget.vehicle!.numberPlate;
      _vehicleMakeController.text = widget.vehicle!.make;
      _vehicleModelController.text = widget.vehicle!.model;
      _vehicleYearController.text = widget.vehicle!.year;
      _selectedFuelType = widget.vehicle!.fuelType ?? 'Petrol';
    }
  }

  bool get _showCustomerVehicleSections =>
      widget.existingOrder == null && widget.vehicle == null;

  double get _totalCost => _totalLaborCost + _totalPartsCost;

  double get _totalPartsCost {
    return _parts.fold<double>(
        0, (sum, part) => sum + (part.cost * part.quantity));
  }

  double get _totalLaborCost {
    return _laborItems.fold<double>(0, (sum, item) => sum + item.cost);
  }

  double get _advancePaid {
    return double.tryParse(_advancePaidController.text) ?? 0.0;
  }

  double get _balanceAmount => _totalCost - _advancePaid;

  void _addPart() {
    if (_partNameController.text.isEmpty || _partCostController.text.isEmpty) {
      return;
    }
    final cost = double.tryParse(_partCostController.text);
    if (cost == null || cost < 0) return;

    final quantity = int.tryParse(_partQuantityController.text) ?? 1;
    if (quantity < 1) return;

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
    if (_laborNameController.text.isEmpty || _laborCostController.text.isEmpty) {
      return;
    }
    final cost = double.tryParse(_laborCostController.text);
    if (cost == null || cost < 0) return;

    setState(() {
      _laborItems.add(PartItem(
        name: _laborNameController.text,
        cost: cost,
      ));
      _laborNameController.clear();
      _laborCostController.clear();
    });
  }

  void _removeLabor(int index) {
    setState(() {
      _laborItems.removeAt(index);
    });
  }

  void _proceedToReview() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isReviewMode = true);
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String vehicleId = _existingVehicleId ?? '';
    String customerId = _existingCustomerId ?? '';

    try {
      if (widget.existingOrder == null && _existingVehicleId == null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        customerId = 'customer_$timestamp';
        vehicleId = 'vehicle_$timestamp';

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

        ref.read(customerControllerProvider).createCustomer(context, customer);

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
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final finalServiceType = _selectedServiceType == 'Other'
          ? _customServiceTypeController.text
          : _selectedServiceType!;

      final serviceOrder = ServiceOrder(
        id: widget.existingOrder?.id ?? '',
        serviceType: finalServiceType,
        description: _descriptionController.text,
        partsUsed: _parts.map((p) => p.name).toList(),
        parts: _parts,
        laborCost: _totalLaborCost,
        laborItems: _laborItems,
        partsCost: _totalPartsCost,
        totalCost: _totalCost,
        advancePaid: _advancePaid,
        kmRun: _kmRunController.text.isNotEmpty
            ? int.tryParse(_kmRunController.text)
            : null,
        vehicleId: vehicleId,
        customerId: customerId,
        status: _selectedWorkStatus,
        createdAt: widget.existingOrder?.createdAt ?? DateTime.now(),
        notes: _notesController.text,
      );

      if (widget.existingOrder != null) {
        ref.read(serviceOrderControllerProvider).updateServiceOrder(
              context,
              serviceOrder,
            );
      } else {
        ref.read(serviceOrderControllerProvider).createServiceOrder(
          context,
          serviceOrder,
          [],
          [],
        );
      }

      if (mounted) {
        Navigator.pop(context);
        context.go('/home?index=2');
        ref.read(serviceOrdersPaginationProvider.notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.gray900 : AppColors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isReviewMode
              ? 'Review Order'
              : (widget.existingOrder != null
                  ? 'Edit Service Order'
                  : 'New Service Order'),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            _isReviewMode ? Icons.arrow_back : Icons.close,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
          onPressed: () {
            if (_isReviewMode) {
              setState(() => _isReviewMode = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? AppColors.gray800 : AppColors.gray200,
            height: 1,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: _isReviewMode
            ? _buildReviewMode(isDark)
            : _buildFormMode(isDark),
      ),
    );
  }

  Widget _buildFormMode(bool isDark) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer & Vehicle Section
                if (_showCustomerVehicleSections) ...[
                  _buildSectionTitle('Customer & Vehicle', Icons.person_pin_circle, isDark),
                  const SizedBox(height: 12),
                  _buildCard(
                    isDark,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _customerNameController,
                          label: 'Customer Name',
                          hint: 'Enter customer name',
                          icon: Icons.person_outline,
                          isDark: isDark,
                          required: true,
                        ),
                        _buildTextField(
                          controller: _customerPhoneController,
                          label: 'Phone Number',
                          hint: 'Enter phone number',
                          icon: Icons.phone_outlined,
                          isDark: isDark,
                          required: true,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        _buildTextField(
                          controller: _customerAddressController,
                          label: 'Address (Optional)',
                          hint: 'Enter address',
                          icon: Icons.location_on_outlined,
                          isDark: isDark,
                        ),
                        const Divider(height: 24),
                        _buildTextField(
                          controller: _vehicleNumberController,
                          label: 'Vehicle Number',
                          hint: 'e.g., KA01AB1234',
                          icon: Icons.directions_car_outlined,
                          isDark: isDark,
                          required: true,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                            TextInputFormatter.withFunction((oldValue, newValue) =>
                                TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _vehicleMakeController,
                                label: 'Make',
                                hint: 'Honda',
                                isDark: isDark,
                                required: true,
                                showDivider: false,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: _vehicleModelController,
                                label: 'Model',
                                hint: 'City',
                                isDark: isDark,
                                required: true,
                                showDivider: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _vehicleYearController,
                                label: 'Year',
                                hint: '2020',
                                isDark: isDark,
                                required: true,
                                keyboardType: TextInputType.number,
                                showDivider: false,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown(
                                value: _selectedFuelType,
                                items: _fuelTypes,
                                label: 'Fuel Type',
                                isDark: isDark,
                                onChanged: (v) => setState(() => _selectedFuelType = v!),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Service Details Section
                _buildSectionTitle('Service Details', Icons.build_circle_outlined, isDark),
                const SizedBox(height: 12),
                _buildCard(
                  isDark,
                  child: Column(
                    children: [
                      _buildStatusSelector(isDark),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        value: _selectedServiceType,
                        items: _serviceTypes,
                        label: 'Service Type',
                        hint: 'Select service type',
                        isDark: isDark,
                        required: true,
                        onChanged: (v) => setState(() => _selectedServiceType = v),
                      ),
                      if (_selectedServiceType == 'Other') ...[
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _customServiceTypeController,
                          label: 'Custom Service Type',
                          hint: 'Enter service type',
                          isDark: isDark,
                          required: true,
                          showDivider: false,
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Describe the service work...',
                        isDark: isDark,
                        required: true,
                        maxLines: 3,
                        showDivider: false,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _kmRunController,
                        label: 'KM Reading (Optional)',
                        hint: 'Current odometer',
                        icon: Icons.speed_outlined,
                        isDark: isDark,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Labor Section
                _buildSectionTitle(
                  'Labor Charges',
                  Icons.engineering_outlined,
                  isDark,
                  trailing: _laborItems.isNotEmpty
                      ? '\u20B9${_totalLaborCost.toStringAsFixed(0)}'
                      : null,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  isDark,
                  child: Column(
                    children: [
                      ..._laborItems.asMap().entries.map((entry) =>
                          _buildItemTile(
                            entry.value.name,
                            entry.value.cost,
                            null,
                            () => _removeLabor(entry.key),
                            isDark,
                          )),
                      _buildAddItemRow(
                        nameController: _laborNameController,
                        costController: _laborCostController,
                        nameHint: 'Labor type (e.g., Engine Repair)',
                        onAdd: _addLabor,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Parts Section
                _buildSectionTitle(
                  'Parts & Materials',
                  Icons.inventory_2_outlined,
                  isDark,
                  trailing: _parts.isNotEmpty
                      ? '\u20B9${_totalPartsCost.toStringAsFixed(0)}'
                      : null,
                ),
                const SizedBox(height: 12),
                _buildCard(
                  isDark,
                  child: Column(
                    children: [
                      ..._parts.asMap().entries.map((entry) => _buildItemTile(
                            entry.value.name,
                            entry.value.cost * entry.value.quantity,
                            'Qty: ${entry.value.quantity}',
                            () => _removePart(entry.key),
                            isDark,
                          )),
                      _buildAddPartRow(isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Section
                _buildSectionTitle('Payment', Icons.payments_outlined, isDark),
                const SizedBox(height: 12),
                _buildPaymentCard(isDark),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        _buildBottomBar(isDark),
      ],
    );
  }

  Widget _buildReviewMode(bool isDark) {
    final serviceType = _selectedServiceType == 'Other'
        ? _customServiceTypeController.text
        : _selectedServiceType ?? '';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Customer & Vehicle Review
                if (_showCustomerVehicleSections) ...[
                  _buildReviewCard(
                    'Customer',
                    Icons.person_outline,
                    [
                      _ReviewRow('Name', _customerNameController.text),
                      _ReviewRow('Phone', _customerPhoneController.text),
                      if (_customerAddressController.text.isNotEmpty)
                        _ReviewRow('Address', _customerAddressController.text),
                    ],
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildReviewCard(
                    'Vehicle',
                    Icons.directions_car_outlined,
                    [
                      _ReviewRow('Number', _vehicleNumberController.text),
                      _ReviewRow('Make & Model',
                          '${_vehicleMakeController.text} ${_vehicleModelController.text}'),
                      _ReviewRow('Year', _vehicleYearController.text),
                      _ReviewRow('Fuel', _selectedFuelType),
                    ],
                    isDark,
                  ),
                  const SizedBox(height: 12),
                ],

                // Service Review
                _buildReviewCard(
                  'Service',
                  Icons.build_circle_outlined,
                  [
                    _ReviewRow('Type', serviceType),
                    _ReviewRow('Status', _formatStatus(_selectedWorkStatus)),
                    _ReviewRow('Description', _descriptionController.text),
                    if (_kmRunController.text.isNotEmpty)
                      _ReviewRow('KM Run', '${_kmRunController.text} km'),
                  ],
                  isDark,
                ),
                const SizedBox(height: 12),

                // Cost Summary
                _buildCostSummaryCard(isDark),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        _buildReviewBottomBar(isDark),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark, {String? trailing}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trailing,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCard(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    IconData? icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool showDivider = true,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.gray700 : AppColors.gray300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.gray700 : AppColors.gray300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
            filled: true,
            fillColor: isDark ? AppColors.gray800 : AppColors.gray50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: required
              ? (value) => (value == null || value.isEmpty) ? 'Required' : null
              : null,
        ),
        if (showDivider) const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required bool isDark,
    required Function(String?) onChanged,
    String? hint,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.gray700 : AppColors.gray300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.gray700 : AppColors.gray300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        filled: true,
        fillColor: isDark ? AppColors.gray800 : AppColors.gray50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: required ? (v) => v == null ? 'Required' : null : null,
      dropdownColor: isDark ? AppColors.gray800 : AppColors.white,
      style: TextStyle(
        color: isDark ? AppColors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatusSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Status',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.gray400 : AppColors.gray600,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _workStatuses.map((status) {
              final isSelected = _selectedWorkStatus == status;
              final color = _getStatusColor(status);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedWorkStatus = status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? color : (isDark ? AppColors.gray700 : AppColors.gray300),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatStatus(status),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? color
                                : (isDark ? AppColors.gray300 : AppColors.gray700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildItemTile(
    String name,
    double cost,
    String? subtitle,
    VoidCallback onRemove,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.gray500 : AppColors.gray600,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '\u20B9${cost.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemRow({
    required TextEditingController nameController,
    required TextEditingController costController,
    required String nameHint,
    required VoidCallback onAdd,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: nameController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: nameHint,
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: TextField(
            controller: costController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: '\u20B9 0',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: AppColors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPartRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _partNameController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Part name',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: TextField(
            controller: _partQuantityController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Qty',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _partCostController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: '\u20B9 0',
              hintStyle: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _addPart,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, color: AppColors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(bool isDark) {
    return _buildCard(
      isDark,
      child: Column(
        children: [
          // Total breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Labor',
                style: TextStyle(
                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                ),
              ),
              Text(
                '\u20B9${_totalLaborCost.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parts',
                style: TextStyle(
                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                ),
              ),
              Text(
                '\u20B9${_totalPartsCost.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\u20B9${_totalCost.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _advancePaidController,
            label: 'Advance Paid',
            hint: '0',
            icon: Icons.payments_outlined,
            isDark: isDark,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            showDivider: false,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _balanceAmount > 0
                  ? AppColors.warning.withOpacity(0.1)
                  : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _balanceAmount > 0
                          ? Icons.account_balance_wallet_outlined
                          : Icons.check_circle_outline,
                      size: 18,
                      color: _balanceAmount > 0 ? AppColors.warning : AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _balanceAmount > 0 ? 'Balance Due' : 'No Due',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _balanceAmount > 0 ? AppColors.warning : AppColors.success,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\u20B9${_balanceAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _balanceAmount > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.white,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.gray800 : AppColors.gray200),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _proceedToReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Review Order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    String title,
    IconData icon,
    List<_ReviewRow> rows,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.gray800 : AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        row.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.gray500 : AppColors.gray600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCostSummaryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.gray800 : AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Cost Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Labor items
          if (_laborItems.isNotEmpty) ...[
            Text(
              'Labor (${_laborItems.length})',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.gray500 : AppColors.gray600,
              ),
            ),
            const SizedBox(height: 4),
            ..._laborItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.gray300 : AppColors.gray700,
                        ),
                      ),
                      Text(
                        '\u20B9${item.cost.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
          ],

          // Parts items
          if (_parts.isNotEmpty) ...[
            Text(
              'Parts (${_parts.length})',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.gray500 : AppColors.gray600,
              ),
            ),
            const SizedBox(height: 4),
            ..._parts.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.gray300 : AppColors.gray700,
                          ),
                        ),
                      ),
                      Text(
                        '\u20B9${(item.cost * item.quantity).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          const Divider(height: 24),

          // Totals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '\u20B9${_totalCost.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advance Paid',
                style: TextStyle(
                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                ),
              ),
              Text(
                '\u20B9${_advancePaid.toStringAsFixed(0)}',
                style: const TextStyle(color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _balanceAmount > 0
                  ? AppColors.warning.withOpacity(0.1)
                  : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _balanceAmount > 0 ? 'Balance Due' : 'No Due',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _balanceAmount > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
                Text(
                  '\u20B9${_balanceAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _balanceAmount > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.white,
        border: Border(
          top: BorderSide(color: isDark ? AppColors.gray800 : AppColors.gray200),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _isReviewMode = false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.gray300 : AppColors.gray700,
                  side: BorderSide(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.existingOrder != null ? 'Update Order' : 'Submit Order',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
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

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    _partsUsedController.dispose();
    _partsCostController.dispose();
    _notesController.dispose();
    _kmRunController.dispose();
    _advancePaidController.dispose();
    _customServiceTypeController.dispose();
    _partNameController.dispose();
    _partCostController.dispose();
    _partQuantityController.dispose();
    _laborNameController.dispose();
    _laborCostController.dispose();
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

class _ReviewRow {
  final String label;
  final String value;
  const _ReviewRow(this.label, this.value);
}
