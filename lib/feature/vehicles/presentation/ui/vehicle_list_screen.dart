import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/widget/vehicle_card.dart';
import 'package:chat_app/core/widget/empty_state.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:go_router/go_router.dart';

class VehicleListScreen extends ConsumerStatefulWidget {
  const VehicleListScreen({super.key});

  @override
  ConsumerState<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends ConsumerState<VehicleListScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Silently refresh when app comes back to foreground
      ref.read(vehiclesPaginationProvider.notifier).silentRefresh();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(vehiclesPaginationProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchQuery = ref.watch(vehicleSearchQueryProvider);
    final statusFilter = ref.watch(vehicleStatusFilterProvider);
    final paginationState = ref.watch(vehiclesPaginationProvider);

    // Listen for navigation changes and refresh when Vehicles tab is selected
    ref.listen<int>(navIndexProvider, (previous, current) {
      // Index 1 is the Vehicles tab
      if (current == 1 && previous != 1) {
        // Silently refresh the vehicles list when switching to this tab
        ref.read(vehiclesPaginationProvider.notifier).silentRefresh();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark
                ? AppColors.scaffoldBackgroundDark
                : AppColors.scaffoldBackgroundLight,
            child: TextField(
              onChanged: (value) {
                ref.read(vehicleSearchQueryProvider.notifier).state = value;
                ref.read(vehiclesPaginationProvider.notifier).refresh();
              },
              decoration: InputDecoration(
                hintText: 'Search by plate, make, or model...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(vehicleSearchQueryProvider.notifier).state =
                              '';
                          ref
                              .read(vehiclesPaginationProvider.notifier)
                              .refresh();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter Chips
          if (statusFilter != 'all')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text('Filter: $statusFilter'),
                onDeleted: () {
                  ref.read(vehicleStatusFilterProvider.notifier).state = 'all';
                  ref.read(vehiclesPaginationProvider.notifier).refresh();
                },
              ),
            ),

          // Vehicle List
          Expanded(
            child: paginationState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('Error: ${paginationState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(vehiclesPaginationProvider.notifier)
                                .refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : paginationState.vehicles.isEmpty && !paginationState.isLoading
                    ? EmptyState(
                        icon: Icons.directions_car_outlined,
                        title: 'No Vehicles Found',
                        message: searchQuery.isNotEmpty || statusFilter != 'all'
                            ? 'Try adjusting your search or filter'
                            : 'Start by adding your first vehicle',
                        actionLabel:
                            searchQuery.isEmpty && statusFilter == 'all'
                                ? 'Add Vehicle'
                                : null,
                        onAction: searchQuery.isEmpty && statusFilter == 'all'
                            ? () {
                                _showAddVehicleDialog(context, ref);
                              }
                            : null,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref
                              .read(vehiclesPaginationProvider.notifier)
                              .refresh();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: paginationState.vehicles.length +
                              (paginationState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == paginationState.vehicles.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final vehicle = paginationState.vehicles[index];
                            return VehicleCard(
                              key: ValueKey('vehicle_${vehicle.id}'),
                              vehicle: vehicle,
                              onTap: () {
                                context.push('/vehicle-detail', extra: vehicle);
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddVehicleDialog(),
    );
  }
}

class AddVehicleDialog extends ConsumerStatefulWidget {
  const AddVehicleDialog({super.key});

  @override
  ConsumerState<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends ConsumerState<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _numberPlateController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _vinController = TextEditingController();
  final _colorController = TextEditingController();
  final _customerIdController = TextEditingController();

  @override
  void dispose() {
    _numberPlateController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _fuelTypeController.dispose();
    _vinController.dispose();
    _colorController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Vehicle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _numberPlateController,
                decoration: const InputDecoration(
                  labelText: 'Number Plate',
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number plate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _makeController,
                decoration: const InputDecoration(
                  labelText: 'Make',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter make';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fuelTypeController,
                decoration: const InputDecoration(
                  labelText: 'Fuel Type (Optional)',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vinController,
                decoration: const InputDecoration(
                  labelText: 'VIN (Optional)',
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color (Optional)',
                  prefixIcon: Icon(Icons.palette),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(
                  labelText: 'Customer ID',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer ID';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final vehicle = Vehicle(
                numberPlate: _numberPlateController.text,
                make: _makeController.text,
                model: _modelController.text,
                year: _yearController.text,
                fuelType: _fuelTypeController.text.isEmpty
                    ? null
                    : _fuelTypeController.text,
                vin: _vinController.text.isEmpty ? null : _vinController.text,
                color: _colorController.text.isEmpty
                    ? null
                    : _colorController.text,
                customerId: _customerIdController.text,
                serviceStatus: 'completed',
                createdAt: DateTime.now(),
              );

              ref
                  .read(vehicleControllerProvider)
                  .createVehicle(context, vehicle);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
