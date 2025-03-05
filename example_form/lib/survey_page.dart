import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Rand;
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key, required this.form, required this.formData});

  final SurveyPageForm form;
  final Map<String, dynamic> formData;

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final GlobalKey<VariconFormBuilderState> childKey =
      GlobalKey<VariconFormBuilderState>();

  onBackPressed(bool backPressed) {
    // Check if the form is filled but not saved
    if (backPressed) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to leave?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Leave'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return VariconFormBuilder(
      key: childKey,
      padding: const EdgeInsets.all(12.0),
      buttonText: 'SUBMIT',
      surveyForm: widget.form,
      hasAutoSave: true,
      autoSave: (formValue) {},
      onBackPressed: onBackPressed,
      separatorBuilder: () => const SizedBox(height: 10),
      onSubmit: (formValue) {
        log(jsonEncode(formValue));
      },
      onSave: (formValue) {
        Map<String, dynamic> data = widget.formData;
        List<Map<String, dynamic>> elements = List<Map<String, dynamic>>.from(
          data['elements'],
        );
        final valueList =
            elements.map((e) {
              final key = formValue[e['id']];
              if (key != null) {
                e.addAll({'answer': key});
              }
              return e;
            }).toList();
        log(valueList.toString());
      },
      apiCall: (mapData) async {
        if (mapData['page'] == '1' && mapData['q'].toString().isEmpty) {
          await Future.delayed(const Duration(seconds: 2));
          return [
            {"id": '12345', "label": 'equipment1'},
            {"id": '54123', "label": 'equipment2'},
            {"id": '123461', "label": 'equipment3'},
            {"id": '123462', "label": 'equipment31'},
            {"id": '123463', "label": 'equipment32'},
            {"id": '123464', "label": 'equipment33'},
            {"id": '123465', "label": 'equipment34'},
            {"id": '123466', "label": 'equipment35'},
            {"id": '123467', "label": 'equipment36'},
            {"id": '123468', "label": 'equipment37'},
            {"id": '123469', "label": 'equipment38'},
            {"id": '1234610', "label": 'equipment39'},
            {"id": '1234611', "label": 'equipment310'},
          ];
        } else if (mapData['page'] == '2') {
          await Future.delayed(const Duration(seconds: 5));
          return [
            {'id': '123451', 'label': 'equipment4'},
            {'id': '541213', 'label': 'equipment5'},
            {'id': '123146', 'label': 'equipment6'},
          ];
        } else if (mapData['page'] == '1' &&
            mapData['q'].toString().isNotEmpty) {
          await Future.delayed(const Duration(seconds: 5));
          return [
            {'id': '121345', 'label': 'equipment7'},
            {'id': '5411123', 'label': 'equipment8'},
            {'id': '123416', 'label': 'equipment9'},
          ];
        } else {
          await Future.delayed(const Duration(seconds: 5));
          return [
            {'id': '132345', 'label': 'equipment10'},
            {'id': '154123', 'label': 'equipment11'},
            {'id': '212346', 'label': 'equipment12'},
          ];
        }
      },
      formtitle: 'Submit Form',
      attachmentSave: (data) async {
        await Future.delayed(const Duration(seconds: 5));
        log('dpme');
        return [
          {
            'id': '${Rand.Random().nextDouble() * 10000}',
            'file':
                'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            'thumbnail':
                'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            'name': '300.jpg',
            "created_at": "2025-03-05T05:05:54.835848Z",
          },
        ];
      },
      imageBuild: (Map<String, dynamic> data) {
        return CachedNetworkImage(
          imageUrl: data['image'],
          height: data['height'],
          width: data['width'],
          placeholderFadeInDuration: const Duration(seconds: 1),
          placeholder: (context, url) => const Icon(Icons.image),
        );
      },
      onFileClicked: (String stringURl) {},
      customPainter: (data) {
        return Container();
      },
      locationData: '',
      onPopPressed: () {},
    );
  }
}
