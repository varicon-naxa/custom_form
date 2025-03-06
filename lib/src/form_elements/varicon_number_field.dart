import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/helpers/debouncer.dart';
import '../../varicon_form_builder.dart';
import '../helpers/validators.dart';
import '../state/current_form_provider.dart';

class VariconNumberField extends ConsumerWidget {
  const VariconNumberField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final NumberInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Debouncer debouncer = Debouncer(milliseconds: 500);
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: false),
      initialValue: field.answer ?? '',
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: labelText,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          return text.isEmpty
              ? newValue
              : double.tryParse(text) == null
                  ? oldValue
                  : newValue;
        }),
      ],
      validator: (value) {
        return numberValidator(
          value: (value?.isNotEmpty ?? false)
              ? num.tryParse(value.toString())
              : null,
          isRequired: field.isRequired,
          requiredErrorText: null,
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
