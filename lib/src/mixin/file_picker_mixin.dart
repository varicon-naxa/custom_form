// ignore_for_file: invalid_use_of_visible_for_testing_member, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';

///File picker mixin class
mixin FilePickerMixin {
  /// pick files and returns [List<File>? files] - from which we can access files paths
  Future<List<File>?> getFiles(
      {FileType type = FileType.any, bool? allowMultiple = true}) async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple ?? false,
      onFileLoading: (status) {
        return const Center(child: CircularProgressIndicator());
      },
      type: type,
      allowedExtensions: type == FileType.custom
          ? ['doc', 'pdf', 'docx', 'xlsx', 'mp4', 'mp3']
          : null,
    );

    if (result != null) {
      List<File> files = [];
      int fileCount = result.count ?? 0;

      if (fileCount > 5) {
        Fluttertoast.showToast(
          msg: "You can only upload 5 files at a time.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Process only the first 5 files
        for (int i = 0; i < 5; i++) {
          final filePath = result.paths[i];
          if (filePath != null) {
            final file = File(filePath);
            if (await file.length() > 25 * 1024 * 1024) {
              // 25 MB
              Fluttertoast.showToast(
                msg: "The file may not be greater than 25 MB.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              files.add(file);
            }
          }
        }
      } else {
        for (var filePath in result.paths) {
          if (filePath != null) {
            final file = File(filePath);
            if (await file.length() > 25 * 1024 * 1024) {
              // 25 MB
              Fluttertoast.showToast(
                msg: "The file may not be greater than 25 MB.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              files.add(file);
            }
          }
        }
      }

      return files;
    } else {
      return null;
    }
  }

  // checks permission, file size, converts heic & hevc and gets the image file
  Future<List<File>?> getOnlyImageFiles({bool? allowMultiple = false}) async {
    await [Permission.storage].request();

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple ?? false,
      onFileLoading: (status) {
        return const Center(child: CircularProgressIndicator());
      },
      type: FileType.image,
    );

    if (result != null) {
      List<File> files = [];
      int fileCount = result.count ?? 0;

      if (fileCount > 5) {
        Fluttertoast.showToast(
          msg: "You can only upload 5 files at a time.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Process only the first 5 files
        for (int i = 0; i < 5; i++) {
          final filePath = result.paths[i];
          if (filePath != null) {
            final file = File(filePath);
            if (await file.length() > 25 * 1024 * 1024) {
              // 25 MB
              Fluttertoast.showToast(
                msg: "The file may not be greater than 25 MB.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              if ((file.lengthSync()) / (1024 * 1024) > 2.0 ||
                  file.path.split('.').last.toLowerCase() == 'heic' ||
                  file.path.split('.').last.toLowerCase() == 'hevc') {
                File compressedFile =
                    await compressImage(file.path, quality: 35);
                files.add(compressedFile);
              } else {
                files.add(file);
              }
            }
          }
        }
      } else {
        for (var filePath in result.paths) {
          if (filePath != null) {
            final file = File(filePath);
            if (await file.length() > 25 * 1024 * 1024) {
              // 25 MB
              Fluttertoast.showToast(
                msg: "The file may not be greater than 25 MB.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              if ((file.lengthSync()) / (1024 * 1024) > 2.0 ||
                  file.path.split('.').last.toLowerCase() == 'heic' ||
                  file.path.split('.').last.toLowerCase() == 'hevc') {
                File compressedFile =
                    await compressImage(file.path, quality: 35);
                files.add(compressedFile);
              } else {
                files.add(file);
              }
            }
          }
        }
      }

      return files;
    } else {
      return null;
    }
  }

  static Future<File> compressImage(String path, {int quality = 10}) async {
    // var dir = Platform.isAndroid
    //     ? (await DownloadsPathProvider.downloadsDirectory ??
    //         await getApplicationSupportDirectory())
    //     : await getApplicationSupportDirectory();
    try {
      var dir = await getApplicationSupportDirectory();

      final target =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
          path, target,
          quality: quality, keepExif: true);
      File? compressedFile =
          compressedXFile == null ? null : File(compressedXFile.path);

      return compressedFile ?? File(path);
    } catch (_) {
      return File(path);
    }
  }

  // checks device permission, platform, file size and gets the Image
  Future<List<File>?> getCameraImageFiles(
      {bool? allowMultiple = false, void Function()? isLoading}) async {
    await [Permission.camera, Permission.microphone].request();
    final result = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.camera);
    if (isLoading != null) isLoading();
    if (result == null) return null;
    var file = File(result.path);

    if (await file.length() > 25000 * 1000) {
      Fluttertoast.showToast(
          msg: "The file may not be greater than 25 MB.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    } else {
      if ((file.lengthSync()) / (1024 * 1024) > 2.0 ||
          file.path.split('.')[1].toLowerCase == 'heic' ||
          file.path.split('.')[1].toLowerCase == 'hevc') {
        File compressedFile = await compressImage(file.path, quality: 35);
        return [compressedFile];
      } else {
        return [file];
      }
    }
  }
}
