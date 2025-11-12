// ignore_for_file: use_build_context_synchronously

// import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/app_dimens.dart';
import 'package:chat_app/core/styles/text_styles.dart';
// import 'package:chat_app/routes/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class ChatAppBar extends ConsumerStatefulWidget {
  const ChatAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.style,
  });
  final String title;
  final VoidCallback? onBack;
  final TextStyle? style;

  @override
  ConsumerState<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends ConsumerState<ChatAppBar> {
  @override
  void initState() {
    super.initState();
  }

  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: widget.style ?? heading01,
          ),
        ),
      
        GestureDetector(
            onTap: () {},
            child: const Icon(Icons.chat)),
        dimenWidth16,
      ],
    );
  }

 
}
