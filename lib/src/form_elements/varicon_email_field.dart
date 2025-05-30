import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../varicon_form_builder.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';

class VariconEmailField extends ConsumerWidget {
  const VariconEmailField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final EmailInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debouncer debouncer = Debouncer(milliseconds: 500);
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      initialValue: field.answer ?? '',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: labelText,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      validator: (value) {
        return textValidator(
          value: (value ?? '').trim(),
          inputType: "email",
          isRequired: field.isRequired,
          requiredErrorText: null,
        );
      },
      onChanged: (value) {
        // debouncer.run(() {
          ref.read(currentStateNotifierProvider.notifier).saveString(
                field.id,
                value.toString().trim(),
              );
        // });
      },
    );
  }
}
