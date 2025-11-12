import 'package:chat_app/feature/vehicles/data/repository/vehicle_repository.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleController {
  final VehicleRepository vehicleRepository;

  VehicleController({required this.vehicleRepository});

  Future<void> createVehicle(BuildContext context, Vehicle vehicle) async {
    await vehicleRepository.createVehicle(context, vehicle);
  }

  void updateVehicle(BuildContext context, Vehicle vehicle) {
    vehicleRepository.updateVehicle(context, vehicle);
  }

  void deleteVehicle(BuildContext context, String vehicleId) {
    vehicleRepository.deleteVehicle(context, vehicleId);
  }

  Future<Vehicle?> getVehicle(String vehicleId) {
    return vehicleRepository.getVehicle(vehicleId);
  }
}

// Controller Provider
final vehicleControllerProvider = Provider((ref) {
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  return VehicleController(vehicleRepository: vehicleRepository);
});

// Stream Provider for all vehicles
final vehiclesStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  return vehicleRepository.getVehiclesStream();
});

// Stream Provider for single vehicle by ID
final vehicleStreamProvider = StreamProvider.family<Vehicle?, String>((ref, vehicleId) {
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  return vehicleRepository.getVehicleStream(vehicleId);
});

// Stream Provider for customer vehicles
final customerVehiclesStreamProvider = StreamProvider.family<List<Vehicle>, String>((ref, customerId) {
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  return vehicleRepository.getVehiclesByCustomer(customerId);
});

// Search Provider
final vehicleSearchQueryProvider = StateProvider<String>((ref) => '');

final searchedVehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  final query = ref.watch(vehicleSearchQueryProvider);
  final vehicleRepository = ref.watch(vehicleRepositoryProvider);
  return vehicleRepository.searchVehicles(query);
});

// Filter Provider
final vehicleStatusFilterProvider = StateProvider<String>((ref) => 'all');

final filteredVehiclesProvider = Provider<AsyncValue<List<Vehicle>>>((ref) {
  final vehiclesAsync = ref.watch(searchedVehiclesProvider);
  final statusFilter = ref.watch(vehicleStatusFilterProvider);

  return vehiclesAsync.when(
    data: (vehicles) {
      if (statusFilter == 'all') {
        return AsyncValue.data(vehicles);
      }
      final filtered = vehicles
          .where((vehicle) => vehicle.serviceStatus.toLowerCase() == statusFilter.toLowerCase())
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

