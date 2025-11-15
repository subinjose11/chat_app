// import 'package:chat_app/core/styles/constants.dart';
import 'package:chat_app/core/services/notification_service.dart';
import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/routes/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for scheduled notifications
  tz.initializeTimeZones();

  // await Supabase.initialize(
  //   url: supaBaseUrl,
  //   anonKey:supaBaseAnonKey
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications
  await NotificationService.initialize(
    onTap: (payload) {
      // Handle notification tap
      // This will be used to navigate to specific screens
      debugPrint('Notification tapped: ${payload.type} - ${payload.orderId}');
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RN Auto garage',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
