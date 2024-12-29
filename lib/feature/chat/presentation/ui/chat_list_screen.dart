import 'package:flutter/material.dart';
import 'package:chat_app/feature/chat/presentation/widget/chat_app_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:chat_app/feature/select_contacts/presentation/ui/select_contacts_screen.dart';

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
              builder: (context) => const SelectContactsScreen(),
            ),
          );
        },
        child: const Icon(Icons.contacts),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // Handle chat item tap
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      "chatData.name",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "chatData.message",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CircleAvatar(
                      //  backgroundImage: NetworkImage("chatData.groupPic"),
                      radius: 30,
                      backgroundColor: Colors.blueGrey,
                    ),
                    trailing: Text(
                      "hr",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black, indent: 85),
            ],
          );
        },
      ),
    );
  }
}
