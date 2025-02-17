import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  Utils._();

  static Future<File> getConvertToFile(Uint8List filebytes) async {
    final tempDir = await getTemporaryDirectory();
    String fileName = 'image${DateTime.now().microsecondsSinceEpoch}';
    File file = await File('${tempDir.path}/$fileName.png').create();
    file.writeAsBytesSync(filebytes);
    return file;
  }

  static IconData getIconData(String fileExtension) {
    const imageFileExts = [
      'gif',
      'jpg',
      'jpeg',
      'png',
      'webp',
      'bmp',
      'dib',
      'wbmp',
    ];
    final lowerCaseFileExt = fileExtension.toLowerCase();
    if (imageFileExts.contains(lowerCaseFileExt)) return Icons.image;
    // Check if the file is an image first (because there is a shared variable
    // with preview logic), and then fallback to non-image file ext lookup.
    switch (lowerCaseFileExt) {
      case 'doc':
      case 'docx':
        return Icons.edit_document;
      case 'log':
        return Icons.text_snippet_outlined;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
        return Icons.text_snippet_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.edit_document;
      default:
        return Icons.insert_drive_file;
    }
  }
}
