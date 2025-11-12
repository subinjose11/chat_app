import 'package:chat_app/feature/service_orders/data/repository/service_order_repository.dart';
import 'package:chat_app/models/service_order.dart';
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

  void updateServiceOrderStatus(BuildContext context, String orderId, String status) {
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

