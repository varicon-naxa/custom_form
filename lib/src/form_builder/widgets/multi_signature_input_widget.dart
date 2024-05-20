// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/core/debouncer.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/signature_consent_checkbox_widget.dart';
import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

///Multi signature input field
///
///Accepts field type with multiple signature input
///
///Can add multiple signature with name as required
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

  ///Multi signature input field model
  final MultiSignatureInputField field;

  ///Form value to be used for multi signature input
  final FormValue formValue;

  ///Field label text
  final String? labelText;

  ///Function to call on save multi signature
  void Function(Map<String, dynamic> result) onSaved;

  ///Image build function for signature view
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  State<MultiSignatureInputWidget> createState() =>
      _MultiSignatureInputWidgetState();
}

class _MultiSignatureInputWidgetState extends State<MultiSignatureInputWidget> {
  String? value;
  String? nameFieldValue;
  bool isLoading = false;
  final debouncer = Debouncer(milliseconds: 500);

  List<SingleSignature> answer = [];
  GlobalKey<SignatureState> signKey = GlobalKey<SignatureState>();

  late final String otherFieldKey;
  List<String> files = [];

  MapEntry<int, SingleSignature>? storeSingleItem;

  @override
  void initState() {
    super.initState();

    ///initializing form values
    setState(() {
      if ((widget.field.answer ?? []).isEmpty) {
        answer.add(SingleSignature(
          id: 'item-${const Uuid().v4()}',
        ));
      } else {
        answer.addAll(widget.field.answer ?? []);
      }
    });
  }

  ///Method to save list of signature
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

