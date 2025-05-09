import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/state/attachment_provider.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../models/attachment.dart';
import 'simple_image_picker.dart';

class FormImagePicker extends ConsumerWidget {
  const FormImagePicker({
    super.key,
    required this.imageField,
    required this.labelText,
    required this.locationData,
    required this.imageBuild,
    required this.customPainter,
    required this.attachmentSave,
  });
  final ImageInputField imageField;
  final String labelText;
  final String locationData;

  final Widget Function(Map<String, dynamic>) imageBuild;
  final Widget Function(File imageFile) customPainter;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(simpleImagePickerProvider(imageField.id), (previous, next) {});
    ref.read(simpleImagePickerProvider(imageField.id));

    return FormField<List<Attachment>>(
      validator: (List<Attachment>? value) {
        if (imageField.isRequired) {
          if (value == null || value.isEmpty) {
            return 'Please select at least one image';
          } else if (value.any((element) => element.isUploaded == false)) {
            return 'Some Image are processing';
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
            SimpleImagePicker(
              fieldId: imageField.id,
              imageBuild: imageBuild,
              customPainter: customPainter,
              locationData: locationData,
              initialImages: imageField.answer
                      ?.map((e) => Attachment.fromJson(e))
                      .toList() ??
                  [],
              onImagesSelected: (image) async {
                try {
                  final result =
                      await attachmentSave(image.map((e) => e.file!).toList());
                  return result;
                } catch (e) {
                  throw Exception(e);
                }
              },
              savedCurrentImages: (images) {
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
