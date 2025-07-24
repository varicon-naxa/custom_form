import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/state/attachment_loading_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_image_picker.dart';
import '../helpers/utils.dart';
import 'package:intl/intl.dart';
import 'optimized_image_picker.dart';

class VariconImageField extends StatefulHookConsumerWidget {
  const VariconImageField({
    super.key,
    required this.field,
    required this.labelText,
    required this.attachmentSave,
    required this.imageBuild,
    required this.customPainter,
    required this.locationData,
  });

  final ImageInputField field;
  final String labelText;
  final String locationData;

  final Widget Function(Map<String, dynamic>) imageBuild;
  final Widget Function(File imageFile) customPainter;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  ConsumerState<VariconImageField> createState() => _VariconImageFieldState();
}

class _VariconImageFieldState extends ConsumerState<VariconImageField> {
  List<Map<String, dynamic>> initalAttachments = [];
  List<Map<String, dynamic>> currentAttachments = [];

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isError = ValueNotifier(false);
  String convertToLocalTime(String utcDateTimeString) {
    final utcDateTime = DateTime.parse(utcDateTimeString);
    final localDateTime = utcDateTime.toLocal();
    final formatter = DateFormat('dd MMM yyyy hh:mm a');
    return formatter.format(localDateTime);
  }

  @override
  void initState() {
    super.initState();
    initalAttachments.addAll(widget.field.answer ?? []);
    setState(() {});
  }

  @override
  void didUpdateWidget(VariconImageField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.field.answer != widget.field.answer) {
      initalAttachments.clear();
      initalAttachments.addAll(widget.field.answer ?? []);
      setState(() {});
    }
  }

  removeFileFromServer(Map<String, dynamic> file) {
    initalAttachments.removeWhere((element) => element['id'] == file['id']);
    List<Map<String, dynamic>> wholeAttachments = [
      ...currentAttachments, // New attachments at the beginning
      ...initalAttachments,
    ];
    setState(() {});

    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          wholeAttachments,
        );
  }

  saveFileToServer(List<Map<String, dynamic>> files) async {
    final loadingIds = files.map((_) => const Uuid().v4()).toList();
    isLoading.value = true;

    try {
      isError.value = false;
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).addLoading(id);
      }

      List<String> filePath = await Future.wait(files.map((element) async {
        final e = element['data'];
        if (e is XFile) {
          return e.path.toString();
        } else if (e is Uint8List) {
          File data = await Utils.getConvertToFile(e);
          return data.path.toString();
        } else {
          return e.toString();
        }
      }).toList());
      // List<String> filePath = files.map((e) => e.path.toString()).toList();
      final data = await widget.attachmentSave(
        filePath,
      );
      if (data.isEmpty) {
        isError.value = true;
        return;
      }
      currentAttachments = data;
      List<Map<String, dynamic>> wholeAttachments = [
        ...data, // New attachments at the beginning (most recent first)
        ...initalAttachments,
      ];

      ref.read(currentStateNotifierProvider.notifier).saveList(
            widget.field.id,
            wholeAttachments,
          );
    } catch (e) {
      isError.value = true;
      log(e.toString());
    } finally {
      isLoading.value = false;
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).removeLoading(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use optimized image picker for better performance
        OptimizedImagePicker(
          fieldId: widget.field.id,
          savedCurrentImages: (images) {
            // Convert Attachment objects to Map format for compatibility
            final imageMaps = images.map((img) => img.toJson()).toList();
            ref.read(currentStateNotifierProvider.notifier).saveList(
                  widget.field.id,
                  imageMaps,
                );
          },
          onImagesSelected: (images) async {
            // Convert Attachment objects to file paths for upload
            final filePaths = images.map((img) => img.file!).toList();
            return await widget.attachmentSave(filePaths);
          },
          initialImages:
              initalAttachments.map((e) => Attachment.fromJson(e)).toList(),
          imageBuild: widget.imageBuild,
          customPainter: widget.customPainter,
          locationData: widget.locationData,
        ),
      ],
    );
  }
}

final initialAttachmentsProvider = StateNotifierProvider.family<
    InitialAttachmentsNotifier, List<Map<String, dynamic>>, String>((ref, id) {
  return InitialAttachmentsNotifier();
});

class InitialAttachmentsNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  InitialAttachmentsNotifier() : super([]);

  void setAttachments(List<Map<String, dynamic>> attachments) {
    state = attachments;
  }

  void removeAttachment(String id) {
    state = state.where((element) => element['id'] != id).toList();
  }
}
