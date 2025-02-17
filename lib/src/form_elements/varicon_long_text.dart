import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

import '../helpers/validators.dart';

class VariconLongText extends StatefulWidget {
  final TextInputField field;
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;
  final TextEditingController formCon;

  const VariconLongText({
    super.key,
    required this.field,
    this.fieldKey,
    required this.formCon,
  });

  @override
  State<VariconLongText> createState() => _VariconLongTextState();
}

class _VariconLongTextState extends State<VariconLongText> {
  bool empty = false;
  final HtmlEditorController htmlEditorController = HtmlEditorController();
  HtmlEditorOptions editorOptions = const HtmlEditorOptions();

  void saveLongText() {
    log(widget.formCon.text);
    // widget.formValue.saveString(
    //   widget.field.id,
    //   widget.formCon.text,
    // );
  }

  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r"<[^>]*>"), ' ');
  }


  @override
  void initState() {
    super.initState();
    editorOptions =  HtmlEditorOptions(
      adjustHeightForKeyboard: false,
      initialText: widget.field.answer ?? ''
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: HtmlEditor(
              callbacks: Callbacks(
                onFocus: () {
                  saveLongText();
                },
                onBlur: () {
                  saveLongText();
                },
                onChangeContent: (code) {
                  if (code.toString().isNotEmpty &&
                      empty == true &&
                      stripHtml(code.toString()).isNotEmpty) {
                    widget.formCon.text = code.toString().trim();
                    saveLongText();
                  } else {
                    widget.formCon.text = code.toString().trim();
                    widget.formCon.clear();
                    saveLongText();
                    setState(() {
                      empty = true;
                    });
                  }
                },
              ),
              controller: htmlEditorController, //required
              plugins: const [],
              htmlEditorOptions: editorOptions,
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    subscript: false,
                    superscript: false,
                  ),
                  ListButtons(listStyles: false),
                  ParagraphButtons(
                    caseConverter: false,
                    lineHeight: false,
                    textDirection: false,
                    increaseIndent: false,
                    decreaseIndent: false,
                  ),
                ],
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
                contentPadding: EdgeInsets.zero,
              ),
              controller: widget.formCon,
              key: widget.fieldKey,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                setState(() {
                  empty = true;
                });
                if (empty == true) {
                  if ((value ?? '').isNotEmpty) {
                    saveLongText();
                  }
                  return textValidator(
                    value: stripHtml((value ?? '').toString().trim()),
                    inputType: "text",
                    isRequired: (widget.field.isRequired),
                    requiredErrorText: 'Long text is required',
                  );
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
