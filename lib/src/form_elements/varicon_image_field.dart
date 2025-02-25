import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_image_picker.dart';
import '../helpers/utils.dart';

class VariconImageField extends StatefulHookConsumerWidget {
  const VariconImageField({
    super.key,
    required this.field,
    required this.labelText,
    required this.attachmentSave,
    required this.imageBuild,
  });

  final ImageInputField field;
  final String labelText;

  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  ConsumerState<VariconImageField> createState() => _VariconImageFieldState();
}

class _VariconImageFieldState extends ConsumerState<VariconImageField> {
  List<Map<String, dynamic>> attachments = [];

  @override
  void initState() {
    super.initState();
    attachments.addAll(widget.field.answer ?? []);
    setState(() {});
  }

  saveFileToServer(List<dynamic> files) async {
    List<String> paths = await Future.wait(files.map((e) async {
      if (e is XFile) {
        return e.path.toString();
      } else if (e is Uint8List) {
        File data = await Utils.getConvertToFile(e);
        return data.path.toString();
      } else {
        return e.toString();
      }
    }).toList());

    List<Map<String, dynamic>> attachments = [];
    final data = await widget.attachmentSave(
      paths,
    );
    attachments = [...attachments, ...data];
    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          attachments,
        );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderImagePicker(
      name: 'photos',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      availableImageSources: const [
        ImageSourceOption.gallery,
        ImageSourceOption.camera
      ],
      initialWidget: Wrap(
        children: [
          ...attachments.map((e) {
            return Stack(
              key: ObjectKey(e),
              children: <Widget>[
                Container(
                    height: 75,
                    margin: const EdgeInsets.only(
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    width: 75,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: widget.imageBuild({
                      'image': e['file'],
                    })),
                PositionedDirectional(
                  top: 0,
                  end: 12,
                  child: InkWell(
                    onTap: () {
                      attachments.remove(e);
                      setState(() {});
                      saveFileToServer([]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      height: 18,
                      width: 18,
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      onChanged: (value) {
        saveFileToServer(value ?? []);
      },
      validator: (value) {
        if (widget.field.isRequired &&
            ((value == null || value.isEmpty) && attachments.isEmpty)) {
          return "This field is required";
        }
        return null;
      },
      maxImages: 10,
    );
  }
}
