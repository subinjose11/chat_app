// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/app_dimens.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
// import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/account/presentation/controller/account_controller.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage(name: "EditProfileRoute")
class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  String? _imageUrl;
  late TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  void initState() {
    _initializeField();
    super.initState();
  }

  void _initializeField() {
    _imageUrl = widget.user.avatar_url ?? "";
    userNameController.text = widget.user.user_name ?? "";
    phoneController.text = widget.user.phone_number ?? "";
    fullNameController.text = widget.user.full_name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: heading02,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(accountControllerProvider.notifier)
                  .updateProfile(ref, context, _imageUrl,userNameController.text,
                  fullNameController.text,phoneController.text,emailController.text);
            },
            icon: Text(
              "SAVE",
              style: subText16SB,
            ),
          ),
          dimenWidth4
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _profileAvatar(context),
              dimenHeight8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField("User Name", userNameController),
                  _buildInputField("Full Name", fullNameController),
                  _buildInputField("Phone", phoneController),
                  _buildInputField("Email", emailController),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Adds space between fields
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: label=="phone"?TextInputType.phone:TextInputType.none,
          ),
        ],
      ),
    );
  }

  Widget _profileAvatar(BuildContext context) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: const CircleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _imageUrl != null && _imageUrl!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_imageUrl!),
                    radius: 45,
                  )
                : CircleAvatar(
                    radius: 45,
                    child: Image.asset(Drawables.noDp),
                  ),
            GestureDetector(
              onTap: () => _pickAndUploadImage(context),
              child: const Icon(
                Icons.add_a_photo,
                color: AppColors.primary900,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    // final supabase = Supabase.instance.client;
    // try {
    //   final imageUrl =
    //       await ImageUploadService(supabase).selectAnduploadImage(context);
    //   if (imageUrl != null) {
    //     setState(() {
    //       _imageUrl = imageUrl;
    //     });
    //   }
    // } catch (e) {
    //   // Handle Errors
    //   debugPrint("Error uploading image: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to upload image: $e")),
    //   );
    // }
  }
}
