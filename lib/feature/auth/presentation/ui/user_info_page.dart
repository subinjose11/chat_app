import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() =>
      _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();

    // if (name.isNotEmpty) {
    //   ref.read(authControllerProvider).saveUserDataToFirebase(
    //         context,
    //         name,
    //         image,
    //       );
    // }
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
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            image!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed:selectImage,
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
                    onPressed: storeUserData,
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