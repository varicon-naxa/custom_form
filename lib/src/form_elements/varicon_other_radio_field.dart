import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/custom_form_builder_radio_group.dart';
import '../state/current_form_provider.dart';
import '../state/link_label_provider.dart';

class VariconYesNoRadioField extends ConsumerWidget {
  const VariconYesNoRadioField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final YesNoInputField field;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFromBuilderRadioGroup(
      name: field.id,
      actionMessage: field.actionMessage,
      orientation: OptionsOrientation.vertical,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onOtherSelectedValue: (isSelected, text) {},
      onChanged: (value) {
        if (value != null) {
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(field.id, value.value);
          ref.read(linklabelProvider.notifier).saveString(field.id, value.text);
        }
      },
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
  });

  final YesNoNaInputField field;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFromBuilderRadioGroup(
      name: field.id,
      actionMessage: field.actionMessage,
      onOtherSelectedValue: (isSelected, text) {},
      orientation: OptionsOrientation.vertical,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (value != null) {
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(field.id, value.value);
          ref.read(linklabelProvider.notifier).saveString(field.id, value.text);
        }
      },
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
