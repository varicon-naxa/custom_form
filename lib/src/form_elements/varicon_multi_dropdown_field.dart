import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/src/widget/normal_bottomsheet.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_multi_dropdown.dart';
import '../custom_element/custom_form_builder_query_multi_dropdown.dart';
import '../helpers/validators.dart';
import '../widget/scroll_bottomsheet.dart';

class VariconMultiDropdownField extends StatefulHookConsumerWidget {
  const VariconMultiDropdownField(
      {super.key,
      required this.field,
      required this.labelText,
      this.isNested = false,
      this.apiCall});

  final MultipleInputField field;
  final String labelText;
  final bool isNested;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  ConsumerState<VariconMultiDropdownField> createState() =>
      _VariconMultiDropdownFieldState();
}

class _VariconMultiDropdownFieldState
    extends ConsumerState<VariconMultiDropdownField> {
  TextEditingController dropdownController = TextEditingController();
  List<ValueText> selectedValue = [];
  List<String> linkedSelectedIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.field.fromManualList) {
      if (widget.field.answer != null && widget.field.answer != '') {
        List<String> selectedAnswers = widget.field.answer!.split(',');
        selectedValue = widget.field.choices
            .where((element) => selectedAnswers.contains(element.value))
            .toList();
        setState(() {});
        if (selectedValue.isNotEmpty) {
          dropdownController.text = '${selectedValue.length} items selected';
        }
      }
    } else if (widget.field.fromManualList == false &&
        widget.field.answer != null &&
        widget.field.answer != '') {
      String selectedAnswer = widget.field.answer ?? '';
      List<String> selectedAnswers = selectedAnswer.split(',');
      if (selectedAnswers.isNotEmpty) {
        dropdownController.text = '${selectedAnswers.length} items selected';
        linkedSelectedIds = selectedAnswers;
        setState(() {});
      }
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
                child: CustomFormBuilderMultiDropdown(
                  choices: widget.field.choices,
                  actionMessage: widget.field.actionMessage,
                  onChanged: (data) {
                    setState(() {
                      selectedValue = data;
                    });
                    if (data.isNotEmpty) {
                      dropdownController.text = '${data.length} items selected';
                    } else {
                      dropdownController.text = '';
                    }
                  },
                  initialValue: selectedValue,
                ),
              );
            } else {
              scrollBottomSheet(
                context,
                child: CustomFormBuilderQueryMultiDropdown(
                  apiCall: widget.apiCall!,
                  linkedQuery: widget.field.linkedQuery ?? '',
                  onChanged: (List<String> data) {
                    linkedSelectedIds = data;
                    if (data.isNotEmpty) {
                      dropdownController.text = '${data.length} items selected';
                    }
                    setState(() {});
                  },
                  initialItems: linkedSelectedIds,
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
              contentPadding: EdgeInsets.all(8.0)),
        ),
        if (selectedValue.any((element) => element.action == true) &&
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
