import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../form_elements.dart';

///CF bottom nav btn widget
///
///Btn for submit and update form, reacts on scroll for visibility
class SubmitUpdateButtonWidget extends StatefulWidget {
  const SubmitUpdateButtonWidget(
      {super.key,
      required this.buttonText,
      required this.formKey,
      required this.formValue,
      required this.onSubmit,
      required this.hasGeolocation,
      required this.surveyForm,
      required this.currentPosition,
      required this.formInputWidgetsKey,
      this.hasAutoSave = false});

  final String buttonText;
  final GlobalKey<FormState> formKey;
  final FormValue formValue;
  final Function onSubmit;
  final bool hasGeolocation;
  final SurveyPageForm surveyForm;
  final Position? currentPosition;
  final bool hasAutoSave;
  final GlobalKey<FormInputWidgetsState> formInputWidgetsKey;

  @override
  State<SubmitUpdateButtonWidget> createState() =>
      _SubmitUpdateButtonWidgetState();
}

class _SubmitUpdateButtonWidgetState extends State<SubmitUpdateButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      duration: const Duration(milliseconds: 200),
      height: 75,
      child: Row(
        children: [
          if (widget.hasAutoSave) ...[
            Expanded(
              child: NavigationButton(
                buttonText: 'SUBMIT LATER',
                onComplete: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Icon(
                              Icons.info,
                              size: 60,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              'The submission will be saved to draft.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        content: const Text(
                          'Please note clocking out from Varicon will remove these draft submissions.',
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                          NavigationButton(
                            buttonText: 'OKAY',
                            onComplete: () async {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  ).then((data) {
                    Navigator.of(context).pop();
                  });
                },
                isAutoSave: true,
              ),
            ),
            AppSpacing.sizedBoxW_12(),
          ],
          Expanded(
            child: NavigationButton(
              buttonText: widget.buttonText,
              onComplete: () async {
                try {
                  // return if form state is null.
                  if (widget.formKey.currentState == null) return;
                  // return if form is not valid.
                  if (!widget.formKey.currentState!.validate()) {
                    widget.formInputWidgetsKey.currentState
                        ?.scrollToFirstInvalidField();
                    return;
                  }

                  widget.formKey.currentState?.save();
                  Map<String, dynamic> fulldata = widget.formValue.value;

                  if (widget.hasGeolocation) {
                    fulldata.addAll({
                      'location':
                          widget.surveyForm.setting?['location']['lat'] == null
                              ? {
                                  'lat': widget.currentPosition?.latitude,
                                  'long': widget.currentPosition?.longitude,
                                }
                              : widget.surveyForm.setting?['location']
                    });
                  }
                  widget.onSubmit(widget.formValue.value);
                } catch (e) {
                  log('catch bhitra' + e.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
