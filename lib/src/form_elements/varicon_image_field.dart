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
  List<Map<String, dynamic>> currentAttachments = [];
  String? loadingId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(initialAttachmentsProvider(widget.field.id).notifier)
          .setAttachments(widget.field.answer ?? []);
    });
  }

  removeFileFromServer(Map<String, dynamic> file) {
    final notifier =
        ref.read(initialAttachmentsProvider(widget.field.id).notifier);
    notifier.removeAttachment(file['id']);

    final wholeAttachments = [...notifier.state, ...currentAttachments];

    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          wholeAttachments,
        );
  }

  saveFileToServer(List<dynamic> files) async {
       ref.read(attachmentLoadingProvider.notifier).removeLoading(loadingId!);
        loadingId = const Uuid().v4();
        ref.read(attachmentLoadingProvider.notifier).addLoading(loadingId!);
      }  try {
      if (loadingId != null) {
   

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

      final data = await widget.attachmentSave(
        paths,
      );
      currentAttachments = data;
      List<Map<String, dynamic>> wholeAttachments = [
        ...(ref
            .read(initialAttachmentsProvider(widget.field.id).notifier)
            .state),
        ...data
      ];
      ref.read(currentStateNotifierProvider.notifier).saveList(
            widget.field.id,
            wholeAttachments,
          );
    } finally {
      if (loadingId != null) {
        ref.read(attachmentLoadingProvider.notifier).removeLoading(loadingId!);
        loadingId = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderImagePicker(
          key: Key(const Uuid().v4()),
          customPainter: widget.customPainter,
          locationData: widget.locationData,
          preventPop: true,
          name: const Uuid().v4(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          imageQuality: 40,
          availableImageSources: const [
            ImageSourceOption.gallery,
            ImageSourceOption.camera
          ],
          initialWidget: Consumer(builder: (context, ref, child) {
            final initialAttachments =
                ref.watch(initialAttachmentsProvider(widget.field.id));
            return Wrap(
              children: [
                ...initialAttachments.map((e) {
                  return Stack(
                    key: ObjectKey(e),
                    children: <Widget>[
                      Container(
                          height: 75,
                          margin: const EdgeInsets.only(
                            right: 8.0,
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
                            removeFileFromServer(e);
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
            );
          }),
          onChanged: (value) {
            saveFileToServer(value ?? []);
          },
          validator: (value) {
            if (widget.field.isRequired &&
                ((value == null || value.isEmpty) &&
                    ref
                        .read(initialAttachmentsProvider(widget.field.id)
                            .notifier)
                        .state
                        .isEmpty)) {
              return "This field is required";
            }
            return null;
          },
          maxImages: 10,
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
