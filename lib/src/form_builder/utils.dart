import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/date_time_form_field.dart';

class Utils {
  ///Returns formatted date time
  ///
  ///in comparision to date type
  ///
  ///and return formatted string value
  static String getFormattedText(DateTime? value, DatePickerType type) {
    if (value == null) return '';
    switch (type) {
      case DatePickerType.date:
        return DateFormat.yMd().format(value);
      case DatePickerType.time:
        return DateFormat(DateFormat.HOUR_MINUTE).format(value);
      case DatePickerType.dateTime:
        return '${DateFormat.yMd().format(value)}, ${DateFormat(DateFormat.HOUR_MINUTE).format(value)}';
    }
  }

  ///Method that takes date picker type
  ///
  ///and returns the date time value
  ///
  ///[value] is the value to be parsed
  static DateTime? parseToDateTime(dynamic value, DatePickerType pickerType) {
    if (value is! String) {
      return null;
    } else if (value.isEmpty) {
      return null;
    }

    ///switch case to handle date types and return parsed values
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
