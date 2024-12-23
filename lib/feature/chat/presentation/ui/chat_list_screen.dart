import 'package:chat_app/feature/chat/presentation/ui/search_user_screen.dart';
import 'package:chat_app/feature/chat/presentation/widget/chat_app_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appWidget: ChatAppBar(title: "Chats")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchUserScreen()));
        },
        child: const Icon(Icons.search),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chat screen body',
            ),
          ],
        ),
      ),
    );
  }
}