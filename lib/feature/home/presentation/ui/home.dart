import 'package:auto_route/auto_route.dart';
import 'package:chat_app/feature/account/presentation/ui/account_screen.dart';
import 'package:chat_app/feature/account/presentation/widget/account_app_bar.dart';
import 'package:chat_app/feature/chat/presentation/ui/chat_screen.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:chat_app/feature/chat/presentation/widget/chat_app_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/bottom_nav_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:chat_app/feature/status/presentation/ui/status_screen.dart';
import 'package:chat_app/feature/status/presentation/widget/status_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(navIndexProvider);
    return Scaffold(
        appBar: CustomAppBar(appWidget: appbars[pageIndex]),
        bottomNavigationBar: const BottomNavBar(),
        body: screens[pageIndex]);
  }

  final screens = [
    const ChatScreen(),
    const StatusScreen(),
    const AccountScreen(),
  ];
  final appbars = [
    const ChatAppBar(title: "Chats"),
    const StatusAppBar(title: "Status"),
     const AccountAppBar(title: "Account"),
  ];
}
