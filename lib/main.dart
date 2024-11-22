import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/routes/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
 );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Automatically switches based on system theme
      routerDelegate: AutoRouterDelegate(
        AppRouter(), // Initialize your router
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: AppRouter().defaultRouteParser(), // Parse the route info
    );
  }
}
