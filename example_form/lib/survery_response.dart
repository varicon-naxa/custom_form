import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';

class SurveryResponse extends StatefulWidget {
  const SurveryResponse({super.key, required this.form});

  final SurveyPageForm form;

  @override
  State<SurveryResponse> createState() => _SurveryResponseState();
}

class _SurveryResponseState extends State<SurveryResponse> {
  final GlobalKey<VariconFormBuilderState> childKey =
      GlobalKey<VariconFormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Response Form Builder')),
      body: VariconResponseBuilder(
        key: childKey,

        formtitle: 'Submit Form',
        imageBuild: (Map<String, dynamic> data) {
          return CachedNetworkImage(
            imageUrl: data['image'],
            height: data['height'],
            width: data['width'],
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (context, url) => const Icon(Icons.image),
          );
        },
        surveyForm: widget.form,
        fileClick: (Map<String, dynamic> url) {},
        hasGeolocation: widget.form.collectGeolocation ?? false,
        timesheetClick: (String) {},
      ),
    );
  }
}
