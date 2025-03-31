import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_file_picker.dart';

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

  @override
  void initState() {
    super.initState();

    initalAttachments.addAll(widget.field.answer ?? []);
    setState(() {});
  }

  removeFileFromServer(Map<String, dynamic> file) {
    initalAttachments.removeWhere((element) => element['id'] == file['id']);
    List<Map<String, dynamic>> wholeAttachments = [
      ...initalAttachments,
      ...currentAttachments
    ];
    setState(() {});

    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          wholeAttachments,
        );
  }

  saveFileToServer(List<PlatformFile> files) async {
    List<String> filePath = files.map((e) => e.path.toString()).toList();
    final data = await widget.attachmentSave(
      filePath,
    );
    currentAttachments = data;
    List<Map<String, dynamic>> wholeAttachments = [
      ...initalAttachments,
      ...data
    ];

    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          wholeAttachments,
        );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderFilePicker(
      name: const Uuid().v4(),
      customPainter: widget.customPainter,
      previewImages: true,
      allowMultiple: true,
      allowCompression: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      withData: true,
      previousImage: Wrap(
        children: initalAttachments
            .map(
              (attachment) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Utils.getIconData(
                        attachment['mime_type'],
                      ),
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        attachment['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        removeFileFromServer(attachment);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: .7),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        height: 18,
                        width: 18,
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
      onChanged: (value) {
        List<PlatformFile> values = value ?? [];
        saveFileToServer(values);
      },
      validator: (value) {
        if (widget.field.isRequired &&
            ((value == null || value.isEmpty) && initalAttachments.isEmpty)) {
          return "This field is required";
        }
        return null;
      },
      typeSelectors: const [
        TypeSelector(
          type: FileType.any,
          selector: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.file_present),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Upload File"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
