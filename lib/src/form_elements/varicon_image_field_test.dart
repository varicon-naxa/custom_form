import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/form_elements/simple_image_picker.dart';
import '../../varicon_form_builder.dart';

class VariconImageFieldTest extends StatefulHookConsumerWidget {
  const VariconImageFieldTest({
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
  ConsumerState<VariconImageFieldTest> createState() => _VariconImageFieldTestState();
}

class _VariconImageFieldTestState extends ConsumerState<VariconImageFieldTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SimpleImagePicker(
        //   maxImages: 5,
        //   initialImages: [], // Optional
        //   onImagesSelected: (List<Map<String, dynamic>> images) {
        //     // Handle selected images
        //     // Each image has: {'id': 'uuid', 'path': 'file_path'}
        //   },
        // )
      ],
    );
  }
}
