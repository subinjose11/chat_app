import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:chat_app/feature/home/presentation/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/feature/dashboard/dashboard_screen.dart';
import 'package:chat_app/feature/vehicles/vehicle_list_screen.dart';
import 'package:chat_app/feature/service_orders/service_order_screen.dart';
import 'package:chat_app/feature/reports/reports_screen.dart';
import 'package:chat_app/feature/settings/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
    ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final List<Widget> _screens = const [
    DashboardScreen(),
    VehicleListScreen(),
    ServiceOrderScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(navIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: _screens,
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
