// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/action_button.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///Custom time picker dialog
///
///Accepts initial time, cancel text and confirm text
///
///Returns selected time
class CustomTimePickerDialog extends StatefulWidget {
  ///Initial time for the dialog
  final TimeOfDay initialTime;

  ///Cancel text for the dialog
  final String? cancelText;

  ///Confirm text for the dialog
  final String? confirmText;

  ///Help text for the dialog
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

//Converts the selected time to 24 hour format
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
      title: Text(
        widget.helpText ?? 'Select Time',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPicker(_buildHourPicker(), 'Hours'),
          Text(
            ':',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
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

  ///Builds the picker dialog widget
  Widget _buildPicker(Widget picker, String label) {
    return Expanded(
      child: SizedBox(
        height: 250,
        child: picker,
      ),
    );
  }

  ///Builds the hour picker widget
  Widget _buildHourPicker() {
    return CupertinoPicker(
      itemExtent: 45,
      looping: true,
      useMagnifier: true,
      magnification: 1.05,
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

  ///Builds the minute picker widget
  Widget _buildMinutePicker() {
    return CupertinoPicker(
      itemExtent: 45,
      looping: true,
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

  ///Builds the period picker widget
  Widget _buildPeriodPicker() {
    return CupertinoPicker(
      itemExtent: 45,
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
