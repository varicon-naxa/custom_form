// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'dart:ui' as ui;
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_bottomsheet.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/multi_signature_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/scrollable_bottom_bar.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/signature_consent_checkbox_widget.dart';
import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

///Form signature input widget
///
///Accepts field type with form value to display
///
///Open dialog with signature pad to sign and submit
class SignatureInputWidget extends StatefulWidget {
  SignatureInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.onSaved,
    required this.attachmentSave,
    required this.imageBuild,
    this.labelText,
    required this.fieldKey,
  });

  ///Signature input model
  final SignatureInputField field;

  ///Form value to be used for signature
  final FormValue formValue;

  ///Field label text
  final String? labelText;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  ///Image build function for sign display
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///On save function for signature
  void Function(Map<String, dynamic>) onSaved;

  ///List of attachment save function for signature
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  @override
  State<SignatureInputWidget> createState() => _SignatureInputWidgetState();
}

class _SignatureInputWidgetState extends State<SignatureInputWidget> {
  ///Initializing variables for form values
  String? value;
  Map<String, dynamic> answer = {};
  bool isLoading = false;
  String imaeURL = '';
  TextEditingController formCon = TextEditingController();

  ///Late initilize global key for signature/field
  late final GlobalKey<SignatureState> sign;
  late final String otherFieldKey;

  @override
  void initState() {
    super.initState();
    sign = GlobalKey<SignatureState>();
    setState(() {
      answer = widget.field.answer ?? {};
      imaeURL = answer['file'] ?? '';
      formCon.text = answer['file'] ?? '';
    });
  }

  ///Dialog to remove signature
  ///
  ///Checks for signature and remove the image
  void removeConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Signature'),
        content: const Text('Are you sure you want to remove the signature?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onSaved({});
              setState(() {
                answer = {};
              });
              formCon.text = '';
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  ///Dialog to open signature pad
  ///
  ///Checks for signature and save the image
  ///
  ///Returns image data to save
  void openDialog() {
    primaryBottomSheet(
      context,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: Text(
            'Your Signature here',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        bottomNavigationBar: ScrollableBottomBar(
          kBottomNavigationBarCustomHeight: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final signHere = sign.currentState;
                        signHere?.clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                          border: Border.all(
                            color: const Color(0xffBDBDBD),
                          ),
                        ),
                        width: 130,
                        child: Text(
                          'Cancel'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
                        final signs = sign.currentState;
                        if ((signs?.points ?? []).isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please sign to submit the signature');
                          return;
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          final signKey = sign.currentState;
                          final image = await signKey?.getData();
                          var data = await image?.toByteData(
                              format: ui.ImageByteFormat.png);
                          Navigator.pop(context, data);

                          if (data != null) {
                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;
                            var filePath = '$tempPath/image.png';
                            final buffer = data.buffer;

                            File savedImage = await File(filePath).writeAsBytes(
                                buffer.asUint8List(
                                    data.offsetInBytes, data.lengthInBytes));
                            final savedFileData =
                                await widget.attachmentSave([savedImage.path]);
                            widget.onSaved(savedFileData[0]);
                            setState(() {
                              answer = savedFileData[0];
                              imaeURL = savedFileData[0]['file'];
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                          border: Border.all(
                            color: Colors.orange,
                          ),
                        ),
                        width: 130,
                        child: Text(
                          'Sign'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 350,
                    color: Colors.black12,
                    child: Signature(
                      color: Colors.black,
                      key: sign,
                      onSign: () {},
                      strokeWidth: 4.0,
                    )),
                AppSpacing.sizedBoxH_04(),
                ClearSignatureWidget(
                  onClear: () {
                    final signHere = sign.currentState;
                    signHere?.clear();
                  },
                ),
                AppSpacing.sizedBoxH_12(),
                const SignConsentWidget(),
                AppSpacing.sizedBoxH_12(),
              ],
            ),
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLoading
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
            : SizedBox(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(
                //     8.0,
                //   ),
                //   border: Border.all(
                //     color: Colors.grey.shade300,
                //     width: 2.0,
                //   ),
                // ),

                height: 170,
                width: double.infinity,
                child: answer.isEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: DottedDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  dash: const [3, 2],
                                  shape: Shape.box,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      openDialog();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Visibility(
                              visible: true,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  enabled: false,
                                  labelStyle: TextStyle(color: Colors.white),
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 105,
                                  ),
                                ),
                                controller: formCon,
                                key: widget.fieldKey,
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if ((answer).isEmpty) {
                                    return textValidator(
                                      value: value,
                                      inputType: "text",
                                      isRequired: (widget.field.isRequired),
                                      requiredErrorText:
                                          widget.field.requiredErrorText ??
                                              'Signature is required',
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            child: widget.imageBuild({
                              'image': imaeURL,
                              'height': 200.0,
                              'width': 200.0
                            }),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                removeConfirmDialog();
                                // widget.onSaved({});
                                // setState(() {
                                //   answer = {};
                                // });
                              },
                            ),
                          )
                        ],
                      ),
              ),
      ],
    );
  }
}