  ///Signature single component
  Widget singleComponent(MapEntry<int, SingleSignature> singleItem) {
    TextEditingController controller =
        TextEditingController(text: singleItem.value.name ?? '');

    return Container(
      key: Key(singleItem.value.id ?? ''),
      height: controller.text.isNotEmpty ? 290 : 200,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8.0,
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
                    ),
                  ),
                  child: const CircularProgressIndicator.adaptive(),
                )
              : (singleItem.value.file != null)
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
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
                      ],
                    )
                  : Container(
                      height: 174,
                      margin: EdgeInsets.only(
                        bottom: controller.text.isNotEmpty ? 10 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          onTap: () {
                            final focus = FocusNode();
                            FocusScope.of(context).requestFocus(focus);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                insetPadding: EdgeInsets.zero,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                content: StatefulBuilder(
                                    builder: (context, setStates) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Please sign below and submit',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
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
                                            ),
                                          ),
                                          AppSpacing.sizedBoxH_12(),
                                          TextFormField(
                                            controller: controller,
                                            onChanged: (data) {
                                              debouncer.run(() {
                                                answer[singleItem.key] =
                                                    answer[singleItem.key]
                                                        .copyWith(name: data);
                                                saveList();
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Signatory Name',
                                            ),
                                          ),
                                          AppSpacing.sizedBoxH_12(),
                                          const SignConsentCheckBoxWidget(),
                                          AppSpacing.sizedBoxH_12(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      final signHere =
                                                          signKey.currentState;
                                                      signHere?.clear();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          4,
                                                        ),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xffBDBDBD),
                                                        ),
                                                      ),
                                                      // width: 130,
                                                      child: Text(
                                                        'Cancel'.toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              AppSpacing.sizedBoxW_12(),
                                              Expanded(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final signs =
                                                          signKey.currentState;
                                                      if ((signs?.points ?? [])
                                                          .isEmpty) {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'Please sign to submit the signature',
                                                        );
                                                        return;
                                                      } else {
                                                        if (controller
                                                            .text.isEmpty) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Signature with name field is required',
                                                          );
                                                        } else {
                                                          setState(() {
                                                            isLoading = true;
                                                            answer[singleItem
                                                                .key] = answer[
                                                                    singleItem
                                                                        .key]
                                                                .copyWith(
                                                                    isLoading:
                                                                        true);
                                                          });
                                                          final sign = signKey
                                                              .currentState;
                                                          final image =
                                                              await sign
                                                                  ?.getData();
                                                          var data = await image
                                                              ?.toByteData(
                                                                  format: ui
                                                                      .ImageByteFormat
                                                                      .png);
                                                          Directory tempDir =
                                                              await getTemporaryDirectory();
                                                          String tempPath =
                                                              tempDir.path;
                                                          var filePath =
                                                              '$tempPath/image.png';
                                                          final buffer =
                                                              data!.buffer;
                                                          File savedImage = await File(
                                                                  filePath)
                                                              .writeAsBytes(buffer
                                                                  .asUint8List(
                                                                      data.offsetInBytes,
                                                                      data.lengthInBytes));
                                                          Navigator.pop(
                                                              context);
                                                          final savedFileData =
                                                              await widget
                                                                  .attachmentSave([
                                                            savedImage.path
                                                          ]);
                                                          widget.onSaved(
                                                              savedFileData[0]);
                                                          setState(() {
                                                            answer[singleItem.key] = answer[
                                                                    singleItem
                                                                        .key]
                                                                .copyWith(
                                                                    file: savedFileData[
                                                                            0][
                                                                        'file'],
                                                                    attachmentId:
                                                                        savedFileData[0]['id']
                                                                            .toString(),
                                                                    isLoading:
                                                                        false);
                                                            saveList();
                                                            isLoading = false;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 16.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          4,
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                      // width: 130,
                                                      child: Text(
                                                        'Submit'.toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
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
                    ),
          if (controller.text.isNotEmpty)
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.grey.shade300,
            //     ),
            //     borderRadius: const BorderRadius.all(
            //       Radius.circular(10),
            //     ),
            //   ),
            //   child: Text(controller.text),
            // ),
            TextFormField(
              controller: controller,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Signatory Name',
              ),
            ),
        ],
      ),
    );
  }

  ///Check if list is valid
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
                setState(() {
                  storeSingleItem = e;
                });
                return e.value.attachmentId == null
                    ? singleComponent(e)
                    : Dismissible(
                        direction: DismissDirection.endToStart,
                        key: Key(e.value.id ?? ''),
                        background: const SizedBox.shrink(),
                        secondaryBackground: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 20,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            answer.removeAt(e.key);
                          });
                          saveList();
                        },
                        child: singleComponent(e),
                      );
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
                        id: 'item-${const Uuid().v4()}',
                      ));
                    });
                  } else {
                    if (answer.any((signature) =>
                        signature.file == null || signature.file == '')) {
                      Fluttertoast.showToast(
                        msg: 'Empty Signature field',
                        backgroundColor: Colors.red,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Signature with name field is required',
                        backgroundColor: Colors.red,
                      );
                    }
                  }
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: Text(
                  'Add Signature',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                      ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// class SignaturePopUpWidget extends StatefulWidget {
//   SignaturePopUpWidget({
//     super.key,
//     this.controller,
//     required this.singleItem,
//     required this.saveList,
//     required this.attachmentSave,
//     required this.onSaved,
//     required this.signKey,
//     required this.answer,
//     this.secondSignature = false,
//     this.onSubmit,
//     this.onTextfieldChange,
//   });

//   final TextEditingController? controller;
//   final MapEntry<int, SingleSignature> singleItem;
//   final Function saveList;
//   final GlobalKey<SignatureState> signKey;
//   final List<SingleSignature> answer;
//   final bool secondSignature;
//   final Function? onSubmit;
//   final Function? onTextfieldChange;

//   ///Function to save attachment
//   final Future<List<Map<String, dynamic>>> Function(List<String>)
//       attachmentSave;

//   ///Function to call on save multi signature
//   void Function(Map<String, dynamic> result) onSaved;

//   @override
//   State<SignaturePopUpWidget> createState() => _SignaturePopUpWidgetState();
// }

// class _SignaturePopUpWidgetState extends State<SignaturePopUpWidget> {
//   String? value;
//   String? nameFieldValue;
//   bool isLoading = false;

//   final debouncer = Debouncer(milliseconds: 500);

//   TextEditingController internalController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         final focus = FocusNode();
//         FocusScope.of(context).requestFocus(focus);
//         showDialog(
//           context: context,
//           builder: (BuildContext context) => AlertDialog(
//             contentPadding: EdgeInsets.zero,
//             insetPadding: EdgeInsets.zero,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             content: StatefulBuilder(builder: (context, setStates) {
//               return SingleChildScrollView(
//                 child: Container(
//                   color: Colors.white,
//                   width: MediaQuery.of(context).size.width - 55,
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Please sign below and submit',
//                         style: Theme.of(context).textTheme.titleSmall,
//                       ),
//                       AppSpacing.sizedBoxH_12(),
//                       Container(
//                         height: 350,
//                         color: Colors.black12,
//                         child: Signature(
//                           color: Colors.black,
//                           key: widget.signKey,
//                           onSign: () {},
//                           strokeWidth: 4.0,
//                         ),
//                       ),
//                       AppSpacing.sizedBoxH_12(),
//                       TextFormField(
//                         controller: widget.controller ?? internalController,
//                         onChanged: (data) {
//                           widget.onTextfieldChange!;
//                         },
//                         decoration: const InputDecoration(
//                           labelText: 'Signatory Name',
//                         ),
//                       ),
//                       AppSpacing.sizedBoxH_10(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 final signHere = widget.signKey.currentState;
//                                 signHere?.clear();
//                                 Navigator.pop(context);
//                               },
//                               behavior: HitTestBehavior.translucent,
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16.0),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                     4,
//                                   ),
//                                   border: Border.all(
//                                     color: const Color(0xffBDBDBD),
//                                   ),
//                                 ),
//                                 // width: 130,
//                                 child: Text(
//                                   'Cancel'.toUpperCase(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge
//                                       ?.copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         height: 1,
//                                       ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           AppSpacing.sizedBoxW_12(),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () async {
//                                 // onSubmit();
//                                 // widget.onSubmit!() ?? () {};
//                                 final signs = widget.signKey.currentState;
//                                 if ((signs?.points ?? []).isEmpty) {
//                                   Fluttertoast.showToast(
//                                     msg: 'Please sign to submit the signature',
//                                   );
//                                   return;
//                                 } else {
//                                   if (widget.controller!.text.isEmpty) {
//                                     Fluttertoast.showToast(
//                                       msg:
//                                           'Signature with name field is required',
//                                     );
//                                   } else {
//                                     setState(() {
//                                       isLoading = true;
//                                       widget.answer[widget.singleItem.key] =
//                                           widget.answer[widget.singleItem.key]
//                                               .copyWith(isLoading: true);
//                                     });
//                                     final sign = widget.signKey.currentState;
//                                     final image = await sign?.getData();
//                                     var data = await image?.toByteData(
//                                         format: ui.ImageByteFormat.png);
//                                     Directory tempDir =
//                                         await getTemporaryDirectory();
//                                     String tempPath = tempDir.path;
//                                     var filePath = '$tempPath/image.png';
//                                     final buffer = data!.buffer;

