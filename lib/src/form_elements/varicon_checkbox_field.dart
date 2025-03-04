import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_radio_field.dart';
import 'package:varicon_form_builder/src/helpers/debouncer.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import 'package:varicon_form_builder/src/state/link_label_provider.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_checkbox_group.dart';
import '../state/required_id_provider.dart';

class VariconCheckboxField extends ConsumerWidget {
  const VariconCheckboxField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final CheckboxInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer debouncer = Debouncer(milliseconds: 500);

    final otherValue = ref.watch(otherFieldValue);
    List<String> data = (field.answer ?? '').split(',');
    List<ValueText> filteredData =
        field.choices.where((item) => data.contains(item.value)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomFormBuilderCheckboxGroup<ValueText>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          name: const Uuid().v4(),
          otherText: field.answerList,
          initialValue: filteredData,
          // initialValue: const ['Dart'],
          options: field.choices
              .map((lang) => FormBuilderFieldOption(
                    value: lang,
                    child: Text((lang.isOtherField ?? false)
                        ? 'Other (please specify)'
                        : lang.text),
                  ))
              .toList(growable: false),
          onChanged: (data) {
            ref.read(currentStateNotifierProvider.notifier).saveString(
                field.id, (data ?? []).map((e) => e.value).join(','));
          },
          onOtherSelectedValue: (isSelected, text) {
            if (isSelected && field.isRequired == false) {
              ref
                  .read(requiredNotifierProvider.notifier)
                  .addRequiredField(field.id, GlobalObjectKey(field.id));
            } else if (isSelected == false && field.isRequired == false) {
              ref.read(requiredNotifierProvider.notifier).remove(field.id);
            }
            if (isSelected == true) {
              debouncer.run(() {
                ref.read(linklabelProvider.notifier).saveString(field.id, text);
                ref.read(radiotherFieldValue.notifier).state =
                    ValueText(isOtherField: isSelected, value: text, text: '');
              });
            } else {
              ref.read(linklabelProvider.notifier).remove(field.id);
            }

            log('Selected: $isSelected, Text: $text');
          },
          actionMessage: field.actionMessage,
          validator: (value) {
            if (field.isRequired && (value ?? []).isEmpty) {
              return 'This field is required';
            } else if (otherValue?.isOtherField == true &&
                (otherValue?.value ?? '').isEmpty) {
              return 'Please specify other in textbox';
            }
            return null;
          },
          orientation: OptionsOrientation.vertical,
        ),
      ],
    );
  }
}

final otherFieldValue = StateProvider<ValueText?>((ref) => null);
