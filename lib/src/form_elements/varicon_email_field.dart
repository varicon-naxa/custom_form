import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/helpers/debouncer.dart';
import '../../varicon_form_builder.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';

class VariconEmailField extends ConsumerWidget {
  const VariconEmailField({
    super.key,
    required this.field,
    required this.labelText,
    this.isNested = false,
  });

  final EmailInputField field;
  final String labelText;
  final bool isNested;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer debouncer = Debouncer(milliseconds: 500);
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      initialValue: field.answer ?? '',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        return textValidator(
          value: value,
          inputType: "email",
          isRequired: field.isRequired,
          requiredErrorText: field.requiredErrorText,
        );
      },
      onChanged: (value) {
        debouncer.run(() {
          ref.read(currentStateNotifierProvider.notifier).saveString(
                field.id,
                value.toString().trim(),
              );
        });
      },
    );
  }
}
