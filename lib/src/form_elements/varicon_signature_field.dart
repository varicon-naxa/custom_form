import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import 'package:varicon_form_builder/src/widget/scroll_bottomsheet.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/form_builder_signature_pad.dart';
import '../state/current_form_provider.dart';

class VariconSignatureField extends StatefulHookConsumerWidget {
  const VariconSignatureField({
    super.key,
    required this.field,
    required this.labelText,
    required this.imageBuild,
    required this.attachmentSave,
  });

  final SignatureInputField field;
  final String labelText;

  ///Function to build image values
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to save attachment
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  ConsumerState<VariconSignatureField> createState() =>
      _VariconSignatureFieldState();
}

class _VariconSignatureFieldState extends ConsumerState<VariconSignatureField> {
  Map<String, dynamic> _signature = {};
  SignatureController controller = SignatureController();

  @override
  void initState() {
    super.initState();
    _signature = (widget.field.answer ?? {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future modifyAnswer(Uint8List data) async {
      Map<String, dynamic> answer = {};

      File singleFile = await Utils.getConvertToFile(data);

      List<Map<String, dynamic>> attachments = await widget.attachmentSave(
        [singleFile.path],
      );
      answer.addAll({
        'id': attachments.first['id'],
        'attachmentId': attachments.first['id'],
        'file': attachments.first['file'],
        'created_at':
            (attachments.first['created_at'] ?? DateTime.now()).toString(),
      });

      controller.clear();
      ref
          .read(currentStateNotifierProvider.notifier)
          .saveMap(widget.field.id, answer);
    }

    deleteAnswer() {
      ref.read(currentStateNotifierProvider.notifier).remove(widget.field.id);
    }

    void signatureDialog() {
      scrollBottomSheet(
        context,
        height: 460,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Add Signature Details',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilderSignaturePad(
              controller: controller,
              hasAction: true,
              decoration: const InputDecoration(
                labelText: 'Signature Pad',
              ),
              width: double.infinity,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialWidget: null,
              name: const Uuid().v4(),
              onSavedClicked: (data) {
                _signature = {'value': data, 'date': DateTime.now()};
                modifyAnswer(data!);
                setState(() {});
                Navigator.pop(context);
              },
              onDeletedPressed: () {
                _signature = {};
                deleteAnswer();
              },
              onChanged: (value) {},
              validator: (data) {
                if (widget.field.isRequired) {
                  if ((widget.field.answer ?? {}).isNotEmpty) {
                    String? answer;
                    if (_signature.isEmpty && data == null) {
                      answer = 'This field is required';
                    } else if (_signature.isEmpty && data != null) {
                      answer = 'Please Save the Signature';
                    } else if (_signature.isNotEmpty && data == null) {
                      answer = null;
                    } else if (_signature.isNotEmpty && data != null) {
                      answer = null;
                    }
                    return answer;
                  } else {
                    if (data == null) {
                      return 'This field is required';
                    }
                  }
                  // if (data == null || _signature.isEmpty) {
                  //   return 'This field is required';
                  // }
                }
                return null;
              },
              border: Border.all(color: Colors.green),
            ),
          ),
        ),
      );
    }

    return _signature.isNotEmpty
        ? _signature['id'] == null
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                        height: 200, child: Image.memory(_signature['value'])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Signed On: ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(_signature['date'].toString()))}',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _signature = {};
                            deleteAnswer();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    widget.imageBuild({
                      'image': widget.field.answer?['file'],
                      'height': 100.0,
                      'width': 100.0
                    }),
                    Row(
                      mainAxisAlignment:
                          (widget.field.answer?['created_at'] == null)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        if (widget.field.answer?['created_at'] != null &&
                            widget.field.answer?['created_at'].isNotEmpty)
                          Expanded(
                            child: Text(
                              'Signed On: ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(widget.field.answer?['created_at']))}',
                            ),
                          ),
                        IconButton(
                          onPressed: () {
                            _signature = {};
                            deleteAnswer();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
        : GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_signature.isEmpty) {
                Future.microtask(
                  () {
                    controller = SignatureController();

                    signatureDialog();
                  },
                );
              }
            },
            child: FormBuilderSignaturePad(
              hasAction: false,
              controller: controller,
              decoration: const InputDecoration(
                  labelText: 'Signature Pad',
                  border: null,
                  errorBorder: null,
                  enabledBorder: null,
                  focusedBorder: null,
                  disabledBorder: null,
                  focusedErrorBorder: null),
              width: double.infinity,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialWidget: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                height: 200,
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
              name: 'signature',
              onSavedClicked: (data) {},
              onDeletedPressed: () {},
              onChanged: (value) {},
              validator: (data) {
                if (widget.field.isRequired) {
                  if ((widget.field.answer ?? {}).isEmpty) {
                    String? answer;
                    if (_signature.isEmpty && data == null) {
                      answer = 'This field is required';
                    } else if (_signature.isEmpty && data != null) {
                      answer = 'Please Save the Signature';
                    } else if (_signature.isNotEmpty && data == null) {
                      answer = null;
                    } else if (_signature.isNotEmpty && data != null) {
                      answer = null;
                    }
                    return answer;
                  }
                  // if (data == null || _signature.isEmpty) {
                  //   return 'This field is required';
                  // }
                }
                return null;
              },
            ),
          );
  }
}
