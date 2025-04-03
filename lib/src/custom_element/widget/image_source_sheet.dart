import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor/image_editor.dart' as Editor;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../form_builder_image_picker.dart';

typedef FutureVoidCallBack = Future<void> Function();

class ImageSourceBottomSheet extends StatefulWidget {
  /// Optional maximum height of image
  final double? maxHeight;

  /// Optional maximum width of image
  final double? maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned.
  final int? imageQuality;

  final int? remainingImages;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`.
  final CameraDevice preferredCameraDevice;

  /// Callback when an image is selected.
  final void Function(Iterable<XFile> files) onImageSelected;

  /// The sources to create ListTiles for.
  /// Either [ImageSourceOption.gallery], [ImageSourceOption.camera] or both.
  final List<ImageSourceOption> availableImageSources;

  final Widget? cameraIcon;
  final Widget? galleryIcon;
  final Widget? cameraLabel;
  final Widget? galleryLabel;
  final EdgeInsets? bottomSheetPadding;
  final bool preventPop;
  final Widget Function(File imageFile) customPainter;
  final String locationData;

  final Widget Function(
          FutureVoidCallBack cameraPicker, FutureVoidCallBack galleryPicker)?
      optionsBuilder;

  const ImageSourceBottomSheet({
    super.key,
    this.remainingImages,
    this.preventPop = false,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    required this.onImageSelected,
    this.cameraIcon,
    this.galleryIcon,
    this.cameraLabel,
    this.galleryLabel,
    this.bottomSheetPadding,
    this.optionsBuilder,
    required this.availableImageSources,
    required this.customPainter,
    required this.locationData,
  });

  @override
  ImageSourceBottomSheetState createState() => ImageSourceBottomSheetState();
}

class ImageSourceBottomSheetState extends State<ImageSourceBottomSheet> {
  bool _isPickingImage = false;

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

  Future<String> getCurrentTimezone() async {
    try {
      final _timezone = await FlutterTimezone.getLocalTimezone();
      return _timezone;
    } catch (e) {
      return '';
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

  Future<File?> handleOption(
      {required Uint8List currentImage, required String? address}) async {
    final timestamp = DateTime.now();
    String firstLine = DateFormat('dd MMM, yyyy hh:mm aa').format(timestamp);
    String timeZone = await getCurrentTimezone();

    String lines = '$firstLine $timeZone';

    if (address != null) {
      lines = '$firstLine $timeZone \n$address';
    }
    final Editor.ImageEditorOption option = Editor.ImageEditorOption();
    final Editor.AddTextOption textOption = Editor.AddTextOption();

    textOption.addText(
      Editor.EditorText(
          offset: const Offset(10, 10),
          text: lines,
          fontSizePx: 75,
          textColor: Colors.red,
          // fontName: fontName,
          textAlign: TextAlign.left),
    );
    option.outputFormat = Editor.OutputFormat.jpeg(20);

    option.addOption(textOption);

    option.outputFormat = Editor.OutputFormat.jpeg(20);

    final unifileImage = await Editor.ImageEditor.editImage(
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

  Future<void> _onPickImage(ImageSource source) async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    final imagePicker = ImagePicker();
    try {
      if (source == ImageSource.camera || widget.remainingImages == 1) {
        final pickedFile = await imagePicker.pickImage(
          source: source,
          preferredCameraDevice: widget.preferredCameraDevice,
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
        );
        _isPickingImage = false;
        if (pickedFile != null) {
          File file = File(pickedFile.path);
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
            return;
          } else {
            // final editedImage = await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => widget.customPainter(
            //       file,
            //     ),
            //   ),
            // );
            // File? fileCustomImage = await handleOption(
            //     currentImage: editedImage, address: widget.locationData);
            // if (fileCustomImage != null) {
            //   widget.onImageSelected([XFile(fileCustomImage.path)]);
            //   return;
            // }
            widget.onImageSelected([pickedFile]);
            return;
          }
        }
      } else {
        final pickedFiles = await imagePicker.pickMultiImage(
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
        );
        _isPickingImage = false;
        if (pickedFiles.isNotEmpty) {
          widget.onImageSelected(pickedFiles);
          return;
        }
      }
    } catch (e) {
      _isPickingImage = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.optionsBuilder != null) {
      return widget.optionsBuilder!(
        () => _onPickImage(ImageSource.camera),
        () => _onPickImage(ImageSource.gallery),
      );
    }
    Widget res = Container(
      padding: widget.bottomSheetPadding,
      child: Wrap(
        children: <Widget>[
          if (widget.availableImageSources.contains(ImageSourceOption.camera))
            ListTile(
              leading: widget.cameraIcon,
              title: widget.cameraLabel,
              onTap: () => _onPickImage(ImageSource.camera),
            ),
          if (widget.availableImageSources.contains(ImageSourceOption.gallery))
            ListTile(
              leading: widget.galleryIcon,
              title: widget.galleryLabel,
              onTap: () => _onPickImage(ImageSource.gallery),
            ),
        ],
      ),
    );
    if (widget.preventPop) {
      res = PopScope(
        canPop: !_isPickingImage,
        child: res,
      );
    }
    return res;
  }
}
