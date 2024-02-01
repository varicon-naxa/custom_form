import 'dart:convert';
import 'package:example/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:varicon_form_builder/varicon_form_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const assetPath = 'assets/dd.json';
  String currentValue = await rootBundle.loadString(assetPath);
  Map<String, dynamic> currentData = jsonDecode(currentValue);

  final SurveyPageForm form = SurveyPageForm.fromJson(currentData);

  runApp(MyApp(
    form: form,
    data: currentData,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.form, required this.data});

  final SurveyPageForm form;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          errorMaxLines: 3,
        ),
      ),
      home: SurveyPage(
        form: form,
        formData: data,
      ),
    );
  }
}
