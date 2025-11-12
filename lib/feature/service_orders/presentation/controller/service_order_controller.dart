import 'package:chat_app/feature/service_orders/data/repository/service_order_repository.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ServiceOrderController {
  final ServiceOrderRepository serviceOrderRepository;

  ServiceOrderController({required this.serviceOrderRepository});

  void createServiceOrder(
    BuildContext context,
    ServiceOrder serviceOrder,
    List<XFile> beforePhotos,
    List<XFile> afterPhotos,
  ) {
    serviceOrderRepository.createServiceOrder(
      context,
      serviceOrder,
      beforePhotos,
      afterPhotos,
    );
  }

  void updateServiceOrder(BuildContext context, ServiceOrder serviceOrder) {
    serviceOrderRepository.updateServiceOrder(context, serviceOrder);
  }

  void updateServiceOrderStatus(
      BuildContext context, String orderId, String status) {
    serviceOrderRepository.updateServiceOrderStatus(context, orderId, status);
  }

  void deleteServiceOrder(BuildContext context, String orderId) {
    serviceOrderRepository.deleteServiceOrder(context, orderId);
  }

  Future<ServiceOrder?> getServiceOrder(String orderId) {
    return serviceOrderRepository.getServiceOrder(orderId);
  }

  Future<Map<String, dynamic>> getAnalytics() {
    return serviceOrderRepository.getAnalytics();
  }
}

// Pagination State
class ServiceOrdersPaginationState {
  final List<ServiceOrder> orders;
  final bool isLoading;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final String? error;

  ServiceOrdersPaginationState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.lastDocument,
    this.error,
  });

  ServiceOrdersPaginationState copyWith({
    List<ServiceOrder>? orders,
    bool? isLoading,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    String? error,
  }) {
    return ServiceOrdersPaginationState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
      error: error ?? this.error,
    );
  }
}

// Service Orders Pagination Notifier
class ServiceOrdersPaginationNotifier
    extends StateNotifier<ServiceOrdersPaginationState> {
  final ServiceOrderRepository _repository;
  final String _dateFilter;
  final String _statusFilter;

  ServiceOrdersPaginationNotifier(
    this._repository,
    this._dateFilter,
    this._statusFilter,
  ) : super(ServiceOrdersPaginationState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getServiceOrdersPaginated(limit: 20);
      final filteredOrders = _applyFilters(orders);

      // Get last document if orders exist
      DocumentSnapshot? lastDoc;
      if (filteredOrders.isNotEmpty) {
        lastDoc =
            await _repository.getServiceOrderDocument(filteredOrders.last.id);
      }

      state = state.copyWith(
        orders: filteredOrders,
        isLoading: false,
        hasMore: filteredOrders.length >= 20,
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
      final newOrders = await _repository.getServiceOrdersPaginated(
        limit: 20,
        lastDocument: state.lastDocument,
      );

      final filteredNewOrders = _applyFilters(newOrders);

      if (filteredNewOrders.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      // Get last document
      DocumentSnapshot? lastDoc;
      if (filteredNewOrders.isNotEmpty) {
        lastDoc = await _repository
            .getServiceOrderDocument(filteredNewOrders.last.id);
      }

      state = state.copyWith(
        orders: [...state.orders, ...filteredNewOrders],
        isLoading: false,
        hasMore: filteredNewOrders.length >= 20,
        lastDocument: lastDoc,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  List<ServiceOrder> _applyFilters(List<ServiceOrder> orders) {
    var filtered = orders;

    // Apply date filter
    if (_dateFilter != 'all') {
      final now = DateTime.now();
      filtered = filtered.where((order) {
        if (order.createdAt == null) return false;

        switch (_dateFilter) {
          case 'today':
            return order.createdAt!.year == now.year &&
                order.createdAt!.month == now.month &&
                order.createdAt!.day == now.day;
          case 'week':
            final weekAgo = now.subtract(const Duration(days: 7));
            return order.createdAt!.isAfter(weekAgo);
          case 'month':
            return order.createdAt!.year == now.year &&
                order.createdAt!.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    // Apply status filter
    if (_statusFilter != 'all') {
      filtered =
          filtered.where((order) => order.status == _statusFilter).toList();
    }

    return filtered;
  }

  void refresh() {
    state = ServiceOrdersPaginationState();
    loadInitialData();
  }
}

// Controller Provider
final serviceOrderControllerProvider = Provider((ref) {
  final serviceOrderRepository = ref.watch(serviceOrderRepositoryProvider);
  return ServiceOrderController(serviceOrderRepository: serviceOrderRepository);
});

// Stream Provider for all service orders
final serviceOrdersStreamProvider = StreamProvider<List<ServiceOrder>>((ref) {
  final serviceOrderRepository = ref.watch(serviceOrderRepositoryProvider);
  return serviceOrderRepository.getServiceOrdersStream();
});

// Stream Provider for vehicle service orders
final vehicleServiceOrdersStreamProvider =
    StreamProvider.family<List<ServiceOrder>, String>((ref, vehicleId) {
  final serviceOrderRepository = ref.watch(serviceOrderRepositoryProvider);
  return serviceOrderRepository.getServiceOrdersByVehicle(vehicleId);
});

// Stream Provider for customer service orders
final customerServiceOrdersStreamProvider =
    StreamProvider.family<List<ServiceOrder>, String>((ref, customerId) {
  final serviceOrderRepository = ref.watch(serviceOrderRepositoryProvider);
  return serviceOrderRepository.getServiceOrdersByCustomer(customerId);
});

// Analytics Provider
final analyticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  final serviceOrderRepository = ref.watch(serviceOrderRepositoryProvider);
  return serviceOrderRepository.getAnalytics();
});

// Before Photos Provider
final beforePhotosProvider = StateProvider<List<XFile>>((ref) => []);

// After Photos Provider
final afterPhotosProvider = StateProvider<List<XFile>>((ref) => []);

// Service Orders Pagination Provider (for Order List Screen)
final serviceOrdersPaginationProvider = StateNotifierProvider<
    ServiceOrdersPaginationNotifier, ServiceOrdersPaginationState>((ref) {
  final repository = ref.watch(serviceOrderRepositoryProvider);
  final dateFilter = ref.watch(orderDateFilterProvider);
  final statusFilter = ref.watch(orderStatusFilterProvider);

  return ServiceOrdersPaginationNotifier(repository, dateFilter, statusFilter);
});

// Reports Pagination Provider (for Reports Screen)
final reportsPaginationProvider = StateNotifierProvider<
    ServiceOrdersPaginationNotifier, ServiceOrdersPaginationState>((ref) {
  final repository = ref.watch(serviceOrderRepositoryProvider);
  final dateFilter = ref.watch(reportDateFilterProvider);
  final statusFilter = ref.watch(reportStatusFilterProvider);

  return ServiceOrdersPaginationNotifier(repository, dateFilter, statusFilter);
});

// Filter Providers for Orders
final orderDateFilterProvider = StateProvider<String>((ref) => 'all');
final orderStatusFilterProvider = StateProvider<String>((ref) => 'all');

// Filter Providers for Reports
final reportDateFilterProvider = StateProvider<String>((ref) => 'all');
final reportStatusFilterProvider = StateProvider<String>((ref) => 'all');
