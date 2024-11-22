// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

class ImageService {
  NetworkImage? networkImage1;
  NetworkImage? networkImage2;
  loadImages(BuildContext context) async {
    networkImage1 = const NetworkImage("");
    await precacheImage(networkImage1!, context);
    networkImage2 = const NetworkImage("");
    await precacheImage(networkImage2!, context);
  }
}
