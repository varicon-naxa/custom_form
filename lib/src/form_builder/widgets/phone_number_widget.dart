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

    bool val = !(phoneNumber == null ||
        phoneNumber.number.isEmpty ||
        !isNumeric(phoneNumber.number));

    return val;
  }

  late List<Country> _countryList;
  late Country _selectedCountry;
  PhoneNumber? phoneNumber;
  late List<Country> filteredCountries;
  late String number;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries ?? countries;
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (widget.initialCountryCode == null && number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere(
          (country) => number.startsWith(country.fullCountryCode),
          orElse: () => _countryList.first);

      // remove country code from the initial number value
      number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"), "");
    } else {
      _selectedCountry = _countryList.firstWhere(
          (item) => item.code == (widget.initialCountryCode ?? 'US'),
          orElse: () => _countryList.first);

      // remove country code from the initial number value
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
      number: widget.initialValue ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PhoneNumber>(
      name: widget.name,
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
      key: widget.formKey,
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
          textInputAction: TextInputAction.next,
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
        );
      },
    );
  }
}
