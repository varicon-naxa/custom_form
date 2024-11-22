// ignore_for_file: invalid_use_of_visible_for_testing_member, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

import 'package:varicon_form_builder/src/form_builder/widgets/camera_image_info.dart';

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

  Future<File> convertUint8ListToFile(Uint8List uint8List) async {
    // Save the edited image to a new file
    final directory = await getApplicationSupportDirectory();
    final newImagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(newImagePath);
    return await file.writeAsBytes(uint8List);
  }

  //method to navigate to the edited image page
  Future<Uint8List?> _openEditedImage(
    File imageFile,
    BuildContext? context,
    List<String> imageInfo,
  ) async {
    Uint8List? imageWithMetaData;
    if (context != null) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: LayoutBuilder(builder: (context, constraints) {
                  // Calculate the maximum height for the dialog

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CameraImageInfoPage(
                      imageFile: imageFile,
                      imageInfo: imageInfo,
                    ),
                  );
                }),
              );
            });
          }).then((val) {
        if (val != null) {
          imageWithMetaData = val;
        }
      });
      return imageWithMetaData;
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return imageWithMetaData;
    }
  }

  // checks device permission, platform, file size and gets the Image
  Future<List<File>?> getCameraImageFiles(
      {bool? allowMultiple = false,
      void Function()? isLoading,
      required BuildContext context,
      required String locationData,
      required Widget Function(File imageFile) customPainter}) async {
    String guidelines = '''

To utilize this feature, please follow these steps to enable storage access on your device:

1. Access App Settings
2. Find App Permissions
3. Locate Storage Permission
4. Enable Storage Access
5. If specified separately, ensure access to Photos and Videos
6. Return to App
''';
    try {
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
        // final editedImage = await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => customPainter(
        //       file,
        //     ),
        //   ),
        // );
        final File fileImage = file;
        // await convertUint8ListToFile(editedImage);

        // Add timestamp
        final timestamp = DateTime.now();
        String firstLine =
            DateFormat('dd MMM, yyyy hh:mm aa').format(timestamp);

        List<String> lines = [firstLine];
        lines.add(locationData);

        Uint8List? updatedImage =
            await _openEditedImage(fileImage, context, lines);
        final List<Future<File>> futures = [
          if (updatedImage != null) convertUint8ListToFile(updatedImage),
        ];

        return await Future.wait(futures);
      }
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        var status = await Permission.camera.request();
        if (status.isGranted) {
          await getCameraImageFiles(
              isLoading: isLoading,
              context: context,
              locationData: locationData,
              customPainter: customPainter);
        } else if (status.isDenied) {
          showD(
              context: context,
              title: 'Camera Access Denied',
              message: guidelines);
        } else if (status.isPermanentlyDenied) {
          showD(
              context: context,
              title: 'Camera Access Denied',
              message: guidelines);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  void showMessageInDialog(
      {required BuildContext context,
      required String title,
      required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showD({BuildContext? context, String? title, required String message}) {
    if (context != null) {
      showMessageInDialog(
          context: context, title: title ?? '', message: message);
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Future.delayed(const Duration(seconds: 5), () {
        openAppSettings();
      });
    }
  }
}
