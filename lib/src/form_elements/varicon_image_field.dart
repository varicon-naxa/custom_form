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
  List<Map<String, dynamic>> initalAttachments = [];
  List<Map<String, dynamic>> currentAttachments = [];

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
      ...initalAttachments,
      ...currentAttachments
    ];
    setState(() {});

    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          wholeAttachments,
        );
  }

  saveFileToServer(List<Map<String, dynamic>> files) async {
    final loadingIds = files.map((_) => const Uuid().v4()).toList();
    try {
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
      currentAttachments = data;
      List<Map<String, dynamic>> wholeAttachments = [
        ...initalAttachments,
        ...data
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
            // final initialAttachments =
            //     ref.watch(initialAttachmentsProvider(widget.field.id));
            // final loadingStates = ref.watch(attachmentLoadingProvider);

            return Wrap(
              children: [
                ...initalAttachments.map((e) {
                  // final isLoading = loadingStates.isNotEmpty;
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
                          child: Stack(
                            children: [
                              widget.imageBuild({
                                'image': e['file'],
                                'height': 75.0,
                                'width': 75.0
                              }),
                              // if (isLoading)
                              //   Positioned.fill(
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         color: Colors.black.withOpacity(0.1),
                              //         borderRadius: BorderRadius.circular(8.0),
                              //       ),
                              //       child: const Center(
                              //         child: SizedBox(
                              //           width: 20,
                              //           height: 20,
                              //           child: CircularProgressIndicator(
                              //             strokeWidth: 2,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          )),
                      PositionedDirectional(
                        top: 0,
                        end: 12,
                        child: InkWell(
                          onTap:
                              // isLoading
                              //     ? null
                              //     :

                              () {
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
                    initalAttachments.isEmpty)) {
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
