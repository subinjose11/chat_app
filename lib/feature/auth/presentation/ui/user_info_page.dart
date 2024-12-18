// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  final supabase = Supabase.instance.client;
  String? _imageUrl;
  bool _isUploading = false; // To indicate loading state

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      // Step 1: Pick Image
      final selectedImage = await pickImageFromGallery(context);
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // Step 2: Prepare for Upload
      final imageExtension = selectedImage.path.split('.').last.toLowerCase();
      final imageBytes = await selectedImage.readAsBytes();
      final userId = supabase.auth.currentUser?.id;
      final imagePath = '/$userId/profile';

      // Step 3: Upload Image to Supabase Storage
      await supabase.storage.from('profiles').uploadBinary(
            imagePath,
            imageBytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/$imageExtension',
            ),
          );

      // Step 4: Get Public URL
      String imageUrl = supabase.storage.from('profiles').getPublicUrl(imagePath);
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString(),
      }).toString();

      // Step 5: Update State
      setState(() {
        _imageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      // Handle Errors
      debugPrint("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    } finally {
      // End loading state
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _imageUrl == null
                      ? CircleAvatar(
                          radius: 64,
                          child: Image.asset(Drawables.noDp),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(_imageUrl!),
                          radius: 64,
                        ),
                  IconButton(
                    onPressed: _isUploading
                        ? null
                        : () => _pickAndUploadImage(context),
                    icon: const Icon( Icons.add_a_photo,
                      color: AppColors.gray400,
                      size: 35,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final userName = nameController.text.trim();
                      if (userName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Name cannot be empty")),
                        );
                        return;
                      }
                      ref
                          .read(authControllerProvider)
                          .addUserDetails(context, _imageUrl, userName);
                    },
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
