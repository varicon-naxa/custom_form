import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/date_time_form_field.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

import '../../models/form_value.dart';

///Field to input date time
///
///Accepts field type with date time input
class DateTimeInputWidget extends StatefulWidget {
  const DateTimeInputWidget({
    super.key,
    required this.field,
    required this.formValue,
    required this.dateTime,
    this.labelText,
    this.fieldKey,
  });

  ///Dynmaic field model [date, time, datetime]
  final dynamic field;

  ///Form value for date values
  final FormValue formValue;

  ///Label text for date time
  final String? labelText;

  ///Date time type enum
  final DatePickerType dateTime;

  /// Global key for the form field state
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;

  @override
  State<DateTimeInputWidget> createState() => _DateTimeInputWidgetState();
}

class _DateTimeInputWidgetState extends State<DateTimeInputWidget> {
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

    min = _parseToDateTime(widget.field.min, datePickerType);
    max = _parseToDateTime(widget.field.max, datePickerType);

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
        widget.formValue.saveString(
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
        widget.formValue.saveString(
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
          requiredErrorText:
              widget.field.requiredErrorText ?? 'Response required',
          maxErrorText: widget.field.maxErrorText ??
              'The value should not be greater than ${maxFormattedText()}',
          minErrorText: widget.field.minErrorText ??
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
