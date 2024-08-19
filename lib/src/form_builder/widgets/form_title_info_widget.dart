import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

///CF form title description and location info widget
///
///Hide & show on scroll behaviour
class FormTitleInfoWidget extends StatefulWidget {
  const FormTitleInfoWidget(
      {super.key,
      required this.hasGeolocation,
      required this.surveyForm,
      this.currentPosition,
      required this.scrollController});

  final bool hasGeolocation;
  final SurveyPageForm surveyForm;
  final Position? currentPosition;
  final ScrollController scrollController;

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
        AppSpacing.sizedBoxH_08(),
        if (widget.hasGeolocation && widget.currentPosition?.latitude != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                label: Text(
                  'Geolocation tracking is enabled in this form. This form will capture approximate location from where the form is being submitted.',
                  style: Theme.of(context).textTheme.bodySmall,
                )),
          ),
      ],
    );
  }
}
