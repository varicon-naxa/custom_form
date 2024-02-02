import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/action_button.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;

  CustomTimePickerDialog({
    required this.initialTime,
    this.cancelText,
    this.confirmText,
    this.helpText,
  });

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hourOfPeriod;
    _selectedMinute = widget.initialTime.minute;
    _isAM = widget.initialTime.period == DayPeriod.am;
  }

  int convertTo24HourFormat(int hour, bool isAM) {
    if (isAM) {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.helpText ?? 'Select Time'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPicker(_buildHourPicker(), 'Hours'),
          _buildPicker(_buildMinutePicker(), 'Minutes'),
          _buildPicker(_buildPeriodPicker(), 'AM/PM'),
        ],
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ActionButton(
                      buttonText: 'CANCEL',
                      verticalPadding: 14,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderColor: Colors.grey,
                      buttonColor: Colors.white,
                    ),
                  ),
                  AppSpacing.sizedBoxW_08(),
                  Expanded(
                    child: ActionButton(
                        buttonText: 'SAVE',
                        verticalPadding: 14,
                        onPressed: () {
                          int hour24Format =
                              convertTo24HourFormat(_selectedHour, _isAM);
                          TimeOfDay selectedTime24HourFormat = TimeOfDay(
                              hour: hour24Format, minute: _selectedMinute);
                          Navigator.pop(context, selectedTime24HourFormat);
                        }),
                  ),
                ])),
        // CupertinoDialogAction(
        //   child: Text(widget.cancelText ?? 'Cancel'),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        // CupertinoDialogAction(
        //   child: Text(widget.confirmText ?? 'OK'),
        //   onPressed: () {

        //   },
        // ),
      ],
    );
  }

  Widget _buildPicker(Widget picker, String label) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          height: 300,
          child: picker,
        ),
      ],
    );
  }

  Widget _buildHourPicker() {
    return CupertinoPicker(
      itemExtent: 60,
      onSelectedItemChanged: (value) {
        setState(() {
          _selectedHour = value + 1;
        });
      },
      children: List.generate(12, (index) {
        return Center(child: Text((index + 1).toString()));
      }),
    );
  }

  Widget _buildMinutePicker() {
    return CupertinoPicker(
      itemExtent: 60,
      onSelectedItemChanged: (value) {
        setState(() {
          _selectedMinute = value;
        });
      },
      children: List.generate(60, (index) {
        return Center(child: Text(index.toString().padLeft(2, '0')));
      }),
    );
  }

  Widget _buildPeriodPicker() {
    return CupertinoPicker(
      itemExtent: 60,
      onSelectedItemChanged: (value) {
        setState(() {
          _isAM = value == 0;
        });
      },
      children: const [
        Center(child: Text('AM')),
        Center(child: Text('PM')),
      ],
    );
  }
}
