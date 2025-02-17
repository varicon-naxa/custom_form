import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/src/widget/normal_bottomsheet.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_dropdown.dart';
import '../custom_element/custom_form_builder_query_dropdown.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';
import '../state/link_label_provider.dart';
import '../widget/scroll_bottomsheet.dart';

class VariconDropdownField extends StatefulHookConsumerWidget {
  const VariconDropdownField(
      {super.key,
      required this.field,
      required this.labelText,
      this.isNested = false,
      this.apiCall});

  final DropdownInputField field;
  final String labelText;
  final bool isNested;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  ConsumerState<VariconDropdownField> createState() =>
      _VariconDropdownFieldState();
}

class _VariconDropdownFieldState extends ConsumerState<VariconDropdownField> {
  TextEditingController dropdownController = TextEditingController();
  ValueText? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.field.fromManualList) {
      if (widget.field.answer != null && widget.field.answer != '') {
        widget.field.choices.firstWhere((element) {
          if (element.value == widget.field.answer) {
            dropdownController.text = element.text;
            setState(() {
              selectedValue = element;
            });
            return true;
          }
          return false;
        });
      }
    } else if (widget.field.fromManualList == false &&
        widget.field.answer != null &&
        widget.field.answer != '') {
      String selectedAnswer = widget.field.answerList ?? '';
      dropdownController.text = selectedAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FormBuilderTextField(
          controller: dropdownController,
          validator: (values) => textValidator(
            value: values == 'Select the item from list' ? '' : values,
            inputType: "text",
            isRequired: (widget.field.isRequired),
            requiredErrorText:
                widget.field.requiredErrorText ?? 'Required field  ',
          ),
          onTap: () {
            if (widget.field.fromManualList) {
              normalBottomsheet(
                context,
                child: CustomFormBuilderDropdown(
                  choices: widget.field.choices,
                  actionMessage: widget.field.actionMessage,
                  onChanged: (data) {
                    setState(() {
                      selectedValue = data;
                    });
                    dropdownController.text = data!.text;
                    ref
                        .read(currentStateNotifierProvider.notifier)
                        .saveString(widget.field.id, data.value);
                    ref
                        .read(linklabelProvider.notifier)
                        .saveString(widget.field.id, data.text);
                    Navigator.pop(context);
                  },
                ),
              );
            } else {
              scrollBottomSheet(
                context,
                child: CustomFormBuilderQueryDropdown(
                  apiCall: widget.apiCall!,
                  linkedQuery: widget.field.linkedQuery ?? '',
                  onChanged: (ValueText data) {
                    setState(() {
                      selectedValue = data;
                    });
                    dropdownController.text = data.text;
                    ref
                        .read(currentStateNotifierProvider.notifier)
                        .saveString(widget.field.id, data.value);
                    ref
                        .read(linklabelProvider.notifier)
                        .saveString(widget.field.id, data.text);
                    Navigator.pop(context);
                  },
                ),
              );
            }
          },
          readOnly: true,
          name: widget.field.id,
          onChanged: (value) {},
          decoration: const InputDecoration(
            hintText: 'Please select an item from the list',
            suffixIcon: Icon(Icons.arrow_drop_down),
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),
        if (selectedValue?.action == true &&
            (widget.field.actionMessage ?? '').isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 12.0),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.red),
            child: Text(
              widget.field.actionMessage ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
