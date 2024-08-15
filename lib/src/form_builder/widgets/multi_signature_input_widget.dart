// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
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
    this.fieldKey,
  });

  ///Multi signature input field model
  final MultiSignatureInputField field;

  ///Form value to be used for multi signature input
  final FormValue formValue;

  ///Field label text
  final String? labelText;

  ///Function to call on save multi signature
  void Function(Map<String, dynamic> result) onSaved;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

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
  List<SingleSignature> answer = [];
  GlobalKey<SignatureState> signKey = GlobalKey<SignatureState>();
  bool validate = false;
  bool isLoading = false;
  TextEditingController formCon = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    ///initializing form values
    setState(() {
      if ((widget.field.answer ?? []).isNotEmpty) {
        answer.addAll(widget.field.answer ?? []);
        formCon.text = answer.first.name ?? '';
      }
    });
  }

  ///Dialog to remove signature
  ///
  ///Checks for signature and remove the image
  removeConfirmDialog(SingleSignature e) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Signature'),
        content: const Text('Are you sure you want to remove the signature?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                answer.removeWhere((element) => element.id == e.id);
              });
              saveList();
              Navigator.of(context).pop(true);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  ///Signature single component
  ///
  ///Single signature component with image and name
  Widget singleComponent(SingleSignature singleItem) {
    return Container(
      height: 335,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.only(
        top: 18,
      ),
      decoration: DottedDecoration(
        borderRadius: BorderRadius.circular(4),
        dash: const [3, 2],
        shape: Shape.box,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Stack(
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
                  'image': singleItem.file,
                  'height': 200.0,
                  'width': 200.0
                }),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
            ),
            width: double.infinity,
            child: Text(
              singleItem.signatoryName ?? singleItem.name ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 3,
            ),
            constraints: const BoxConstraints(),
            onPressed: () {
              removeConfirmDialog(singleItem);
            },
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  'Remove Signatory',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Signature dialog
  ///
  ///Dialog to add signature with name and consent
  void signatureDialog() {
    SingleSignature singleSignature = SingleSignature(
      id: 'item-${const Uuid().v4()}',
    );
    TextEditingController controller = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: StatefulBuilder(builder: (context, setStates) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please sign below and submit',
                    style: Theme.of(context).textTheme.titleMedium,
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
                  AppSpacing.sizedBoxH_04(),
                  ClearSignatureWidget(
                    onClear: () {
                      final signHere = signKey.currentState;
                      signHere?.clear();
                      formCon.text = '';
                    },
                  ),
                  AppSpacing.sizedBoxH_12(),
                  const SignConsentWidget(),
                  AppSpacing.sizedBoxH_12(),
                  TextFormField(
                    controller: controller,
                    onChanged: (data) {},
                    decoration: InputDecoration(
                      labelText: 'Signatory Name',
                      errorText: validate ? "Name cannot be empty" : null,
                    ),
                  ),
                  AppSpacing.sizedBoxH_12(),
                  // const SignConsentWidget(),
                  AppSpacing.sizedBoxH_12(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              final signHere = signKey.currentState;
                              signHere?.clear();
                              controller.clear();
                              validate = false;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ),
                                border: Border.all(
                                  color: const Color(0xffBDBDBD),
                                ),
                              ),
                              // width: 130,
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
                        ),
                      ),
                      AppSpacing.sizedBoxW_12(),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final signs = signKey.currentState;
                              validate = controller.text.isEmpty;
                              setStates(() {});
                              if ((signs?.points ?? []).isEmpty) {
                                Fluttertoast.showToast(
                                  msg: 'Please sign to submit the signature',
                                );
                                return;
                              } else {
                                if (controller.text.toString().trim().isEmpty) {
                                  setState(() {
                                    validate = true;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final sign = signKey.currentState;
                                  final image = await sign?.getData();
                                  var data = await image?.toByteData(
                                      format: ui.ImageByteFormat.png);
                                  Directory tempDir =
                                      await getTemporaryDirectory();
                                  String tempPath = tempDir.path;
                                  var filePath = '$tempPath/image.png';
                                  final buffer = data!.buffer;
                                  File savedImage = await File(filePath)
                                      .writeAsBytes(buffer.asUint8List(
                                          data.offsetInBytes,
                                          data.lengthInBytes));
                                  Navigator.pop(context);
                                  final savedFileData = await widget
                                      .attachmentSave([savedImage.path]);
                                  widget.onSaved(savedFileData[0]);
                                  setState(() {
                                    singleSignature = singleSignature.copyWith(
                                      file: savedFileData[0]['file'],
                                      attachmentId:
                                          savedFileData[0]['id'].toString(),
                                      name: controller.text,
                                      isLoading: false,
                                    );
                                    answer.add(singleSignature);
                                    saveList();
                                    isLoading = false;
                                    validate = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(
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
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                    ),
                                textAlign: TextAlign.center,
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
            ...answer.map(
              (e) {
                return singleComponent(e);
              },
            ).toList(),
          AppSpacing.sizedBoxH_06(),
          if (isLoading)
            Container(
              alignment: Alignment.center,
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              padding: const EdgeInsets.only(
                top: 18,
              ),
              decoration: DottedDecoration(
                borderRadius: BorderRadius.circular(4),
                dash: const [3, 2],
                shape: Shape.box,
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: DottedDecoration(
                  borderRadius: BorderRadius.circular(4),
                  dash: const [3, 2],
                  shape: Shape.box,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => signatureDialog(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Add Signature',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: SizedBox(
                  height: 20,
                  child: TextFormField(
                    controller: formCon,
                    key: widget.fieldKey,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      enabled: false,
                      labelStyle: TextStyle(color: Colors.white),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 100,
                      ),
                    ),
                    validator: (value) {
                      if (answer.isEmpty && value != null) {
                        return textValidator(
                          value: '',
                          inputType: "text",
                          isRequired: (widget.field.isRequired),
                          requiredErrorText: widget.field.requiredErrorText ??
                              'Signature is required',
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///Widget to clear signature
///
///buttom with icon and text
class ClearSignatureWidget extends StatelessWidget {
  const ClearSignatureWidget({
    super.key,
    required this.onClear,
  });

  final Function onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        constraints: const BoxConstraints(),
        onPressed: () => onClear(),
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              'CLEAR',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
