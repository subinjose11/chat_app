// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
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
    await Future.delayed(Duration.zero);

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
     context.replaceRoute(const LandingRoute());
    } else {
        context.replaceRoute(const LogInRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)));
  }
}
