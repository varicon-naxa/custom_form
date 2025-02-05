// ignore_for_file: invalid_use_of_visible_for_testing_member, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart' as Picker;
import 'package:mime/mime.dart';
import 'package:intl/intl.dart';
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
      // type: FileType.any
      type: type,
      allowedExtensions: type == FileType.custom
          ? ['doc', 'pdf', 'docx', 'xslx', 'docx', 'mp4', 'mp3', 'xlsx']
          : null,
    );
    if (result != null) {
      List<File> files = [];
      int fileCount = result.count;

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
              if (((file.lengthSync()) / (1024 * 1024) > 2.0 &&
                      type == FileType.image) ||
                  file.path.split('.').last.toLowerCase() == 'heic' ||
                  file.path.split('.').last.toLowerCase() == 'hevc') {
                File compressedFile =
                    await compressImage(file.path, quality: 10);
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
                    await compressImage(file.path, quality: 10);
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

  bool isImage({required String path}) {
    final mimeType = lookupMimeType(path) ?? '';

    return mimeType.startsWith('image/');
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
      int fileCount = result.count;

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
                    await compressImage(file.path, quality: 10);
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
                    await compressImage(file.path, quality: 10);
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

  //convert Uint8List to File
  Future<File> convertUint8ListToFile(Uint8List uint8List) async {
    // Save the edited image to a new file
    final directory = await getApplicationSupportDirectory();
    final newImagePath =
        '${directory.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(newImagePath);
    return await file.writeAsBytes(uint8List);
  }

  Future<String> getCurrentTimezone() async {
    try {
      final _timezone = await FlutterTimezone.getLocalTimezone();
      return _timezone;
      // Utils.customLog(
      //     'Could not get the local timezone' + _timezone.toString());
    } catch (e) {
      // Utils.customLog('Could not get the local timezone');
      return '';
    }
  }

  Future<File?> handleOption(
      {required Uint8List currentImage, required String? address}) async {
    // final aliFontUrl =
    //     'https://cdn.jsdelivr.net/gh/kikt-blog/ali_font@master/Alibaba-PuHuiTi-Medium.ttf';

    // final body = await http.get(Uri.parse(aliFontUrl));

    // final tmpDir = await getTemporaryDirectory();
    // final f = File(
    //     '${tmpDir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.ttf');
    // f.writeAsBytesSync(body.bodyBytes);

    // final fontName = await FontManager.registerFont(f);
    final timestamp = DateTime.now();
    String firstLine = DateFormat('dd MMM, yyyy hh:mm aa').format(timestamp);
    String timeZone = await getCurrentTimezone();

    String lines = '$firstLine $timeZone';

    if (address != null) {
      lines = '$firstLine $timeZone \n$address';
    }
    final ImageEditorOption option = ImageEditorOption();
    final AddTextOption textOption = AddTextOption();

    textOption.addText(
      EditorText(
          offset: const Offset(10, 10),
          text: lines,
          fontSizePx: 75,
          textColor: Colors.red,
          // fontName: fontName,
          textAlign: TextAlign.left),
    );
    option.outputFormat = const OutputFormat.jpeg(20);

    option.addOption(textOption);

    option.outputFormat = const OutputFormat.jpeg(20);

    final unifileImage = await ImageEditor.editImage(
      image: currentImage,
      imageEditorOption: option,
    );
    if (unifileImage == null) {
      return null;
    }
    final fileImage = convertUint8ListToFile(unifileImage);

    return fileImage;
    // return fileImage;
  }

  // checks device permission, platform, file size and gets the Image
  Future<List<File>?> getCameraImageFiles(
      {bool? allowMultiple = false,
      void Function()? isLoading,
      required BuildContext context,
      required String locationData,
      required Widget Function(File imageFile) customPainter}) async {
    await [Permission.camera, Permission.microphone].request();
    final result = await Picker.ImagePicker.platform
        .getImageFromSource(source: Picker.ImageSource.camera);
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
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => customPainter(
            file,
          ),
        ),
      );

      File? fileCustomImage =
          await handleOption(currentImage: editedImage, address: locationData);
      if (fileCustomImage != null) {
        return [fileCustomImage];
      } else {
        return [];
      }
    }
  }
}
