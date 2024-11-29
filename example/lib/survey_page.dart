import 'dart:convert';
import 'dart:developer';
import 'dart:math' as Rand;
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
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
    if (!backPressed) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
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
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'SurveyJs Form',
            style: TextStyle(),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              bool? value = childKey.currentState?.popInvoke();
              onBackPressed(value ?? true);
            },
          )),
      // understand this full code and have a condition in here where if the form is filled but bot saved and back button is pressed then alert dialog should appear

      body: VariconFormBuilder(
        key: childKey,
        padding: const EdgeInsets.all(12.0),
        buttonText: 'SUBMIT',
        isCarousel: false,
        surveyForm: widget.form,
        hasGeolocation: false,
        autoSave: (data) {
          log('dasdasd ' + data.toString());
        },
        separatorBuilder: () => const SizedBox(height: 10),
        onSubmit: (formValue) {
          Map<String, dynamic> data = widget.formData;
          List<Map<String, dynamic>> elements =
              List<Map<String, dynamic>>.from(data['elements']);

          final valueList = elements.map((e) {
            if (e['type'] == 'table') {
              // Update table structure before applying answers
              e['contents'] = formValue[e['id']];
            }

            final key = formValue[e['id']];
            final answerKey = formValue[
                e['id'].toString().substring(5, e['id'].toString().length)];

            if (key != null) {
              if (e['type'] == 'table' || e['type'] == 'advtable') {
                List<List<dynamic>> contents =
                    List<List<dynamic>>.from(e['contents']);
                for (var rowIndex = 0; rowIndex < contents.length; rowIndex++) {
                  contents[rowIndex] =
                      List<Map<String, dynamic>>.from(contents[rowIndex]);
                  for (var cellIndex = 0;
                      cellIndex < contents[rowIndex].length;
                      cellIndex++) {
                    Map<String, dynamic> cell = contents[rowIndex][cellIndex];
                    String cellId = cell['id'];
                    final subanswerKey = formValue[cellId
                        .toString()
                        .substring(5, cellId.toString().length)];
                    if (subanswerKey != null) {
                      cell['selectedLinkListLabel'] = subanswerKey;
                    }
                    if (formValue.containsKey(cellId)) {
                      cell['answer'] = formValue[cellId];
                    }
                  }
                }
                e['contents'] = contents;
              } else {
                e.addAll({'answer': key});
              }
            }
            if (answerKey != null) {
              e.addAll({'selectedLinkListLabel': answerKey});
            }
            return e;
          }).toList();
          log(jsonEncode(valueList).toString());
        },
        onSave: (formValue) {
          Map<String, dynamic> data = widget.formData;
          List<Map<String, dynamic>> elements =
              List<Map<String, dynamic>>.from(data['elements']);
          final valueList = elements.map((e) {
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
              {"value": '12345', "text": 'equipment1'},
              {"value": '54123', "text": 'equipment2'},
              {"value": '123461', "text": 'equipment3'},
              {"value": '123462', "text": 'equipment31'},
              {"value": '123463', "text": 'equipment32'},
              {"value": '123464', "text": 'equipment33'},
              {"value": '123465', "text": 'equipment34'},
              {"value": '123466', "text": 'equipment35'},
              {"value": '123467', "text": 'equipment36'},
              {"value": '123468', "text": 'equipment37'},
              {"value": '123469', "text": 'equipment38'},
              {"value": '1234610', "text": 'equipment39'},
              {"value": '1234611', "text": 'equipment310'},
            ];
          } else if (mapData['page'] == '2') {
            await Future.delayed(const Duration(seconds: 5));
            return [
              {'value': '123451', 'text': 'equipment4'},
              {'value': '541213', 'text': 'equipment5'},
              {'value': '123146', 'text': 'equipment6'},
            ];
          } else if (mapData['page'] == '1' &&
              mapData['q'].toString().isNotEmpty) {
            await Future.delayed(const Duration(seconds: 5));
            return [
              {'value': '121345', 'text': 'equipment7'},
              {'value': '5411123', 'text': 'equipment8'},
              {'value': '123416', 'text': 'equipment9'},
            ];
          } else {
            await Future.delayed(const Duration(seconds: 5));
            return [
              {'value': '132345', 'text': 'equipment10'},
              {'value': '154123', 'text': 'equipment11'},
              {'value': '212346', 'text': 'equipment12'},
            ];
          }
        },
        attachmentSave: (data) async {
          await Future.delayed(const Duration(seconds: 5));
          return [
            {
              'id': Rand.Random().nextDouble() * 10000,
              'file':
                  'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
              'thumbnail':
                  'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
              'name': '300.jpg',
            },
            // {
            //   'id': Rand.Random().nextDouble() * 10000,
            //   'file':
            //       'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            //   'thumbnail':
            //       'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            //   'name': '301.jpg',
            // },
            // {
            //   'id': Rand.Random().nextDouble() * 10000,
            //   'file':
            //       'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            //   'thumbnail':
            //       'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
            //   'name': '302.jpg',
            // },
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
      ),
    );
  }
}
