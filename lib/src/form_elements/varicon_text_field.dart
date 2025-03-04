import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/helpers/debouncer.dart';
import '../../varicon_form_builder.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';

class VariconTextField extends ConsumerWidget {
  const VariconTextField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final TextInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer debouncer = Debouncer(milliseconds: 500);
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      initialValue: field.answer ?? '',
      keyboardType: (field.name ?? '').toLowerCase().contains('long')
          ? TextInputType.multiline
          : TextInputType.text,
      textInputAction: (field.name ?? '').toLowerCase().contains('long')
          ? TextInputAction.newline
          : TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: labelText,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      validator: (value) {
        return textValidator(
          value: value,
          inputType: "text",
          isRequired: field.isRequired,
          requiredErrorText: field.requiredErrorText,
        );
      },
      onChanged: (value) {
        debouncer.run(() {
          ref
              .read(currentStateNotifierProvider.notifier)
              .saveString(field.id, value);
        });
      },
    );
  }
}
