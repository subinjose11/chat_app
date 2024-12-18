// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/app_dimens.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/feature/home/presentation/controller/home_controller.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountAppBar extends ConsumerWidget {
  const AccountAppBar(
      {super.key, required this.title, this.onBack, this.style});
  final String title;
  final VoidCallback? onBack;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: style ?? heading01,
          ),
        ),
        GestureDetector(
            onTap: () async {
              final SupabaseClient supabase = Supabase.instance.client;
              await supabase.auth.signOut();
              await context.router.replaceAll([const LogInRoute()]);
              ref.invalidate(navIndexProvider);
            },
            child: const Icon(Icons.logout)),
        dimenWidth16,
      ],
    );
  }
}
