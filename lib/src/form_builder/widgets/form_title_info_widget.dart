import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///CF form title description and location info widget
///
///Hide & show on scroll behaviour
class FormTitleInfoWidget extends StatefulWidget {
  const FormTitleInfoWidget({
    super.key,
    required this.surveyForm,
  });

  final SurveyPageForm surveyForm;

  @override
  State<FormTitleInfoWidget> createState() => _FormTitleInfoWidgetState();
}

class _FormTitleInfoWidgetState extends State<FormTitleInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.surveyForm.title.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                height: 1.2,
              ),
        ),
        AppSpacing.sizedBoxH_08(),
        Text(
          widget.surveyForm.description.toString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xff6A737B),
              ),
        ),
   ],
    );
  }
}
