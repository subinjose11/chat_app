// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:auto_route/auto_route.dart';
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
  String _imageUrl =
      "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_imageUrl),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () async {
                        final image = await pickImageFromGallery(context);
                        if (image == null) {
                          return;
                        }
                        final imageExtension =
                            image.path.split('.').last.toLowerCase();
                        final imageBytes = await image.readAsBytes();
                        final userId = supabase.auth.currentUser!.id;
                        final imagePath = '/$userId/profile';
                        await supabase.storage.from('profiles').uploadBinary(
                              imagePath,
                              imageBytes,
                              fileOptions: FileOptions(
                                upsert: true,
                                contentType: 'image/$imageExtension',
                              ),
                            );
                        String imageUrl = supabase.storage
                            .from('profiles')
                            .getPublicUrl(imagePath);
                        imageUrl = Uri.parse(imageUrl)
                            .replace(queryParameters: {
                          't': DateTime.now().millisecondsSinceEpoch.toString()
                        }).toString();
                        setState(() {
                          _imageUrl = imageUrl;
                        });
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
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
                    onPressed: () async {
                      final userName = nameController.text.trim();
                      if (userName.isEmpty) {
                        return;
                      }
                      ref
                          .read(authControllerProvider)
                          .addUserDetails(context, _imageUrl, userName);
                    },
                    icon: const Icon(
                      Icons.done,
                    ),
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
