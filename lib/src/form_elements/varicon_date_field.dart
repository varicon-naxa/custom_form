import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';

import '../custom_element/date_time_form_field.dart';
import '../helpers/validators.dart';

///Field to input date time
///
///Accepts field type with date time input
class VariconDateField extends StatefulHookConsumerWidget {
  const VariconDateField({
    super.key,
    required this.field,
    required this.dateTime,
    this.labelText,
    this.fieldKey,
  });

  ///Dynmaic field model [date, time, datetime]
  final dynamic field;

  ///Label text for date time
  final String? labelText;

  ///Date time type enum
  final DatePickerType dateTime;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  @override
  ConsumerState<VariconDateField> createState() => _DateTimeInputWidgetState();
}

class _DateTimeInputWidgetState extends ConsumerState<VariconDateField> {
  final dateTextController = TextEditingController();
  final timeTextController = TextEditingController();
  DateTime? dateTime;

  late final DatePickerType datePickerType;

  late final DateTime now;

  // first and last date from SurveyJS
  late final DateTime? firstDate;
  late final DateTime? lastDate;

  // Initial date to show in date picker.
  late DateTime initialDate;

  // min and max date for validation.
  // it can either date time or date or time only.
  late final DateTime? min;
  late final DateTime? max;

  @override
  void initState() {
    super.initState();

    ///Initial date time, min and max date time
    datePickerType = widget.dateTime;

    min = _parseToDateTime(null, datePickerType);
    max = _parseToDateTime(null, datePickerType);

    now = DateTime.now();

    // first date, last date not required for time only picker.
    firstDate = min;
    lastDate = max;
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      fieldKey: widget.fieldKey,
      initialValue: _parseToDateTime(
        widget.field.answer,
        datePickerType,
      ),
      type: datePickerType,
      firstDate: firstDate,
      lastDate: lastDate,
      onChanged: (newValue) {
        if (newValue == null) return;

        late final String value;
        switch (datePickerType) {
          case DatePickerType.date:
            value = DateFormat('yyyy-MM-dd').format(newValue);
          case DatePickerType.time:
            value = DateFormat(DateFormat.HOUR24_MINUTE).format(newValue);
          case DatePickerType.dateTime:
            value =
                '${DateFormat('yyyy-MM-dd').format(newValue)}T${DateFormat(DateFormat.HOUR24_MINUTE).format(newValue)}';
        }

        ref.read(currentStateNotifierProvider.notifier).saveString(
              widget.field.id,
              value,
            );
      },
      isRequired: widget.field.isRequired,
      onSaved: (newValue) {
        if (newValue == null) return;

        late final String value;
        switch (datePickerType) {
          case DatePickerType.date:
            value = DateFormat('yyyy-MM-dd').format(newValue);
          case DatePickerType.time:
            value = DateFormat(DateFormat.HOUR24_MINUTE).format(newValue);
          case DatePickerType.dateTime:
            value =
                '${DateFormat('yyyy-MM-dd').format(newValue)}T${DateFormat(DateFormat.HOUR24_MINUTE).format(newValue)}';
        }
        ref.read(currentStateNotifierProvider.notifier).saveString(
              widget.field.id,
              value,
            );
      },
      validator: (value) {
        maxFormattedText() =>
            DateTimeFormField.getFormattedText(max, datePickerType);
        minFormattedText() =>
            DateTimeFormField.getFormattedText(min, datePickerType);
        return dateTimeValidator(
          value: value,
          isRequired: widget.field.isRequired,
          min: min,
          max: max,
          requiredErrorText: 'Response required',
          maxErrorText: 
              'The value should not be greater than ${maxFormattedText()}',
          minErrorText: 
              'The value should not be less than ${minFormattedText()}',
        );
      },
    );
  }

  ///Method to parse date time
  ///
  ///Accepts value and date time picker type
  ///
  ///Returns date time afetr parsing
  static DateTime? _parseToDateTime(dynamic value, DatePickerType pickerType) {
    if (value is! String) {
      return null;
    } else if (value.isEmpty) {
      return null;
    }

    switch (pickerType) {
      case DatePickerType.dateTime:
        return DateTime.parse(value);
      case DatePickerType.date:
        return DateTime.parse(value);
      case DatePickerType.time:
        final dt = value.split(':');
        final dur = Duration(
          hours: int.parse(dt.first),
          minutes: int.parse(dt.last),
        );
        return DateTime(0).add(dur);
    }
  }
}
