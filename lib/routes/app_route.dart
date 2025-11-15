import 'package:chat_app/feature/account/presentation/ui/edit_profile.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:chat_app/feature/auth/presentation/ui/log_in_page.dart';
import 'package:chat_app/feature/auth/presentation/ui/sign_up_page.dart';
import 'package:chat_app/feature/auth/presentation/ui/user_info_page.dart';
import 'package:chat_app/feature/splash/presentation/ui/splash_screen.dart';
import 'package:chat_app/feature/home/presentation/ui/home.dart';
import 'package:chat_app/feature/dashboard/presentation/ui/dashboard_screen.dart';
import 'package:chat_app/feature/vehicles/presentation/ui/vehicle_list_screen.dart';
import 'package:chat_app/feature/vehicles/presentation/ui/vehicle_detail_screen.dart';
import 'package:chat_app/feature/service_orders/presentation/ui/service_order_screen.dart';
import 'package:chat_app/feature/service_orders/presentation/ui/service_orders_list_screen.dart';
import 'package:chat_app/feature/reports/presentation/ui/reports_list_screen.dart';
import 'package:chat_app/feature/reports/presentation/ui/report_detail_screen.dart';
import 'package:chat_app/feature/vehicles/presentation/ui/vehicle_registration_screen.dart';
import 'package:chat_app/feature/notifications/notifications_screen.dart';
import 'package:chat_app/models/service_order.dart';
import 'package:chat_app/feature/customers/presentation/ui/customer_list_screen.dart';
import 'package:chat_app/feature/settings/settings_screen.dart';
import 'package:chat_app/feature/payments/presentation/ui/payments_screen.dart';
import 'package:chat_app/feature/expenses/presentation/ui/expenses_screen.dart';
import 'package:chat_app/feature/inventory/presentation/ui/inventory_screen.dart';
import 'package:chat_app/feature/appointments/presentation/ui/appointments_screen.dart';
import 'package:chat_app/feature/analytics/presentation/ui/analytics_screen.dart';
import 'package:chat_app/models/vehicle.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/user-info',
        name: 'user-info',
        builder: (context, state) => const UserInfoPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) {
          final user = state.extra as UserModel;
          return EditProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        name: 'vehicles',
        builder: (context, state) => const VehicleListScreen(),
      ),
      GoRoute(
        path: '/vehicle-detail',
        name: 'vehicle-detail',
        builder: (context, state) {
          final vehicle = state.extra as Vehicle;
          return VehicleDetailScreen(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: '/service-order',
        name: 'service-order',
        builder: (context, state) {
          final vehicle = state.extra as Vehicle?;
          return ServiceOrderScreen(vehicle: vehicle);
        },
      ),
      GoRoute(
        path: '/service-order-edit',
        name: 'service-order-edit',
        builder: (context, state) {
          final order = state.extra as ServiceOrder?;
          return ServiceOrderScreen(existingOrder: order);
        },
      ),
      GoRoute(
        path: '/service-orders',
        name: 'service-orders',
        builder: (context, state) => const ServiceOrdersListScreen(),
      ),
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsListScreen(),
      ),
      GoRoute(
        path: '/report-detail',
        name: 'report-detail',
        builder: (context, state) {
          if (state.extra is Map) {
            final data = state.extra as Map<String, dynamic>;
            return ReportDetailScreen(
              serviceOrder: data['serviceOrder'] as ServiceOrder,
              vehicle: data['vehicle'] as Vehicle?,
            );
          } else {
            final order = state.extra as ServiceOrder?;
            return ReportDetailScreen(
              serviceOrder: order ?? const ServiceOrder(),
            );
          }
        },
      ),
      GoRoute(
        path: '/vehicle-registration',
        name: 'vehicle-registration',
        builder: (context, state) => const VehicleRegistrationScreen(),
      ),
      GoRoute(
        path: '/customers',
        name: 'customers',
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/expenses',
        name: 'expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/inventory',
        name: 'inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/appointments',
        name: 'appointments',
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
