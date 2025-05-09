import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/helpers/utils.dart';
import 'package:varicon_form_builder/src/helpers/validators.dart';
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
    required this.imageBuild,
    required this.attachmentSave,
  });

  final MultiSignatureInputField field;
  final String labelText;

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
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if ((widget.field.answer ?? []).isNotEmpty) {
      signaturePads.addAll(widget.field.answer ?? []);
      _editingController.text =
          (signaturePads.isNotEmpty) ? signaturePads.length.toString() : '';
    }
  }

  void modifyAnswerinList() {
    List<SingleSignature> answer = [];
    for (var element in signaturePads) {
      answer.add(
        SingleSignature(
          id: element.id,
          signatoryName: element.signatoryName,
          file: element.file,
          createdAt: element.createdAt ?? DateTime.now().toUtc().toString(),
          attachmentId: element.id,
        ),
      );
    }
    ref.read(currentStateNotifierProvider.notifier).saveList(
          widget.field.id,
          answer,
        );
  }

  Future<void> addSignature(SingleSignature signature) async {
    signaturePads.add(signature);
    _editingController.text =
        (signaturePads.isNotEmpty) ? signaturePads.length.toString() : '';
    setState(() {});
    await modifyAnswer(signature);
  }

  Future<void> modifyAnswer(SingleSignature file) async {
    try {
      File singleFile = await Utils.getConvertToFile(file.uniImage);

      List<Map<String, dynamic>> attachments = await widget.attachmentSave(
        [singleFile.path],
      );
      if (attachments.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Error saving signature',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
        );
        signaturePads.removeLast();
        setState(() {});
        return;
      }

      int index = signaturePads.indexWhere(
        (element) => element.attachmentId == file.attachmentId,
      );

      if (index != -1) {
        signaturePads[index] = signaturePads[index].copyWith(
          file: attachments.first['file'],
          id: attachments.first['id'],
          createdAt: (attachments.first['created_at']),
          attachmentId: attachments.first['id'],
        );
      }
      modifyAnswerinList();
      setState(() {});
    } catch (e) {
      signaturePads.removeLast();
      setState(() {});
    } finally {}
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
                        Navigator.pop(context);
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
                          if (value.image != null &&
                              (value.name ?? '').trim().isNotEmpty) {
                            SingleSignature singleSignature = SingleSignature(
                              attachmentId:
                                  '${value.name}-${const Uuid().v4()}',
                              signatoryName: value.name,
                              uniImage: value.image,
                              createdAt: DateTime.now().toString(),
                            );
                            addSignature(singleSignature);
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'Please add both signature and signatory name');
                          }
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
                      if (data.image == null &&
                          (data.name ?? '').trim().isNotEmpty) {
                        return 'Signature is required';
                      } else if ((data.name == null ||
                              (data.name ?? '').trim().isEmpty) &&
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...signaturePads.map((e) {
          String dateFormat =
              (e.createdAt == null || e.createdAt.toString() == "null")
                  ? ''
                  : Utils.convertToLocalTime(e.createdAt!);
          String dateText = dateFormat.isEmpty ? '' : ' on $dateFormat';
          String signatoryName =
              (e.signatoryName == null) ? '' : 'By ${e.signatoryName}';
          String signatoryNameDetail = 'Signed $signatoryName $dateText';
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

                    modifyAnswerinList();
                    _editingController.text = (signaturePads.isNotEmpty)
                        ? signaturePads.length.toString()
                        : '';
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
                        : CachedNetworkImage(
                            imageUrl: e.file ?? '',
                            height: 100.0,
                            placeholderFadeInDuration:
                                const Duration(seconds: 1),
                            placeholder: (context, url) =>
                                const Icon(Icons.image),
                          ),
                  ),
                ),
                Text(signatoryNameDetail,
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          );
        }),
        SizedBox(
          height: 20,
          child: TextFormField(
            controller: _editingController,
            readOnly: true,
            enabled: false,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.transparent, fontSize: 5),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: null,
            minLines: null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            validator: (value) {
              return textValidator(
                value: value,
                inputType: "text",
                isRequired: widget.field.isRequired,
                requiredErrorText: null,
              );
            },
            onChanged: (value) {},
          ),
        ),
        const SizedBox(height: 8),
        ActionButton(
          verticalPadding: 12,
          buttonColor: Colors.white,
          borderColor: Colors.grey.shade400,
          onPressed: () {
            signatureDialog();
          },
          buttonText: 'Add Signature',
        ),
      ],
    );
  }
}
