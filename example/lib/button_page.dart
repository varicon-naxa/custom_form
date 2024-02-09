// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:example/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:varicon_form_builder/varicon_form_builder.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              const assetPath = 'assets/multisignature.json';
              String currentValue = await rootBundle.loadString(assetPath);
              Map<String, dynamic> currentData = jsonDecode(currentValue);

              final SurveyPageForm form = SurveyPageForm.fromJson(currentData);

              ///Navigate on button click to SuveryPage
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SurveyPage(form: form, formData: currentData);
                  },
                ),
              );
            },
            child: const Text('Go Form Page'),
          ),
        ));
  }
}
