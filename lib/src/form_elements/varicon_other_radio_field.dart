import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_radio_group.dart';

class VariconYesNoRadioField extends ConsumerWidget {
  const VariconYesNoRadioField({
    super.key,
    required this.field,
    required this.labelText,
    this.isNested = false,
  });

  final YesNoInputField field;
  final String labelText;

  final bool isNested;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFromBuilderRadioGroup(
      name: field.id,
      actionMessage: field.actionMessage,
      orientation: OptionsOrientation.vertical,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (field.isRequired && value == null) {
          return 'This field is required';
        }
        return null;
      },
      options: field.choices
          .map((lang) => FormBuilderFieldOption(
                value: lang,
                child: Text(lang.text),
              ))
          .toList(growable: false),
    );
  }
}

class VariconYesNoNaRadioField extends ConsumerWidget {
  const VariconYesNoNaRadioField({
    super.key,
    required this.field,
    required this.labelText,
    this.isNested = false,
  });

  final YesNoNaInputField field;
  final String labelText;

  final bool isNested;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFromBuilderRadioGroup(
      name: field.id,
      actionMessage: field.actionMessage,
      orientation: OptionsOrientation.vertical,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (field.isRequired && value == null) {
          return 'This field is required';
        }
        return null;
      },
      options: field.choices
          .map((lang) => FormBuilderFieldOption(
                value: lang,
                child: Text(lang.text),
              ))
          .toList(growable: false),
    );
  }
}
