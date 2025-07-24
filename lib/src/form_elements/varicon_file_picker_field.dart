import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import 'package:varicon_form_builder/src/state/attachment_loading_provider.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_file_picker.dart';
import 'optimized_file_picker.dart';

class VariconFilePickerField extends StatefulHookConsumerWidget {
  const VariconFilePickerField({
    super.key,
    required this.field,
    required this.labelText,
    required this.attachmentSave,
    required this.customPainter,
  });

  final FileInputField field;
  final String labelText;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  final Widget Function(File imageFile) customPainter;

  @override
  ConsumerState<VariconFilePickerField> createState() =>
      _VariconFilePickerFieldState();
}

class _VariconFilePickerFieldState
    extends ConsumerState<VariconFilePickerField> {
  List<Map<String, dynamic>> initalAttachments = [];
  List<Map<String, dynamic>> currentAttachments = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    initalAttachments.addAll(widget.field.answer ?? []);
    setState(() {});
  }

  @override
  void didUpdateWidget(VariconFilePickerField oldWidget) {
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

  saveFileToServer(List<PlatformFile> files) async {
    final loadingIds = files.map((_) => const Uuid().v4()).toList();
    try {
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).addLoading(id);
      }
      List<String> filePath = files.map((e) => e.path.toString()).toList();
      final data = await widget.attachmentSave(
        filePath,
      );
      currentAttachments = data;
      List<Map<String, dynamic>> wholeAttachments = [
        ...data, // New attachments at the beginning (most recent first)
        ...initalAttachments,
      ];

      ref.read(currentStateNotifierProvider.notifier).saveList(
            widget.field.id,
            wholeAttachments,
          );
    } finally {
      for (var id in loadingIds) {
        ref.read(attachmentLoadingProvider.notifier).removeLoading(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use optimized file picker for better performance
        OptimizedFilePicker(
          fieldId: widget.field.id,
          savedCurrentFiles: (files) {
            // Convert Attachment objects to Map format for compatibility
            final fileMaps = files.map((file) => file.toJson()).toList();
            ref.read(currentStateNotifierProvider.notifier).saveList(
                  widget.field.id,
                  fileMaps,
                );
          },
          onFilesSelected: (files) async {
            // Convert Attachment objects to file paths for upload
            final filePaths = files.map((file) => file.file!).toList();
            return await widget.attachmentSave(filePaths);
          },
          initialFiles:
              initalAttachments.map((e) => Attachment.fromJson(e)).toList(),
          fileBuild: (fileData) {
            // This can be customized based on your needs
            return Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Utils.getIconData(fileData['mime_type'] ?? ''),
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileData['name'] ?? 'Unknown File',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
          allowedExtensions: const [], // Allow all file types
        ),
      ],
    );
  }
}
