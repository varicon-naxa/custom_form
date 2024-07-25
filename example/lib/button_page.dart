// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:example/response_test.dart';
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
  TextEditingController mapFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                const assetPath = 'assets/question_inspection.json';
                String currentValue = await rootBundle.loadString(assetPath);
                Map<String, dynamic> currentData = jsonDecode(currentValue);

                final SurveyPageForm form =
                    SurveyPageForm.fromJson(currentData);

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
              child: const Text('Go Questrion Inspection Page'),
            ),
            ElevatedButton(
              onPressed: () async {
                const assetPath = 'assets/linked.json';
                String currentValue = await rootBundle.loadString(assetPath);
                Map<String, dynamic> currentData = jsonDecode(currentValue);

                final SurveyPageForm form =
                    SurveyPageForm.fromJson(currentData);

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
            ElevatedButton(
              onPressed: () async {
                const assetPath = 'assets/question_inspection.json';
                String currentValue = await rootBundle.loadString(assetPath);
                Map<String, dynamic> currentData = jsonDecode(currentValue);

                final SurveyPageForm form =
                    SurveyPageForm.fromJson(currentData);

                ///Navigate on button click to SuveryPage
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return ResponseTest(
                        form: form,
                        formData: currentData,
                      );
                      // SurveyPage(form: form, formData: currentData);
                    },
                  ),
                );
              },
              child: const Text('Go Response Page'),
            ),
          ],
        ),
      ),
    );
  }
}
