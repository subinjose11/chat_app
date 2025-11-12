// ignore_for_file: use_build_context_synchronously
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/local/shared_prefs_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(const Duration(seconds: 2));
    await SharedPreferencesHelper.init();
    final isFirstLogin =
        await SharedPreferencesHelper.getBool("firstLogin") ?? false;
    if (isFirstLogin) {
      // final session = Supabase.instance.client.auth.currentSession;
      // if (session == null) {
        context.go('/login');
      // } else {
      //   context.go('/home');
      // }
    } else {
         context.go('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(Drawables.appLogo, height: 150),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text("Chat App", style: heading02),
          )
        ],
      ),
    ));
  }
}
