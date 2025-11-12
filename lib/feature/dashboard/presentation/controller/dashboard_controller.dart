import 'package:chat_app/feature/service_orders/presentation/controller/service_order_controller.dart';
import 'package:chat_app/feature/vehicles/presentation/controller/vehicle_controller.dart';
import 'package:chat_app/feature/customers/presentation/controller/customer_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dashboard Analytics Provider
final dashboardAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Get data from all sources
  final analytics = await ref.watch(serviceOrderControllerProvider).getAnalytics();
  final vehiclesAsync = ref.watch(vehiclesStreamProvider);
  final customersAsync = ref.watch(customersStreamProvider);

  int totalVehicles = 0;
  int totalCustomers = 0;

  vehiclesAsync.whenData((vehicles) {
    totalVehicles = vehicles.length;
  });

  customersAsync.whenData((customers) {
    totalCustomers = customers.length;
  });

  return {
    ...analytics,
    'totalVehicles': totalVehicles,
    'totalCustomers': totalCustomers,
  };
});

// Recent Activity Provider (combining latest orders and vehicles)
final recentActivityProvider = StreamProvider((ref) async* {
  final orders = ref.watch(serviceOrdersStreamProvider);
  yield orders;
});

