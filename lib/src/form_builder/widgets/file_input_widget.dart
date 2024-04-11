// ignore_for_file: must_be_immutable, unnecessary_cast
import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/primary_bottomsheet.dart';
import 'package:varicon_form_builder/src/mixin/file_picker_mixin.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../../models/form_value.dart';
import '../../models/value_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FileInputWidget extends StatefulWidget {
  const FileInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.attachmentSave,
    required this.filetype,
    required this.onSaved,
    required this.imageBuild,
    required this.fileClicked,
    this.labelText,
  });

  final dynamic field;
  final FormValue formValue;
  final String? labelText;
  final FileType filetype;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Function(String) fileClicked;
  final void Function(List<Map<String, dynamic>>) onSaved;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  State<FileInputWidget> createState() => _FileInputWidgetState();
}

class _FileInputWidgetState extends State<FileInputWidget>
    with FilePickerMixin {
  String? value;
  bool isLoading = false;
  List<Map<String, dynamic>> answer = [];

  late final List<ValueText> choices;
  late final String otherFieldKey;

  @override
  void initState() {
    super.initState();
    answer = widget.field.answer ?? [];
    widget.formValue.saveList(widget.field.id, answer);
  }

  Future<void> saveFiletoServer(List<File>? result,
      {bool isMultiple = false}) async {
    if (result != null) {
      setState(() {
        isLoading = true;
      });
      if (isMultiple) {
        final data = await widget
            .attachmentSave(result.map((e) => e.path.toString()).toList());
        var currentList = widget.formValue.getMappedList(
          widget.field.id,
        ) as List<Map<String, dynamic>>;

        widget.onSaved([...data, ...currentList]);
        setState(() {
          answer = [...data, ...currentList];
          isLoading = false;
        });
      } else {
        final data = await widget
            .attachmentSave(result.map((e) => e.path.toString()).toList());
        setState(() {
          answer = data;
          widget.onSaved(data);
          isLoading = false;
        });
      }
    }
  }

  Future<void> storeFiles({bool fromCamera = false}) async {
    if (widget.filetype == FileType.image) {
      Navigator.of(context).pop();
    }
    if (fromCamera) {
      final result = await getCameraImageFiles();
      saveFiletoServer(result, isMultiple: widget.field.isMultiple ?? false);
    } else {
      final result = await getFiles(
          type:
              widget.filetype == FileType.image ? FileType.image : FileType.any,
          allowMultiple: widget.field.isMultiple ?? false);
      saveFiletoServer(result, isMultiple: widget.field.isMultiple ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    void customBottom() {
      primaryCustomBottomSheet(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.sizedBoxH_16(),
            Text(
              'ADD PHOTO',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(
                      0xff98A5B9,
                    ),
                  ),
            ),
            AppSpacing.sizedBoxH_20(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      storeFiles(fromCamera: true);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: Color(
                              0xff5F6D83,
                            ),
                          ),
                          Text(
                            'Camera',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(
                                        0xff5F6D83,
                                      ),
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: VerticalDivider(
                      thickness: 2,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      storeFiles(fromCamera: false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.photo_library,
                              color: Color(
                                0xff5F6D83,
                              )),
                          Text(
                            'Photo Library',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(
                                        0xff5F6D83,
                                      ),
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.sizedBoxH_06(),
          ],
        ),
      );
    }

    Widget multipleItem() {
      return Wrap(
          children: answer.map((singleItem) {
        return (singleItem.containsKey('id') && singleItem.containsKey('file'))
            ? SingleFileItem(
                filePath: singleItem['file'],
                fileName: singleItem['name'],
                imageBuild: widget.imageBuild({
                  'image': singleItem['file'],
                  'height': 120.0,
                  'width': 120.0
                }),
                fileClicked: () {
                  widget.fileClicked(singleItem['file']);
                },
                isImage: widget.filetype == FileType.image ? true : false,
                ontap: () {
                  var currentList = [
                    ...widget.formValue.getMappedList(
                      widget.field.id,
                    )
                  ];
                  currentList.removeWhere((element) =>
                      element['id'].toString() == singleItem['id'].toString());
                  widget.onSaved(currentList);
                  setState(() {
                    answer = currentList;
                  });
                },
              )
            : const SizedBox.shrink();
      }).toList());
    }

    return isLoading
        ? widget.filetype == FileType.image
            ? Container(
                width: 70.0,
                height: 70.0,
                color: Colors.white,
              )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  color: Colors.grey.shade300,
                  duration: const Duration(seconds: 2),
                )
            : Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
              )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  color: Colors.grey.shade300,
                  duration: const Duration(seconds: 2),
                )
        : (widget.field.isMultiple ?? false)
            ? Column(
                children: [
                  multipleItem(),
                  SingleFileAddItem(
                      isImage: widget.filetype == FileType.image,
                      onTap: () async {
                        if (widget.filetype == FileType.image) {
                          customBottom();
                        } else {
                          storeFiles();
                        }
                      })
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((answer).isNotEmpty)
                    SingleFileItem(
                      filePath: answer[0]['file'],
                      fileName: answer[0]['name'],
                      imageBuild: widget.imageBuild({
                        'image': answer[0]['file'],
                        'height': 120.0,
                        'width': 120.0
                      }),
                      fileClicked: () {
                        widget.fileClicked(answer[0]['file']);
                      },
                      isImage: widget.filetype == FileType.image ? true : false,
                      ontap: () {
                        setState(() {
                          widget.onSaved([]);

                          answer = [];
                        });
                      },
                    ),
                  if ((answer).isEmpty)
                    SingleFileAddItem(
                      isImage: widget.filetype == FileType.image,
                      onTap: () async {
                        if (widget.filetype == FileType.image) {
                          customBottom();
                        } else {
                          storeFiles(
                            fromCamera: false,
                          );
                        }
                      },
                    )
                ],
              );
  }
}

class SingleFileItem extends StatelessWidget {
  SingleFileItem(
      {super.key,
      required this.filePath,
      required this.ontap,
      required this.fileName,
      required this.imageBuild,
      this.fileClicked,
      required this.isImage});
  String filePath;
  bool isImage;
  Function ontap;
  final String fileName;
  final Widget? imageBuild;
  final Function? fileClicked;

  @override
  Widget build(BuildContext context) {
    return isImage
        ? Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: imageBuild)),
                Positioned(
                    top: 0,
                    right: 0,
                    child: ClipOval(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: Material(
                          color: Colors.red, // Button color
                          child: InkWell(
                            splashColor: Colors.red, // Splash color
                            onTap: () {
                              ontap();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    fileClicked!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      fileName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    ontap();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.close)),
                )
              ],
            ),
          );
  }
}

class InternalFile {
  String? path;
  String? id;
  InternalFile(this.path, this.id);
}

class SingleFileAddItem extends StatelessWidget {
  const SingleFileAddItem(
      {super.key, required this.onTap, required this.isImage});
  final Function onTap;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DottedDecoration(
        borderRadius: BorderRadius.circular(4),
        dash: const [3, 2],
        shape: Shape.box,
      ),
      height: 50,
      width: double.infinity,
      child: TextButton.icon(
          style: const ButtonStyle().copyWith(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            onTap();
          },
          icon: Icon(
            isImage ? Icons.add_photo_alternate_outlined : Icons.file_present,
            color: Colors.grey,
          ),
          label: Text(
            isImage ? 'Upload Image' : 'Upload File',
            style: Theme.of(context).textTheme.bodyMedium,
          )),
    );
  }
}
