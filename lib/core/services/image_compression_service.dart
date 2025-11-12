import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressionService {
  // Compress image before upload
  static Future<File?> compressImage(File file, {int quality = 70}) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Compress multiple images
  static Future<List<File>> compressMultipleImages(
      List<File> files, {int quality = 70}) async {
    List<File> compressedFiles = [];
    
    for (var file in files) {
      final compressed = await compressImage(file, quality: quality);
      if (compressed != null) {
        compressedFiles.add(compressed);
      }
    }
    
    return compressedFiles;
  }

  // Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }
}

