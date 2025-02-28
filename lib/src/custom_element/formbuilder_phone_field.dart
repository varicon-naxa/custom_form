import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:uuid/uuid.dart';

/// International phone field form component
///
/// Accepts field type with phone number input
///
/// Provides various country code options
class FormBuilderIntlPhoneField extends StatefulWidget {
  /// Phone field text
  final String name;

  /// Phone field decoration
  final InputDecoration decoration;

  /// Initial country code
  final String? initialCountryCode;

  /// Phone initial value
  final String? initialValue;

  /// List of countries
  final List<Country>? countries;

  /// String value for invalid number
  final String? invalidNumberMessage;

  /// Boolean value for required field
  final bool isRequired;

  /// Function to call save phone number
  final Function(String data) onSaved;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  // Expose here more fields from IntlPhoneField as needed
  const FormBuilderIntlPhoneField({
    super.key,
    required this.name,
    required this.decoration,
    required this.onSaved,
    this.initialCountryCode,
    this.countries,
    this.invalidNumberMessage,
    this.initialValue,
    this.isRequired = false,
    this.fieldKey,
  });

  @override
  State<FormBuilderIntlPhoneField> createState() =>
      _FormBuilderIntlPhoneFieldState();
}

class _FormBuilderIntlPhoneFieldState extends State<FormBuilderIntlPhoneField> {
  String? _error;
  late List<Country> _countryList;
  late Country _selectedCountry;
  PhoneNumber? phoneNumber;
  late String number;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries ?? countries;
    number = widget.initialValue ?? '';

    if ((widget.initialCountryCode == null && number.startsWith('+'))) {
      number = number.substring(1);
      _selectedCountry = _countryList.firstWhere(
          (country) => number.startsWith(country.fullCountryCode),
          orElse: () => _countryList.firstWhere((item) => item.code == 'AU'));

      number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"), "");
    } else {
      _selectedCountry = _countryList.firstWhere(
          (item) =>
              item.code ==
              (widget.initialCountryCode == ''
                  ? 'AU'
                  : widget.initialCountryCode ?? 'AU'),
          orElse: () => _countryList.first);

      if (number.startsWith('+')) {
        number = number.replaceFirst(
            RegExp("^\\+${_selectedCountry.fullCountryCode}"), "");
      } else {
        number = number.replaceFirst(
            RegExp("^${_selectedCountry.fullCountryCode}"), "");
      }
    }

    phoneNumber = PhoneNumber(
      countryISOCode: _selectedCountry.code,
      countryCode: '+${_selectedCountry.dialCode}',
      number: number,
    );
  }

  bool _isValidIsRequired(PhoneNumber? phoneNumber) {
    if (!widget.isRequired) {
      return true;
    }

    bool val = !(phoneNumber == null ||
        phoneNumber.number.isEmpty ||
        !isNumeric(phoneNumber.number));

    return val;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PhoneNumber>(
      name: const Uuid().v4(),
      initialValue: phoneNumber,
      validator: (phoneNumber) {
        if (!_isValidIsRequired(phoneNumber)) {
          setState(() =>
              _error = FormBuilderLocalizations.of(context).requiredErrorText);
          return _error;
        } else {
          setState(() => _error = null);
        }

        return null;
      },
      builder: (FormFieldState<PhoneNumber> field) {
        return IntlPhoneField(
          validator: (phoneNumber) {
            if (!_isValidIsRequired(phoneNumber)) {
              setState(() => _error =
                  FormBuilderLocalizations.of(context).requiredErrorText);
              return _error;
            } else {
              setState(() => _error = null);
            }
            return null;
          },
          decoration: widget.decoration.copyWith(
            errorText: _error,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          initialCountryCode: phoneNumber?.countryISOCode,
          initialValue: widget.initialValue,
          countries: widget.countries,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (phoneNumber) {
            field.didChange(phoneNumber);
            widget.onSaved(phoneNumber.completeNumber);
          },
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
        );
      },
    );
  }
}
