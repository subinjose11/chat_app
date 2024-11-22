import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/theme/app_theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/routes/app_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ensure this is initialized once and reused
final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      theme: lightTheme, // Replace with your custom light theme
      darkTheme: darkTheme, // Replace with your custom dark theme
      themeMode: ThemeMode.system, // Automatically switches based on system theme
      routerDelegate: AutoRouterDelegate(
        _appRouter,
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(), // Parse route info
    );
  }
}
