// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
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
  });

  ///Signature input model
  final SignatureInputField field;

  ///Form value to be used for signature
  final FormValue formValue;

  ///Field label text
  final String? labelText;

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
    });
  }

  ///Dialog to open signature pad
  ///
  ///Checks for signature and save the image
  ///
  ///Returns image data to save
  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: StatefulBuilder(builder: (context, setStates) {
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
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppSpacing.sizedBoxH_12(),
                Container(
                    height: 350,
                    color: Colors.black12,
                    child: Signature(
                      color: Colors.black,
                      key: sign,
                      onSign: () {},
                      strokeWidth: 4.0,
                    )),
                AppSpacing.sizedBoxH_12(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final signHere = sign.currentState;
                        signHere?.clear();
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.translucent,
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
                    AppSpacing.sizedBoxW_08(),
                    GestureDetector(
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
                        }
                      },
                      behavior: HitTestBehavior.translucent,
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
                          'SIGN'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
    ).then((data) async {
      if (data != null && data is ByteData) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        var filePath = '$tempPath/image.png';
        final buffer = data.buffer;

        File savedImage = await File(filePath).writeAsBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        final savedFileData = await widget.attachmentSave([savedImage.path]);
        widget.onSaved(savedFileData[0]);
        setState(() {
          answer = savedFileData[0];
          imaeURL = savedFileData[0]['file'];
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
                    height: 200,
                    width: double.infinity,
                    child: DottedBorder(
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: answer.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  openDialog();
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
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
                                        widget.onSaved({});
                                        setState(() {
                                          answer = {};
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
