import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/radio_form_field.dart';

import '../../../varicon_form_builder.dart';
import '../../models/form_value.dart';
import '../../models/value_text.dart';

///Custom form radio form component
///
///Accepts field type with radio input
class RadioInputWidget extends StatefulWidget {
  const RadioInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.fieldKey,
    this.labelText,
  });

  ///Radio form field model
  final RadioInputField field;

  ///Radio form key
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  ///Form value to be used for radio input
  final FormValue formValue;

  ///Field label text
  final String? labelText;

  @override
  State<RadioInputWidget> createState() => _RadioInputWidgetState();
}

class _RadioInputWidgetState extends State<RadioInputWidget> {
  String? value;
  bool showMessage = false;

  ///Late initialization of choices and field key
  late final List<ValueText> choices;
  late final String otherFieldKey;
  TextEditingController otherFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ///initial values for choices
    choices = [
      ...widget.field.choices,
      if (widget.field.showNoneItem)
        ValueText.none(text: widget.field.noneText ?? 'None'),
      if (widget.field.showOtherItem)
        ValueText.other(text: widget.field.otherText ?? 'Other (describe)'),
    ];

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
      } else {
        otherFieldController.text = widget.field.answer ?? '';
        value = 'other';
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
          key: widget.fieldKey,
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
            List<ValueText> finalChoices = [...choices];
            finalChoices.removeWhere((element) => element.isOtherField == true);
            final items = finalChoices.map((e) {
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
            if (value == 'other') {
              widget.formValue.autosaveString(
                widget.field.id,
                otherFieldController.text,
              );
            } else {
              widget.formValue.autosaveString(
                widget.field.id,
                value,
              );
            }
          },
          onSaved: (newValue) {
            // remove text saved in other text field if dropdown value in not
            // other

            if (newValue == 'other') {
              widget.formValue.saveString(
                widget.field.id,
                otherFieldController.text,
              );
            } else {
              widget.formValue.saveString(
                widget.field.id,
                newValue,
              );
            }
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
            controller: otherFieldController,
            maxLength: 80,
            maxLines: 4,
            onSaved: (newValue) {},
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
