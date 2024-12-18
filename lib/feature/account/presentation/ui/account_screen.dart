// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/account/presentation/controller/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final TextEditingController nameController = TextEditingController();
  String? _imageUrl;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountControllerProvider.notifier).fetchAccountDetails(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final imageUrl =
          await ImageUploadService(supabase).selectAnduploadImage(context);
      if (imageUrl != null) {
        ref
            .watch(accountControllerProvider.notifier)
            .updateProfilePic(context, imageUrl);
        setState(() {
          _imageUrl = imageUrl;
        });
      }
    } catch (e) {
      // Handle Errors
      debugPrint("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountStatus = ref.watch(
      accountControllerProvider.select((value) => value.accountStatus),
    );
    final avatarUrl =
        ref.watch(accountControllerProvider).userDetails.avatar_url;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: (accountStatus == AccountStatus.loading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                if (accountStatus == AccountStatus.success) ...[
                  Text("Profile", style: subText16SB),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _imageUrl!=null && _imageUrl!.isNotEmpty?
                      CircleAvatar(
                              backgroundImage: NetworkImage(_imageUrl!),
                              radius: 64,
                            ):
                      avatarUrl == null
                          ? CircleAvatar(
                              radius: 64,
                              child: Image.asset(Drawables.noDp),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(avatarUrl),
                              radius: 64,
                            ),
                      IconButton(
                        onPressed: () => _pickAndUploadImage(context),
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: AppColors.gray400,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  Text(ref
                          .watch(accountControllerProvider)
                          .userDetails
                          .user_name ??
                      "nothing"),
                ]
              ],
            ),
    );
  }
}

enum AccountStatus {
  idle,
  loading,
  success,
  failed,
}