//                                     File savedImage = await File(filePath)
//                                         .writeAsBytes(buffer.asUint8List(
//                                             data.offsetInBytes,
//                                             data.lengthInBytes));
//                                     Navigator.pop(context);

//                                     final savedFileData = await widget
//                                         .attachmentSave([savedImage.path]);
//                                     widget.onSaved(savedFileData[0]);
//                                     setState(() {
//                                       widget.answer[widget.singleItem.key] =
//                                           widget.answer[widget.singleItem.key]
//                                               .copyWith(
//                                                   file: savedFileData[0]
//                                                       ['file'],
//                                                   attachmentId: savedFileData[0]
//                                                           ['id']
//                                                       .toString(),
//                                                   isLoading: false);
//                                       widget.saveList();

//                                       isLoading = false;
//                                     });
//                                   }
//                                 }
//                               },
//                               behavior: HitTestBehavior.translucent,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16.0,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange,
//                                   borderRadius: BorderRadius.circular(
//                                     4,
//                                   ),
//                                   border: Border.all(
//                                     color: Colors.orange,
//                                   ),
//                                 ),
//                                 // width: 130,
//                                 child: Text(
//                                   'Submit'.toUpperCase(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelLarge
//                                       ?.copyWith(
//                                         fontWeight: FontWeight.w600,
//                                         height: 1,
//                                       ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         );
//       },
//       child: Container(
//         height: 200,
//         margin: const EdgeInsets.only(
//           bottom: 10,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(
//             8,
//           ),
//         ),
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 50,
//               width: 50,
//               child: Image.asset(
//                 'assets/image/signature.png',
//                 package: 'varicon_form_builder',
//               ),
//             ),
//             Text(
//               'Click here to add signature',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }