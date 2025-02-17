import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/custom_element/form_time_picker.dart';

///Date picker type enum
///
///Handles date, time and dateTime
enum DatePickerType { date, time, dateTime }

///Date time form field
///
///
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,

    ///Date picker type
    ///
    ///Defaults to [DatePickerType.dateTime]
    DatePickerType type = DatePickerType.dateTime,

    ///Form field validator
    super.validator,

    ///Form field on changed
    super.onSaved,

    ///Form field enabled boolean
    super.enabled,

    /// Form Field on changed

    ///Form field initial value
    super.initialValue,

    ///Form field  frst date
    DateTime? firstDate,

    ///Form field last date
    DateTime? lastDate,

    ///Form field reqyured
    bool? isRequired,
    final Function(DateTime?)? onChanged,
    final GlobalKey<FormFieldState<dynamic>>? fieldKey,

    ///Form field autovalidate mode default to [AutovalidateMode.onUserInteraction]
    super.autovalidateMode = AutovalidateMode.onUserInteraction,

    ///Form field date  builder
    String Function(DateTime? dateTime, DatePickerType type)? dateBuilder,
  }) : super(builder: (fieldState) {
          final state = fieldState as _DateTimeFormState;
          final effectiveFirstDate = firstDate ?? DateTime(1900);
          final effectiveLastDate = lastDate ?? DateTime(2100);
          TextEditingController controller = TextEditingController(
              text: dateBuilder?.call(state.value, type) ??
                  getFormattedText(state.value, type));
          log('key $fieldKey');

          return GestureDetector(
            onTap: () async {
              DateTime? date;
              TimeOfDay? time;
              final focus = FocusNode();
              FocusScope.of(state.context).requestFocus(focus);

              datePicker() => showDatePicker(
                    context: state.context,
                    initialDate: _getInitialDate(
                        state.value, effectiveFirstDate, effectiveLastDate),
                    firstDate: effectiveFirstDate,
                    lastDate: effectiveLastDate,
                  );

              // timePicker() => showTimePicker(
              //       context: state.context,
              //       initialTime: _getInitialTime(state.value),
              //     );
              timePicker() => showCustomTimePicker(
                    context: state.context,
                    initialTime: _getInitialTime(state.value),
                  );

              if (type == DatePickerType.dateTime ||
                  type == DatePickerType.date) {
                date = await datePicker();
              }

              final isCancelledOnDatePick =
                  type == DatePickerType.dateTime && date == null;

              // there is no need to show timepicker if cancel was pressed on
              // datepicker`
              if ((type == DatePickerType.dateTime && !isCancelledOnDatePick) ||
                  type == DatePickerType.time) {
                time = await timePicker();
              }

              if (
                  // if `date` and `time` in `dateTime` mode is not empty...
                  (type == DatePickerType.dateTime &&
                          (date != null && time != null)) ||
                      // ... or if `date` in `date` mode is not empty ...
                      (type == DatePickerType.date && date != null) ||
                      // ... or if `time` in `time` mode is not empty ...
                      (type == DatePickerType.time && time != null)) {
                final dateTime = _combine(date, time);

                final value = state.value;
                onChanged?.call(dateTime);
                // ... and new value is not the same as was before...
                if (value == null || dateTime.compareTo(value) != 0) {
                  // ... this means that cancel was not pressed at any moment
                  // so we can update the field
                  state.didChange(_combine(date, time));
                }
              }
            },
            child: TextFormField(
              key: fieldKey,
              readOnly: true,

              enabled: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,

              decoration: InputDecoration(
                errorText: state.errorText,
                hintText: _getHintText(type).toUpperCase(),
                contentPadding: const EdgeInsets.all(8.0),
              ),
              validator: (data) {
                if ((data == null || data.isEmpty) && isRequired == true) {
                  return 'This field is required';
                }
                return null;
              },
              // initialValue: dateBuilder?.call(state.value, type) ??
              //     getFormattedText(state.value, type),
              controller: controller,
              style: Theme.of(state.context).textTheme.bodyLarge,
            ),
          );
        });

  @override
  FormFieldState<DateTime> createState() => _DateTimeFormState();

  ///Initial dateTime values
  ///
  ///Compare the field value with the initial date and last date
  static DateTime _getInitialDate(
    DateTime? fieldValue,
    DateTime initialDate,
    DateTime lastDate,
  ) {
    if (fieldValue != null) {
      return fieldValue;
    }

    final now = DateTime.now();
    final dt = now.compareTo(lastDate) > 0 ? lastDate : now;
    return dt.compareTo(initialDate) > 0 ? dt : initialDate;
  }

  ///Initial time of day value
  static TimeOfDay _getInitialTime(DateTime? fieldValue) {
    if (fieldValue != null) {
      return TimeOfDay(hour: fieldValue.hour, minute: fieldValue.minute);
    }
    return const TimeOfDay(hour: 1, minute: 0);
  }

  ///Combines date and time to dateTime
  static DateTime _combine(DateTime? date, TimeOfDay? time) {
    DateTime dateTime = DateTime(0);

    if (date != null) {
      dateTime = dateTime.add(date.difference(dateTime));
    }

    if (time != null) {
      dateTime = dateTime.add(Duration(hours: time.hour, minutes: time.minute));
    }

    return dateTime;
  }

  ///Hint text for date picker type
  static String _getHintText(DatePickerType type) {
    switch (type) {
      case DatePickerType.date:
        return 'dd/mm/yyyy';
      case DatePickerType.time:
        return 'hh:mm';
      case DatePickerType.dateTime:
        return 'dd/mm/yyyy, hh:mm';
    }
  }

  ///Returns formatted text
  ///
  ///Returns formatted text based on date time value and date picker type
  ///
  ///Returns empty string if value is null
  static String getFormattedText(DateTime? value, DatePickerType type) {
    if (value == null) return '';
    switch (type) {
      case DatePickerType.date:
        return DateFormat('dd/MM/yyyy').format(value);
      case DatePickerType.time:
        return DateFormat(DateFormat.HOUR_MINUTE).format(value);
      case DatePickerType.dateTime:
        return '${DateFormat('dd/MM/yyyy').format(value)}, ${DateFormat(DateFormat.HOUR_MINUTE).format(value)}';
    }
  }
}

class _DateTimeFormState extends FormFieldState<DateTime> {}
