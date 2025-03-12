import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

class VariconLongText extends FormField<String> {
  final TextInputField field;
  final ValueChanged<String>? onChanged;

  VariconLongText({
    super.key,
    required this.field,
    String? initialValue,
    super.validator,
    super.onSaved,
    this.onChanged,
  }) : super(
          initialValue: initialValue ?? field.answer ?? '',
          builder: (FormFieldState<String> state) {
            return _VariconLongTextContent(
              field: field,
              state: state,
              onChanged: onChanged,
            );
          },
        );
}

class _VariconLongTextContent extends StatefulWidget {
  final TextInputField field;
  final FormFieldState<String> state;
  final ValueChanged<String>? onChanged; // Add this line

  const _VariconLongTextContent(
      {required this.field, required this.state, this.onChanged});

  @override
  State<_VariconLongTextContent> createState() =>
      _VariconLongTextContentState();
}

class _VariconLongTextContentState extends State<_VariconLongTextContent> {
  bool empty = false;
  final HtmlEditorController htmlEditorController = HtmlEditorController();
  late HtmlEditorOptions editorOptions;

  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r"<[^>]*>"), ' ');
  }

  @override
  void initState() {
    super.initState();
    editorOptions = HtmlEditorOptions(
      adjustHeightForKeyboard: false,
      initialText: widget.state.value ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    widget.state.hasError ? Colors.red : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: HtmlEditor(
              callbacks: Callbacks(
                onChangeContent: (code) {
                  final strippedCode = stripHtml(code.toString()).trim();
                  widget.state.didChange(code.toString().trim());
                  widget.onChanged?.call(code.toString().trim());

                  if (strippedCode.isEmpty) {
                    setState(() {
                      empty = true;
                    });
                  }
                },
              ),
              controller: htmlEditorController,
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
        if (widget.state.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.state.errorText ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
