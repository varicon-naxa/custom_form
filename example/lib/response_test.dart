import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResponseTest extends StatefulWidget {
  const ResponseTest({super.key, required this.form, required this.formData});

  final SurveyPageForm form;
  final Map<String, dynamic> formData;

  @override
  State<ResponseTest> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<ResponseTest> {
  final GlobalKey<VariconFormBuilderState> childKey =
      GlobalKey<VariconFormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SurveyJs Form',
          style: TextStyle(),
        ),
      ),
      // understand this full code and have a condition in here where if the form is filled but bot saved and back button is pressed then alert dialog should appear

      body: ResponseFormBuilder(
        key: childKey,
        surveyForm: widget.form,
        hasGeolocation: false,
        timesheetClick: (String timesheetId) {
          log('Timesheet Id $timesheetId');
        },
        imageBuild: (Map<String, dynamic> data) {
          return CachedNetworkImage(
            placeholderFadeInDuration: Duration(seconds: 3),
            placeholder: (context, url) => Icon(Icons.image),
            imageUrl: data['image'],
            height: data['height'] == null
                ? null
                : double.parse(data['height'].toString()),
            width: data['width'] == null
                ? null
                : double.parse(data['width'].toString()),
          );
        },
        fileClick: (Map<String, dynamic> url) {},
      ),
    );
  }
}
