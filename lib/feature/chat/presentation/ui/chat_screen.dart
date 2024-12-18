import 'package:chat_app/feature/chat/presentation/widget/chat_app_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appWidget: ChatAppBar(title: "Chats")),
      body: Center(
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
