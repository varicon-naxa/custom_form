import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_editor/image_editor.dart' as Editor;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../models/attachment.dart';

class SimpleImagePicker extends StatefulHookConsumerWidget {
  const SimpleImagePicker({
    super.key,
    required this.savedCurrentImages,
    required this.onImagesSelected,
    required this.fieldId,
    this.initialImages = const [],
    required this.imageBuild,
    required this.customPainter,
    required this.locationData,
  });

  final String fieldId;
  final Function(List<Attachment>) savedCurrentImages;
  final List<Attachment> initialImages;
  final Future<List<Map<String, dynamic>>> Function(List<Attachment>)
      onImagesSelected;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Widget Function(File imageFile) customPainter;
  final String locationData;

  @override
  ConsumerState<SimpleImagePicker> createState() => _SimpleImagePickerState();
}

class _SimpleImagePickerState extends ConsumerState<SimpleImagePicker> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.initialImages.isNotEmpty) {
        ref
            .read(simpleImagePickerProvider(widget.fieldId).notifier)
            .addAll(widget.initialImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: () => _showImageSourcePicker(context),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined, size: 32),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final isUploaded =
                    ref.watch(simpleImagePickerProvider(widget.fieldId));
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...isUploaded.map((image) => _buildImagePreview(image)),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(
    Attachment image,
  ) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image.isUploaded == true)
                  widget.imageBuild(
                      {'image': image.file, 'height': 75.0, 'width': 75.0})
                else
                  Image.file(
                    File(image.file!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image),
                      );
                    },
                  ),
                if (image.isUploaded == false)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (image.isUploaded ?? false)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(simpleImagePickerProvider(widget.fieldId).notifier)
                    .removeImage(image);
                widget.savedCurrentImages(
                  (ref
                      .read(simpleImagePickerProvider(widget.fieldId).notifier)
                      .state),
                );
                ref.read(currentStateNotifierProvider.notifier).saveList(
                      widget.fieldId,
                      (ref
                              .read(simpleImagePickerProvider(widget.fieldId)
                                  .notifier)
                              .state)
                          .map((e) => e.toJson())
                          .toList(),
                    );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  void _showImageSourcePicker(BuildContext context) {
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

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _pickImage();
                if (image != null) {
                  File file = File(image.path);
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
                    File? fileCustomImage = await handleOption(
                        currentImage: await image.readAsBytes(),
                        address: widget.locationData);
                    if (fileCustomImage != null) {
                      final attachment = Attachment(
                        file: fileCustomImage.path,
                        isUploaded: false,
                        localId: const Uuid().v4(),
                      );
                      ref
                          .read(simpleImagePickerProvider(widget.fieldId)
                              .notifier)
                          .addImage(attachment);
                      widget.savedCurrentImages(
                        (ref
                            .read(simpleImagePickerProvider(widget.fieldId)
                                .notifier)
                            .state),
                      );
                      try {
                        final result =
                            await widget.onImagesSelected([attachment]);
                        if (result.isNotEmpty) {
                          ref
                              .read(simpleImagePickerProvider(widget.fieldId)
                                  .notifier)
                              .updateImage(Attachment(
                                id: result[0]['id'],
                                file: result[0]['file'],
                                thumbnail: result[0]['thumbnail'],
                                name: result[0]['name'],
                                localId: attachment.localId,
                                mime: result[0]['mime_type'],
                                isUploaded: true,
                              ));
                          ref
                              .read(currentStateNotifierProvider.notifier)
                              .saveList(
                                widget.fieldId,
                                (ref
                                        .read(simpleImagePickerProvider(
                                                widget.fieldId)
                                            .notifier)
                                        .state)
                                    .map((e) => e.toJson())
                                    .toList(),
                              );
                        } else {
                          ref
                              .read(simpleImagePickerProvider(widget.fieldId)
                                  .notifier)
                              .removeLocalImage(attachment);
                        }
                      } catch (e) {
                        ref
                            .read(simpleImagePickerProvider(widget.fieldId)
                                .notifier)
                            .removeLocalImage(attachment);
                      } finally {
                        widget.savedCurrentImages(
                          (ref
                              .read(simpleImagePickerProvider(widget.fieldId)
                                  .notifier)
                              .state),
                        );
                      }
                    }
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? image = await _pickMultiImage();
                if (image != null) {
                  final attachments = image
                      .map((e) => Attachment(
                            file: e.path,
                            isUploaded: false,
                            localId: Uuid().v4(),
                          ))
                      .toList();
                  ref
                      .read(simpleImagePickerProvider(widget.fieldId).notifier)
                      .addMultiImage(attachments);
                  widget.savedCurrentImages(
                    (ref
                        .read(
                            simpleImagePickerProvider(widget.fieldId).notifier)
                        .state),
                  );
                  try {
                    final result = await widget.onImagesSelected(attachments);
                    if (result.isNotEmpty) {
                      for (int i = 0; i < result.length; i++) {
                        ref
                            .read(simpleImagePickerProvider(widget.fieldId)
                                .notifier)
                            .updateImage(Attachment(
                              id: result[i]['id'],
                              file: result[i]['file'],
                              thumbnail: result[i]['thumbnail'],
                              name: result[i]['name'],
                              localId: attachments[i].localId,
                              mime: result[0]['mime_type'],
                              isUploaded: true,
                            ));
                      }

                      ref.read(currentStateNotifierProvider.notifier).saveList(
                            widget.fieldId,
                            (ref
                                    .read(simpleImagePickerProvider(
                                            widget.fieldId)
                                        .notifier)
                                    .state)
                                .map((e) => e.toJson())
                                .toList(),
                          );
                    } else {
                      for (var attachment in attachments) {
                        ref
                            .read(simpleImagePickerProvider(widget.fieldId)
                                .notifier)
                            .removeLocalImage(attachment);
                      }
                    }
                  } catch (e) {
                    for (var attachment in attachments) {
                      ref
                          .read(simpleImagePickerProvider(widget.fieldId)
                              .notifier)
                          .removeLocalImage(attachment);
                    }
                  } finally {
                    widget.savedCurrentImages(
                      (ref
                          .read(simpleImagePickerProvider(widget.fieldId)
                              .notifier)
                          .state),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<List<XFile>?> _pickMultiImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? image = await picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
        limit: 5,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}
