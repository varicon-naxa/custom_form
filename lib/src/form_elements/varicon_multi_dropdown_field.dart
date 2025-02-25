import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/src/widget/normal_bottomsheet.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_multi_dropdown.dart';
import '../custom_element/custom_form_builder_query_multi_dropdown.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';
import '../state/link_label_provider.dart';
import '../widget/scroll_bottomsheet.dart';

class VariconMultiDropdownField extends StatefulHookConsumerWidget {
  const VariconMultiDropdownField(
      {super.key,
      required this.field,
      required this.labelText,
      this.apiCall});

  final MultipleInputField field;
  final String labelText;
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
  List<String> linkedSelectedText = [];

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
      List<String> selectedAnswersText =
          (widget.field.answerList ?? '').split(',');
      if (selectedAnswers.isNotEmpty) {
        dropdownController.text = '${selectedAnswers.length} items selected';
        linkedSelectedIds = selectedAnswers;
        linkedSelectedText = selectedAnswersText;
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
                    selectedValue = data;

                    if (data.isNotEmpty) {
                      dropdownController.text = '${data.length} items selected';
                      ref
                          .read(currentStateNotifierProvider.notifier)
                          .saveString(widget.field.id,
                              data.map((e) => e.value).join(','));
                      ref.read(linklabelProvider.notifier).saveString(
                            widget.field.id,
                            data.map((e) => e.text).join(','),
                          );
                    } else {
                      ref
                          .read(currentStateNotifierProvider.notifier)
                          .remove(widget.field.id);
                      ref.read(linklabelProvider.notifier).remove(
                            widget.field.id,
                          );
                      dropdownController.text = '';
                    }
                    setState(() {});
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
                  onChanged: (List<String> id, List<String> text) {
                    linkedSelectedIds = id;
                    linkedSelectedText = text;
                    if (id.isNotEmpty) {
                      dropdownController.text = '${id.length} items selected';
                      ref
                          .read(currentStateNotifierProvider.notifier)
                          .saveString(widget.field.id, id.join(','));
                      ref.read(linklabelProvider.notifier).saveString(
                            widget.field.id,
                            text.join(','),
                          );
                    } else {
                      ref
                          .read(currentStateNotifierProvider.notifier)
                          .remove(widget.field.id);
                      ref.read(linklabelProvider.notifier).remove(
                            widget.field.id,
                          );
                      dropdownController.text = '';
                    }
                    setState(() {});
                  },
                  initialItems: linkedSelectedIds,
                  linkedInitialItems: linkedSelectedText,
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
