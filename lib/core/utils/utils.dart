// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

class ImageUploadService {
  // final SupabaseClient supabase;

  // ImageUploadService(this.supabase);

  Future<String?> selectAnduploadImage(BuildContext context) async {
    // try {
    //   final image = await pickImage(context);
    //   if (image == null) {
    //     return null;
    //   }
    //   // Step 1: Prepare for Upload
    //   final imageExtension = image.path.split('.').last.toLowerCase();
    //   final imageBytes = await image.readAsBytes();
    //   final userId = supabase.auth.currentUser?.id;
    //   final imagePath = '/$userId/profile';

    //   // Step 2: Upload Image to Supabase Storage
    //   await supabase.storage.from('profiles').uploadBinary(
    //         imagePath,
    //         imageBytes,
    //         fileOptions: FileOptions(
    //           upsert: true,
    //           contentType: 'image/$imageExtension',
    //         ),
    //       );

    //   // Step 3: Get Public URL
    //   String imageUrl =
    //       supabase.storage.from('profiles').getPublicUrl(imagePath);
    //   imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
    //     't': DateTime.now().millisecondsSinceEpoch.toString(),
    //   }).toString();

    //   return imageUrl;
    // } catch (e) {
    //   debugPrint("Error uploading image: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to upload image: $e")),
    //   );
    //   return null;
    // }
    return null;
  }

  Future<File?> pickImage(BuildContext context) async {
    final selectedImage = await pickImageFromGallery(context);
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
    }
    return selectedImage;
  }
}
bool isNullOrEmpty(dynamic value) {
  if (value == null) return true; // Check for null
  if (value is String && value.trim().isEmpty) return true; // Check for empty strings
  if (value is Iterable || value is Map) return value.isEmpty; // Check for empty collections
  return false; // Value is neither null nor empty
}