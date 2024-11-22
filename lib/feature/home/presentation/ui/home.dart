import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:chat_app/feature/home/presentation/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final pageIndex=ref.watch(navIndexProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Chats"),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Chat screen body',
            ),
          ],
        ),
      ),
    );
  }
}
