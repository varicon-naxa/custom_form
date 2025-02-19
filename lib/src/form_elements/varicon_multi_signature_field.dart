import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import 'package:varicon_form_builder/src/widget/action_button.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_multi_signature_pad.dart';
import '../widget/scroll_bottomsheet.dart';

class VariconMultiSignatureField extends StatefulHookConsumerWidget {
  const VariconMultiSignatureField({
    super.key,
    required this.field,
    required this.labelText,
    this.isNested = false,
    required this.imageBuild,
    required this.attachmentSave,
  });

  final MultiSignatureInputField field;
  final String labelText;
  final bool isNested;

  ///Image build function for signature view
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  ConsumerState<VariconMultiSignatureField> createState() =>
      _VariconMultiSignatureFieldState();
}

class _VariconMultiSignatureFieldState
    extends ConsumerState<VariconMultiSignatureField> {
  List<SingleSignature> signaturePads = [];

  @override
  void initState() {
    super.initState();
    if ((widget.field.answer ?? []).isNotEmpty) {
      signaturePads.addAll(widget.field.answer ?? []);
    }
  }

  void modifyanswer() {
    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          signaturePads.map((e) {
            return {
              'id': e.id,
              'signatoryName': e.signatoryName,
              'file': e.file,
              'date': e.date,
            };
          }).toList(),
        );
  }

  void addSignature(SingleSignature signature) {
    signaturePads.add(signature);
    setState(() {});
    modifyAnswer(signature);
  }

  Future<void> modifyAnswer(SingleSignature file) async {
    File singleFile = await Utils.getConvertToFile(file.uniImage);

    List<Map<String, dynamic>> attachments = await widget.attachmentSave(
      [singleFile.path],
    );

    int index = signaturePads.indexWhere(
      (element) => element.attachmentId == file.attachmentId,
    );

    if (index != -1) {
      signaturePads[index] = signaturePads[index].copyWith(
        file: attachments.first['file'],
        id: attachments.first['id'],
      );
    }
    setState(() {});
  }

  void signatureDialog() {
    final key = GlobalKey<FormBuilderFieldState>();

    scrollBottomSheet(context,
        height: 550,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Add Signature Details',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12,
              ),
              child: Row(
                spacing: 12.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ActionButton(
                      buttonText: 'Cancel',
                      buttonColor: Colors.white,
                      borderColor: Colors.black,
                      verticalPadding: 8.0,
                      onPressed: () {
                        if (key.currentState?.value != null) {
                        } else {}
                      },
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      buttonText: 'Save',
                      verticalPadding: 8.0,
                      onPressed: () {
                        if (_validateCurrentSignaturePad(key)) {
                          MultiSignature value = key.currentState!.value;
                          signaturePads.add(
                            SingleSignature(
                              attachmentId:
                                  '${value.name}-${const Uuid().v4()}',
                              signatoryName: value.name,
                              uniImage: value.image,
                              date: DateTime.now(),
                            ),
                          );
                          setState(() {});
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Please add both signature and signatory name');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FormBuilderMultiSignaturePad(
                key: key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                name: 'signature_${const Uuid().v4()}',
                onChanged: (value) {},
                validator: (data) {
                  if (widget.field.isRequired) {
                    if (data == null) {
                      return 'This field is required';
                    } else if (data.image == null && data.name == null) {
                      return 'This field is required';
                    } else {
                      if (data.image == null && (data.name ?? '').isNotEmpty) {
                        return 'Signature is required';
                      } else if ((data.name == null ||
                              (data.name ?? '').isEmpty) &&
                          (data.image != null)) {
                        return 'Signatory Name is required';
                      } else {
                        return null;
                      }
                    }
                  }
                  return null;
                },
                border: Border.all(color: Colors.green),
              ),
            ),
          ),
        ));
  }

  bool _validateCurrentSignaturePad(key) {
    final currentState = key.currentState?.value;
    if (currentState == null) {
      return false;
    } else {
      MultiSignature value = currentState;
      if (value.image == null || value.name == null || value.name!.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...signaturePads.map((e) {
          String dateFormat =
              e.date == null ? '' : DateFormat('dd MMM yyyy').format(e.date!);
          String dateText = dateFormat.isEmpty ? '' : ' on $dateFormat';
          String signatoryNameDetail = 'Signed By ${e.signatoryName} $dateText';
          return Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dismissible(
                  key: Key(e.attachmentId ?? e.id ?? ''),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      if (e.uniImage != null) {
                        signaturePads.removeWhere((element) =>
                            element.attachmentId == e.attachmentId);
                      } else {
                        signaturePads
                            .removeWhere((element) => element.id == e.id);
                      }
                    });
                    Fluttertoast.showToast(
                        msg: 'Signature by ${e.signatoryName} deleted');
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    width: double.infinity,
                    child: e.uniImage != null
                        ? Image.memory(
                            e.uniImage,
                          )
                        : widget.imageBuild({
                            'image': e.file,
                            'height': 100.0,
                          }),
                  ),
                ),
                Text(signatoryNameDetail,
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          );
        }),
        ActionButton(
          verticalPadding: 8,
          onPressed: () {
            signatureDialog();
          },
          buttonText: 'Add',
        ),
      ],
    );
  }
}
