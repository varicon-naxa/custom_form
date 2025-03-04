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
              var valueAns = childKey.currentState?.formValue.savedValue;

              if (valueAns == null) {
                // return false;
                onBackPressed(false);
              } else {
                List<bool> isStructuredDataFilled =
                    valueAns.entries.map((entry) {
                  if (entry.value is List) {
                    if (entry.value is List<List>) {
                      return false;
                    } else {
                      if (entry.value is List && entry.value.isEmpty) {
                        return false;
                      } else {
                        return true;
                      }
                    }
                  } else {
                    if (entry.value is Map) {
                      if (entry.value.isEmpty) {
                        return false;
                      } else {
                        return true;
                      }
                    } else if (entry.value is String) {
                      if (entry.value.isEmpty ||
                          entry.value == "null" ||
                          entry.value == null) {
                        return false;
                      } else {
                        return true;
                      }
                    } else {
                      return false;
                    }
                  }
                }).toList();
                bool data =
                    isStructuredDataFilled.contains(true) ? true : false;
                onBackPressed(data);
              }
            },
          )),
      // understand this full code and have a condition in here where if the form is filled but bot saved and back button is pressed then alert dialog should appear

      body: VariconFormBuilder(
        key: childKey,
        padding: const EdgeInsets.all(12.0),
        buttonText: 'SUBMIT',
        isCarousel: false,
        surveyForm: widget.form,
        hasGeolocation: true,
        hasAutoSave: true,
        autoSave: (formValue) {
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
        },
        separatorBuilder: () => const SizedBox(height: 10),
        onSubmit: (formValue) {
          Map<String, dynamic> data = widget.formData;
          List<Map<String, dynamic>> elements =
              List<Map<String, dynamic>>.from(data['elements']);

          final valueList = elements.map((e) {
            if (e['type'] == 'table' || e['type'] == 'advtable') {
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
          log('after' + jsonEncode(valueList).toString());
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
        customPainter: (data) {
          return Container();
        },
        locationData: '',
      ),
    );
  }
}
