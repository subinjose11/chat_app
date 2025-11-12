import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/widget/vehicle_card.dart';
import 'package:chat_app/core/widget/empty_state.dart';
import 'package:chat_app/models/vehicle.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, pending, completed

  // Sample data - replace with actual data from your backend
  final List<Vehicle> _sampleVehicles = [
    Vehicle(
      id: '1',
      customerId: 'c1',
      numberPlate: 'ABC 1234',
      make: 'Honda',
      model: 'Civic',
      year: '2020',
      fuelType: 'Petrol',
      serviceStatus: 'completed',
      lastServiceDate: DateTime(2024, 10, 15),
    ),
    Vehicle(
      id: '2',
      customerId: 'c2',
      numberPlate: 'XYZ 5678',
      make: 'Toyota',
      model: 'Camry',
      year: '2019',
      fuelType: 'Hybrid',
      serviceStatus: 'active',
      lastServiceDate: DateTime(2024, 11, 1),
    ),
    Vehicle(
      id: '3',
      customerId: 'c3',
      numberPlate: 'DEF 9012',
      make: 'Ford',
      model: 'F-150',
      year: '2021',
      fuelType: 'Diesel',
      serviceStatus: 'pending',
      lastServiceDate: DateTime(2024, 9, 20),
    ),
  ];

  List<Vehicle> get _filteredVehicles {
    return _sampleVehicles.where((vehicle) {
      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          vehicle.numberPlate.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.make.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.model.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by status
      final matchesStatus = _filterStatus == 'all' ||
          vehicle.serviceStatus.toLowerCase() == _filterStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'active', child: Text('Active')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
            ],
          ),
          const SizedBox(width: 8),
        ],
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
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by plate, make, or model...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter Chips
          if (_filterStatus != 'all')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text('Filter: $_filterStatus'),
                onDeleted: () {
                  setState(() {
                    _filterStatus = 'all';
                  });
                },
              ),
            ),

          // Vehicle List
          Expanded(
            child: _filteredVehicles.isEmpty
                ? EmptyState(
                    icon: Icons.directions_car_outlined,
                    title: 'No Vehicles Found',
                    message: _searchQuery.isNotEmpty || _filterStatus != 'all'
                        ? 'Try adjusting your search or filter'
                        : 'Start by adding your first vehicle',
                    actionLabel: _searchQuery.isEmpty && _filterStatus == 'all'
                        ? 'Add Vehicle'
                        : null,
                    onAction: _searchQuery.isEmpty && _filterStatus == 'all'
                        ? () {
                            // TODO: Navigate to add vehicle
                          }
                        : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return VehicleCard(
                        vehicle: vehicle,
                        onTap: () {
                          // TODO: Navigate to vehicle detail
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add vehicle
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Vehicle'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

