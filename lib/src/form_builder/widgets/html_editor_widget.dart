import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///HTML editor widget class
class HtmlEditorWidget extends StatefulWidget {
  final TextInputField field;
  final HtmlEditorController htmlEditorController;
  final HtmlEditorOptions editorOptions;
  final FormValue formValue;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  const HtmlEditorWidget({
    super.key,
    required this.field,
    required this.htmlEditorController,
    required this.editorOptions,
    required this.formValue,
    this.fieldKey,
  });

  @override
  State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
}

class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
  @override
  TextEditingController formCon = TextEditingController();
  String htmlValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            // height: 300,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: HtmlEditor(
              callbacks: Callbacks(onChangeContent: (code) {
                widget.formValue.saveString(
                  widget.field.id,
                  code.toString().trim(),
                );
                // setState(() => htmlValue = code.toString().trim());
              }),
              controller: widget.htmlEditorController, //required
              plugins: const [],
              htmlEditorOptions: widget.editorOptions,
              // textInputAction: TextInputAction.newline,
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  // StyleButtons(),
                  // FontSettingButtons(),
                  FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    subscript: false,
                    superscript: false,
                  ),
                  // ColorButtons(),
                  ListButtons(listStyles: false),
                  ParagraphButtons(
                    caseConverter: false,
                    lineHeight: false,
                    textDirection: false,
                    increaseIndent: false,
                    decreaseIndent: false,
                  ),
                  // InsertButtons(),
                  // OtherButtons(),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                enabled: false,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                // errorText: widget.emptyMsg,
              ),
              controller: formCon,
              key: widget.fieldKey,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value != "") {
                  return textValidator(
                    value: value,
                    inputType: "text",
                    isRequired: (widget.field.isRequired),
                    requiredErrorText: widget.field.requiredErrorText ??
                        'Long text is required',
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
