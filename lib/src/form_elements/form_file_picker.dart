import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/form_elements/simple_file_picker.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../models/attachment.dart';

class FormFilePicker extends ConsumerWidget {
  const FormFilePicker({
    super.key,
    required this.fileField,
    required this.labelText,
    required this.imageBuild,
    required this.attachmentSave,
  });
  final FileInputField fileField;
  final String labelText;

  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(simpleFilePickerProvider(fileField.id), (previous, next) {});
    ref.read(simpleFilePickerProvider(fileField.id));

    return FormField<List<Attachment>>(
      validator: (List<Attachment>? value) {
        if (fileField.isRequired) {
          if (value == null || value.isEmpty) {
            return 'Please select at least one file';
          } else if (value.any((element) => element.isUploaded == false)) {
            return 'Some files are processing';
          }
        }
        return null;
      },
      onSaved: (List<Attachment>? value) {},
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleFilePicker(
              fieldId: fileField.id,
              
              fileBuild: imageBuild,
              initialFiles: fileField.answer
                      ?.map((e) => Attachment.fromJson(e))
                      .toList() ??
                  [],
              onFilesSelected: (image) async {
                try {
                  final result =
                      await attachmentSave(image.map((e) => e.file!).toList());
                  return result;
                } catch (e) {
                  throw Exception(e);
                }
              },
              savedCurrentFiles: (images) {
                field.didChange(images);
              },
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
