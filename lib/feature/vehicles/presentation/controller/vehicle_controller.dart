import 'package:chat_app/feature/vehicles/data/repository/vehicle_repository.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

// Pagination State
class VehiclesPaginationState {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final String? error;

  VehiclesPaginationState({
    this.vehicles = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.lastDocument,
    this.error,
  });

  VehiclesPaginationState copyWith({
    List<Vehicle>? vehicles,
    bool? isLoading,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    String? error,
  }) {
    return VehiclesPaginationState(
      vehicles: vehicles ?? this.vehicles,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
      error: error ?? this.error,
    );
  }
}

// Vehicles Pagination Notifier
class VehiclesPaginationNotifier extends StateNotifier<VehiclesPaginationState> {
  final VehicleRepository _repository;
  final String _searchQuery;
  final String _statusFilter;

  VehiclesPaginationNotifier(
    this._repository,
    this._searchQuery,
    this._statusFilter,
  ) : super(VehiclesPaginationState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vehicles = await _repository.searchVehiclesPaginated(
        query: _searchQuery,
        limit: 20,
      );

      final filteredVehicles = _applyStatusFilter(vehicles);
      
      // Get last document if vehicles exist
      DocumentSnapshot? lastDoc;
      if (filteredVehicles.isNotEmpty) {
        lastDoc = await _repository.getVehicleDocument(filteredVehicles.last.id);
      }

      state = state.copyWith(
        vehicles: filteredVehicles,
        isLoading: false,
        hasMore: filteredVehicles.length >= 20,
        lastDocument: lastDoc,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final newVehicles = await _repository.searchVehiclesPaginated(
        query: _searchQuery,
        limit: 20,
        lastDocument: state.lastDocument,
      );

      final filteredNewVehicles = _applyStatusFilter(newVehicles);

      if (filteredNewVehicles.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      // Get last document
      DocumentSnapshot? lastDoc;
      if (filteredNewVehicles.isNotEmpty) {
        lastDoc = await _repository.getVehicleDocument(filteredNewVehicles.last.id);
      }

      state = state.copyWith(
        vehicles: [...state.vehicles, ...filteredNewVehicles],
        isLoading: false,
        hasMore: filteredNewVehicles.length >= 20,
        lastDocument: lastDoc,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  List<Vehicle> _applyStatusFilter(List<Vehicle> vehicles) {
    if (_statusFilter == 'all') {
      return vehicles;
    }
    return vehicles
        .where((vehicle) => 
            vehicle.serviceStatus.toLowerCase() == _statusFilter.toLowerCase())
        .toList();
  }

  void refresh() {
    state = VehiclesPaginationState();
    loadInitialData();
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

// Vehicles Pagination Provider
final vehiclesPaginationProvider = StateNotifierProvider<VehiclesPaginationNotifier, VehiclesPaginationState>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  final searchQuery = ref.watch(vehicleSearchQueryProvider);
  final statusFilter = ref.watch(vehicleStatusFilterProvider);
  
  return VehiclesPaginationNotifier(repository, searchQuery, statusFilter);
});

