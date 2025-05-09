import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../varicon_form_builder.dart';
import '../custom_element/formbuilder_phone_field.dart';
import '../state/current_form_provider.dart';

class VariconPhoneField extends ConsumerWidget {
  const VariconPhoneField({
    super.key,
    required this.field,
    required this.labelText,
  });

  final PhoneInputField field;
  final String labelText;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PhoneNumber? phoneNumber;
    phoneNumber =
        PhoneNumber.fromCompleteNumber(completeNumber: field.answer ?? '');
    return FormBuilderIntlPhoneField(
      name: field.label ?? '',
      initialValue: phoneNumber.number,
      initialCountryCode: phoneNumber.countryISOCode,
      invalidNumberMessage: 'Invalid Phone Number',
      isRequired: field.isRequired,
      onSaved: (newValue) {
        Country country = PhoneNumber.getCountry(newValue);
        if (newValue.replaceAll('+', '').toString().trim() !=
            country.dialCode.trim()) {
          ref.read(currentStateNotifierProvider.notifier).saveString(
                field.id,
                newValue,
              );
        } else {
          if (phoneNumber?.number != null) {
            ref.read(currentStateNotifierProvider.notifier).saveString(
                  field.id,
                  newValue,
                );
          }
        }
      },
      decoration: const InputDecoration(
        hintText: 'Phone Number',
        contentPadding:  EdgeInsets.all(8.0),
      ),
    );
  }
}
