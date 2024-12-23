// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chat_app/feature/chat/presentation/ui/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchUserScreen extends ConsumerStatefulWidget {
  const SearchUserScreen({super.key});

  @override
  ConsumerState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends ConsumerState<SearchUserScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];

  Future<void> searchUsers() async {
    final searchTerm = searchController.text.trim(); // Trim any extra spaces
    if (searchTerm.isNotEmpty) {
      try {
        final response = await supabase
            .from('profiles')
            .select('*')
            .ilike('user_name', '%$searchTerm%'); // Case-insensitive search
        log(response.toString());
        if (response.isNotEmpty) {
          setState(() {
            users =
                response.cast<Map<String, dynamic>>(); // Ensure proper casting
          });
        } else {
          setState(() {
            users = [];
          });
          log('No matching users found.');
        }
      } catch (e) {
        log('Error fetching users: $e');
      }
    } else {
      setState(() {
        users.clear(); // Clear the list if the input is empty
      });
    }
  }

// Function to initiate chat with a user
Future<void> initiateChat(BuildContext context, String otherUserId, String userName) async {
  try {
    final currentUserId = supabase.auth.currentUser!.id;

    // Check if a chat already exists between the two users
    final response = await supabase
        .from('chat_participants')
        .select('chat_id, user_id')
        .or('user_id.eq.$currentUserId,user_id.eq.$otherUserId');

    // Group chat participants by chat_id
    final chatGroups = <String, List<String>>{};

    // Populate the chatGroups map with chat_id and user_id
    for (final row in response as List) {
      final chatId = row['chat_id'];
      final userId = row['user_id'];
      chatGroups.putIfAbsent(chatId, () => []).add(userId);
    }

    // Find a chat where both users are present
    final existingChatId = chatGroups.entries
        .firstWhere(
          (entry) => entry.value.contains(currentUserId) && entry.value.contains(otherUserId),
          orElse: () => MapEntry('', []), // Return an empty entry if no chat is found
        )
        .key;

    // If a chat exists, navigate to the chat screen
    if (existingChatId.isNotEmpty) {
      log("Existing chat id: $existingChatId");

      // Chat exists, navigate to it
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: existingChatId,
            currentUserId: currentUserId,
            otherUserId: otherUserId,
            userName: userName,
          ),
        ),
      );
      return;
    }

    // No chat exists, create a new chat
    final newChatResponse = await supabase
        .from('chats')
        .insert({'created_at': DateTime.now().toIso8601String()})
        .select();

    final newChatId = newChatResponse.first['id'];

    // Add current user and other user to chat participants
    await supabase.from('chat_participants').insert([
      {'chat_id': newChatId, 'user_id': currentUserId},
      {'chat_id': newChatId, 'user_id': otherUserId},
    ]);

    log("New chat created with id: $newChatId");

    // Navigate to the chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: newChatId,
          currentUserId: currentUserId,
          otherUserId: otherUserId,
          userName: userName,
        ),
      ),
    );
  } catch (e) {
    log('Error initiating chat: $e');
    // Show an error message to the user if needed
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (_) => searchUsers(),
          decoration: const InputDecoration(hintText: 'Search'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['user_name']),
                          onTap: () => initiateChat(context, user['id'],user["user_name"]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
