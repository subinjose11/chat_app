// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/core/styles/app_dimens.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusAppBar extends ConsumerStatefulWidget {
  const StatusAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.style,
  });
  final String title;
  final VoidCallback? onBack;
  final TextStyle? style;

  @override
  ConsumerState<StatusAppBar> createState() => _StatusAppBarState();
}

class _StatusAppBarState extends ConsumerState<StatusAppBar> {
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
          // BackButton(
          //   onPressed: widget.onBack ??
          //       () {},
          // ),
        Expanded(
          child: Text(
            widget.title,
            style: widget.style ?? heading01,
          ),
        ),
      
        GestureDetector(
            onTap: () {
            },
            child: const Icon(Icons.video_camera_back_outlined)),
        dimenWidth16,
      ],
    );
  }

 
}
