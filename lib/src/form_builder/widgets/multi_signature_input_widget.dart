// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:varicon_form_builder/src/core/debouncer.dart';
import 'package:varicon_form_builder/src/models/single_signature.dart';
import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

class MultiSignatureInputWidget extends StatefulWidget {
  MultiSignatureInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.onSaved,
    required this.attachmentSave,
    required this.imageBuild,
    this.labelText,
  });

  final MultiSignatureInputField field;
  final FormValue formValue;
  final String? labelText;
  void Function(Map<String, dynamic> result) onSaved;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  State<MultiSignatureInputWidget> createState() =>
      _MultiSignatureInputWidgetState();
}

class _MultiSignatureInputWidgetState extends State<MultiSignatureInputWidget> {
  String? value;
  bool isLoading = false;
  final debouncer = Debouncer(milliseconds: 500);

  List<SingleSignature> answer = [];
  GlobalKey<SignatureState> signKey = GlobalKey<SignatureState>();

  late final String otherFieldKey;
  List<String> files = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      answer.addAll(widget.field.answer ?? []);
    });
  }

  saveList() {
    List<SingleSignature> filteredList = answer
        .where((signature) =>
            signature.attachmentId != null &&
            signature.file != null &&
            signature.name != null)
        .toList();
    widget.formValue.saveList(
      widget.field.id,
      filteredList.map((e) => e.toJson()).toList(),
    );
  }

  Widget singleComponent(MapEntry<int, SingleSignature> singleItem) {
    TextEditingController controller =
        TextEditingController(text: singleItem.value.name ?? '');

    return Container(
      key: Key(singleItem.value.id ?? ''),
      height: 300,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(
        8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          (singleItem.value.isLoading ?? false)
              ? Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                    12.0,
                  )),
                  child: const CircularProgressIndicator.adaptive())
              : (singleItem.value.file != null)
                  ? Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                            12.0,
                          )),
                          child: widget.imageBuild({
                            'image': singleItem.value.file,
                            'height': 200.0,
                            'width': 200.0
                          }),
                        ),
                        Positioned(
                          top: -15,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                answer[singleItem.key] =
                                    answer[singleItem.key].copyWith(
                                  file: null,
                                  attachmentId: null,
                                );

                                isLoading = false;
                              });
                            },
                          ),
                        )
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            insetPadding: EdgeInsets.zero,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            content:
                                StatefulBuilder(builder: (context, setStates) {
                              return Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width - 100,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Please sign below and submit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    AppSpacing.sizedBoxH_12(),
                                    Container(
                                        height: 350,
                                        color: Colors.black12,
                                        child: Signature(
                                          color: Colors.black,
                                          key: signKey,
                                          onSign: () {},
                                          strokeWidth: 4.0,
                                        )),
                                    AppSpacing.sizedBoxH_12(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            final signHere =
                                                signKey.currentState;
                                            signHere?.clear();
                                            Navigator.pop(context);
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4,
                                              ),
                                              border: Border.all(
                                                color: const Color(0xffBDBDBD),
                                              ),
                                            ),
                                            width: 130,
                                            child: Text(
                                              'Cancel'.toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        AppSpacing.sizedBoxW_08(),
                                        GestureDetector(
                                          onTap: () async {
                                            final signs = signKey.currentState;
                                            if ((signs?.points ?? []).isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please sign to submit the signature');
                                              return;
                                            } else {
                                              setState(() {
                                                isLoading = true;
                                                answer[singleItem.key] =
                                                    answer[singleItem.key]
                                                        .copyWith(
                                                            isLoading: true);
                                              });
                                              final sign = signKey.currentState;
                                              final image =
                                                  await sign?.getData();
                                              var data =
                                                  await image?.toByteData(
                                                      format: ui
                                                          .ImageByteFormat.png);
                                              Directory tempDir =
                                                  await getTemporaryDirectory();
                                              String tempPath = tempDir.path;
                                              var filePath =
                                                  '$tempPath/image.png';
                                              final buffer = data!.buffer;

                                              File savedImage = await File(
                                                      filePath)
                                                  .writeAsBytes(
                                                      buffer.asUint8List(
                                                          data.offsetInBytes,
                                                          data.lengthInBytes));
                                              Navigator.pop(context);

                                              final savedFileData = await widget
                                                  .attachmentSave(
                                                      [savedImage.path]);
                                              widget.onSaved(savedFileData[0]);
                                              setState(() {
                                                answer[singleItem.key] =
                                                    answer[singleItem.key]
                                                        .copyWith(
                                                            file:
                                                                savedFileData[0]
                                                                    ['file'],
                                                            attachmentId:
                                                                savedFileData[0]
                                                                        ['id']
                                                                    .toString(),
                                                            isLoading: false);
                                                saveList();

                                                isLoading = false;
                                              });
                                            }
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4,
                                              ),
                                              border: Border.all(
                                                color: Colors.orange,
                                              ),
                                            ),
                                            width: 130,
                                            child: Text(
                                              'SIGN'.toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'assets/image/signature.png',
                                package: 'varicon_form_builder',
                              ),
                            ),
                            Text(
                              'Click here to add signature',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
          TextFormField(
            controller: controller,
            onChanged: (data) {
              debouncer.run(() {
                setState(() {
                  answer[singleItem.key] =
                      answer[singleItem.key].copyWith(name: data);
                });
                saveList();
              });
            },
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ],
      ),
    );
  }

  bool isListValid() {
    return !answer.any((signature) =>
        signature.file == null ||
        signature.file == '' ||
        signature.name == null ||
        signature.name == '' ||
        signature.attachmentId == null ||
        signature.attachmentId == '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (answer.isNotEmpty)
            ...answer.asMap().entries.map(
              (e) {
                return singleComponent(e);
              },
            ).toList(),
          AppSpacing.sizedBoxH_06(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Check if there is any object with null values for id, attachmentId, file, and name

                  if (isListValid()) {
                    setState(() {
                      answer.add(SingleSignature(
                          id: DateTime.now()
                              .microsecondsSinceEpoch
                              .toString()));
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Empty Signature field',
                      backgroundColor: Colors.red,
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(
                  'Add Signature',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _TextContainer extends StatelessWidget {
  final String label;
  final String hintText;

  const _TextContainer({required this.label, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label.isEmpty ? 'Select User' : label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: label.isEmpty ? Colors.grey : Colors.black,
                  ),
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
          )
        ],
      ),
    );
  }
}
