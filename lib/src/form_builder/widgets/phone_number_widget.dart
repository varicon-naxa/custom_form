import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class FormBuilderIntlPhoneField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? initialCountryCode;
  final String? initialValue;
  final List<Country>? countries;
  final String? invalidNumberMessage;
  final bool isRequired;
  final Key formKey;
  final Function(String data) onSaved;
  // Expose here more fields from IntlPhoneField as needed

  const FormBuilderIntlPhoneField({
    super.key,
    required this.name,
    required this.decoration,
    required this.onSaved,
    required this.formKey,
    this.initialCountryCode,
    this.countries,
    this.invalidNumberMessage,
    this.initialValue,
    this.isRequired = false,
  });

  @override
  State<FormBuilderIntlPhoneField> createState() =>
      _FormBuilderIntlPhoneFieldState();
}

class _FormBuilderIntlPhoneFieldState extends State<FormBuilderIntlPhoneField> {
  String? _error;
  // final _fieldKey = GlobalKey<FormBuilderFieldState>();

  _isValidIsRequired(PhoneNumber? phoneNumber) {
    if (!widget.isRequired) {
      return true;
    }

    return !(phoneNumber == null ||
        phoneNumber.number.isEmpty ||
        !isNumeric(phoneNumber.number));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PhoneNumber>(
      name: widget.name,
      validator: (phoneNumber) {
        if (!_isValidIsRequired(phoneNumber)) {
          return 'required'; // This message is not displayed at all in the UI
        }

        return null;
      },
      builder: (FormFieldState field) {
        return IntlPhoneField(
          decoration: widget.decoration.copyWith(
            errorText: _error,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          initialCountryCode: (widget.initialCountryCode ?? '').isEmpty
              ? 'AU'
              : widget.initialCountryCode,
          initialValue: widget.initialValue,
          countries: widget.countries,
          onChanged: (phoneNumber) => field.didChange(phoneNumber),
          onSaved: (phoneNumber) {
            field.didChange(phoneNumber);

            if (!_isValidIsRequired(phoneNumber)) {
              setState(() => _error =
                  FormBuilderLocalizations.of(context).requiredErrorText);
            } else {
              widget.onSaved(phoneNumber?.completeNumber ?? '');
              setState(() => _error = null);
            }
          },
          invalidNumberMessage: widget.invalidNumberMessage,
          disableLengthCheck: true,
          validator: (phoneNumber) {
            if (!_isValidIsRequired(phoneNumber)) {
              setState(() => _error =
                  FormBuilderLocalizations.of(context).requiredErrorText);
            } else {
              setState(() => _error = null);
            }

            return null;
          },
        );
      },
    );
  }
}
