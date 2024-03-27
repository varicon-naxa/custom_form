import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/radio_form_field.dart';

import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';
import '../../models/value_text.dart';

class YesNoNaInputWidget extends StatefulWidget {
  const YesNoNaInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.formKey,
    this.labelText,
  });

  final YesNoNaInputField field;
  final FormValue formValue;
  final Key formKey;
  final String? labelText;

  @override
  State<YesNoNaInputWidget> createState() => _YesNoNaInputWidgetState();
}

class _YesNoNaInputWidgetState extends State<YesNoNaInputWidget> {
  String? value;

  late final List<ValueText> choices;
  late final String otherFieldKey;
  bool showMessage = false;

  @override
  void initState() {
    super.initState();

    choices = [
      ...widget.field.choices,
      if (widget.field.showNoneItem)
        ValueText.none(text: widget.field.noneText ?? 'None'),
      if (widget.field.showOtherItem)
        ValueText.other(text: widget.field.otherText ?? 'Other (describe)'),
    ];
    otherFieldKey = '${widget.field.id}-Comment';
    value = (widget.field.answer != null)
        ? widget.field.answer ?? widget.formValue.getStringValue('')
        : widget.formValue.getStringValue('');

    if (widget.field.answer != null && widget.field.answer != '') {
      bool containsId = choices.any((obj) => obj.value == widget.field.answer);

      if (containsId) {
        ValueText? foundObject = choices.firstWhere(
          (obj) => obj.value == widget.field.answer,
        );
        setState(() {
          showMessage = foundObject.action ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioFormField<String>(
          value: value,
          context: context,
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => textValidator(
            value: value,
            inputType: "text",
            isRequired: widget.field.isRequired,
            requiredErrorText: widget.field.requiredErrorText,
          ),
          hasMessage: (value) {
            setState(() {
              showMessage = value;
            });
          },
          items: () {
            final items = choices.map((e) {
              return RadioMenuItem(
                  value: e.value,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  title: Text(e.text),
                  hasAction: e.action,
                  hasCondition: widget.field.isConditional);
            }).toList();
            return items;
          }(),
          onChanged: (value) {
            setState(() {
              this.value = value;
            });
          },
          onSaved: (newValue) {
            // remove text saved in other text field if dropdown value in not
            // other
            if (newValue != 'other') {
              widget.formValue.remove(otherFieldKey);
            }
            widget.formValue.saveString(
              widget.field.id,
              newValue,
            );
          },
        ),
        if (showMessage && (widget.field.actionMessage ?? '').isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                AppSpacing.sizedBoxW_08(),
                Expanded(
                  child: Text(
                    widget.field.actionMessage.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: IconButton(
        //     onPressed: () {
        //       setState(() {
        //         value = null;
        //       });
        //     },
        //     icon: const Icon(Icons.clear_all),
        //   ),
        // ),
        if (widget.field.showOtherItem && value == 'other') ...[
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            initialValue: widget.formValue.getStringValue(otherFieldKey),
            maxLength: 80,
            maxLines: 4,
            onSaved: (newValue) => widget.formValue.saveString(
              otherFieldKey,
              newValue,
            ),
            validator: (value) => textValidator(
              value: value,
              inputType: "text",
              isRequired: true,
              requiredErrorText: widget.field.otherErrorText,
            ),
            decoration: InputDecoration(
              hintText: widget.field.otherPlaceholder,
              labelText: widget.field.otherText,
            ),
          ),
        ],
      ],
    );
  }
}
