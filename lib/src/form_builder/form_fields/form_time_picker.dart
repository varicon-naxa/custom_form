import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/custom_time_picker.dart';

///Custom time picker dialog
///
///Accepts initial time, cancel text and confirm text
///
///Returns selected time
Future<TimeOfDay?> showCustomTimePicker({
  ///BuildContext for the dialog
  required BuildContext context,

  ///Initial time for the dialog
  required TimeOfDay initialTime,

  ///Transition builder for the dialog
  TransitionBuilder? builder,

  ///Barrier dismissible boolean
  bool barrierDismissible = true,

  ///Barrier color of dialog box
  Color? barrierColor,

  ///Barrier label of dialog box
  String? barrierLabel,

  ///Use root navigator boolean
  bool useRootNavigator = true,

  ///Initial entry mode for the dialog
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,

  ///Cancel text for the dialog
  String? cancelText,

  ///Confirm text for the dialog
  String? confirmText,

  ///Help text for the dialog
  String? helpText,

  ///Error invalid text for the dialog
  String? errorInvalidText,

  ///Hour label text for the dialog
  String? hourLabelText,

  ///Minute label text for the dialog
  String? minuteLabelText,

  ///Route settings for the dialog
  RouteSettings? routeSettings,

  ///On changed entry mode callback for the dialog
  EntryModeChangeCallback? onEntryModeChanged,

  ///Anchor point for the dialog
  Offset? anchorPoint,

  ///Orientation for the dialog
  Orientation? orientation,
}) async {
  assert(debugCheckHasMaterialLocalizations(context));

  final Widget dialog = CustomTimePickerDialog(
    initialTime: initialTime,
    cancelText: cancelText,
    confirmText: confirmText,
    helpText: helpText,
  );
  return showDialog<TimeOfDay>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}
