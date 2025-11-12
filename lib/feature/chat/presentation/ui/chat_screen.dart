// import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.userName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    // Listen for real-time updates in the chat
    // supabase
    //     .from('message')
    //     .stream(primaryKey: ['id'])
    //     .eq('chat_id', widget.chatId)
    //     .order('created_at', ascending: true)
    //     .listen((data) {
    //       setState(() {
    //         messages = data;
    //       });
    //     });
  }

  // Function to send a message
  Future<void> sendMessage(
      String content, String contentType, String? mediaUrl) async {
    // final response = await supabase.from('message').insert([
    //   {
    //     'chat_id': widget.chatId,
    //     'user_from': widget.currentUserId,
    //     'user_to': widget.otherUserId,
    //     'content': content,
    //     'content_type': contentType,
    //     'media_url': mediaUrl,
    //   }
    // ]).select();

    // if (response.isNotEmpty) {
    //   _messageController.clear(); // Clear input field after sending
    // } else {
    //   log('Error sending message');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Optionally, navigate to the user profile
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Display messages in the chat
            Expanded(
              child: ListView.builder(
                reverse: true, // To show the latest messages at the bottom
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  bool isCurrentUser =
                      message['user_from'] == widget.currentUserId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: isCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isCurrentUser) ...[
                          CircleAvatar(
                            child: Text(message['user_from']
                                .toString()
                                .substring(
                                    0, 1)), // Display first letter of sender
                          ),
                        ],
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.blue
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isCurrentUser)
                                Text(
                                  'User ${message['user_from']}', // Replace with actual username
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              if (message['content_type'] == 'text') ...[
                                Text(
                                  message['content'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ] else if (message['content_type'] ==
                                  'image') ...[
                                Image.network(
                                  message['media_url']!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isCurrentUser) ...[
                          SizedBox(width: 8),
                          CircleAvatar(
                            child: Text(message['user_from']
                                .toString()
                                .substring(
                                    0, 1)), // Display first letter of sender
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Message input field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Send text message
                      if (_messageController.text.isNotEmpty) {
                        sendMessage(_messageController.text, 'text', null);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      // You can implement media upload here
                      sendMessage('Image message', 'image',
                          'https://your-media-url.com/image.jpg');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
