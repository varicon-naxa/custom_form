import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Rand;
import 'dart:typed_data';
import 'package:example_form/cache_manager.dart';
import 'package:example_form/custom_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

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
        List<Map<String, dynamic>> data = [
          {"id": '12345', "label": 'equipment1'},
          {"id": '54123', "label": 'equipment2'},
          {"id": '123461', "label": 'equipment3'},
          {"id": '123462', "label": 'excavator'},
          {"id": '123463', "label": 'dozer'},
          {"id": '123464', "label": 'wheel loader'},
          {"id": '123465', "label": 'grader'},
          {"id": '123466', "label": 'crane'},
          {"id": '123467', "label": 'puller'},
          {"id": '123468', "label": 'bulldozer'},
          {"id": '123469', "label": 'hydraulic excavator'},
          {"id": '1234610', "label": 'crawler excavator'},
          {"id": '1234611', "label": 'crawler dozer'},
          {"id": '1234612', "label": 'crawler wheel loader'},
          {"id": '1234613', "label": 'crawler grader'},
          {"id": '1234614', "label": 'crawler crane'},
          {"id": '1234615', "label": 'crawler puller'},
          {"id": '1234616', "label": 'crawler bulldozer'},
          {"id": '1234617', "label": 'crawler hydraulic excavator'},
          {"id": '1234618', "label": 'crawler crawler excavator'},
        ];

        if (mapData['page'] == '1' && mapData['q'].toString().isEmpty) {
          await Future.delayed(const Duration(seconds: 2));
          return data;
        } else if (mapData['page'] == '2') {
          await Future.delayed(const Duration(seconds: 2));
          return [
            {'id': '123451', 'label': 'equipment4'},
            {'id': '541213', 'label': 'equipment5'},
            {'id': '123146', 'label': 'equipment6'},
            {'id': '123147', 'label': 'equipment7'},
            {'id': '123148', 'label': 'equipment8'},
            {'id': '123149', 'label': 'equipment9'},
            {'id': '123150', 'label': 'equipment10'},
            {'id': '123151', 'label': 'equipment11'},
            {'id': '123152', 'label': 'equipment12'},
            {'id': '123153', 'label': 'equipment13'},
            {'id': '123154', 'label': 'equipment14'},
            {'id': '123155', 'label': 'equipment15'},
            {'id': '123156', 'label': 'equipment16'},
            {'id': '123157', 'label': 'equipment17'},
            {'id': '123158', 'label': 'equipment18'},
            {'id': '123159', 'label': 'equipment19'},
            {'id': '123160', 'label': 'equipment20'},
            {'id': '123161', 'label': 'equipment21'},
          ];
        } else if (mapData['page'] == '1' &&
            mapData['q'].toString().isNotEmpty) {
          await Future.delayed(const Duration(seconds: 2));
          return data.where((e) => e['label'].contains(mapData['q'])).toList();
        } else {
          await Future.delayed(const Duration(seconds: 5));
          return [
            {'id': '132345', 'label': 'equipment10'},
            {'id': '154123', 'label': 'equipment11'},
            {'id': '212346', 'label': 'equipment12'},
            {'id': '212347', 'label': 'equipment13'},
            {'id': '212348', 'label': 'equipment14'},
            {'id': '212349', 'label': 'equipment15'},
            {'id': '212350', 'label': 'equipment16'},
            {'id': '212351', 'label': 'equipment17'},
            {'id': '212352', 'label': 'equipment18'},
            {'id': '212353', 'label': 'equipment19'},
            {'id': '212354', 'label': 'equipment20'},
            {'id': '212355', 'label': 'equipment21'},
            {'id': '212356', 'label': 'equipment22'},
            {'id': '212357', 'label': 'equipment23'},
            {'id': '212358', 'label': 'equipment24'},
            {'id': '212359', 'label': 'equipment25'},
            {'id': '212360', 'label': 'equipment26'},
          ];
        }
      },
      formtitle: 'Submit Form',
      attachmentSave: (List<String> data) async {
        List<Map<String, dynamic>> _data = [];
        for (var path in data) {
          File _file = File(path);
          String _ext = _file.path.split('.').last;
          String _key = DateTime.now().millisecondsSinceEpoch.toString();
          File file = await LocalCacheManager.instance.putFile(
            _file.uri.toString(),
            _file.readAsBytesSync(),
            key: _key.toString(),
            maxAge: const Duration(days: 30),
            eTag: '1',
            fileExtension: _ext,
          );
          _data.add({
            'id': _key,
            'file': file.path,
            'name': _file.path.split('.').last,
            'created_at': DateTime.now().toIso8601String(),
          });
          log('file: ' + file.path);
        }
        return _data;
        // return [];
        // log('dpme');

        // final val =
        //     data.map((e) {
        //       final random = Rand.Random().nextDouble() * 10000;

        //       final mapdata = {
        //         'id': '${random}',
        //         'file':
        //             'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
        //         'thumbnail':
        //             'https://fastly.picsum.photos/id/654/200/300.jpg?hmac=JhhoLGzzNeSmL5tgcWbz2N4DiYmrpTPsjKCw4MeIcps',
        //         'name': '${random}.jpg',
        //         "created_at": '2025-04-11T13:13:24.784615Z',
        //       };
        //       log('mapdata: ' + jsonEncode(mapdata).toString());
        //       return mapdata;
        //     }).toList();
        // return val;
      },
      imageBuild: (Map<String, dynamic> data) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: data['image'],
            height: data['height'],
            width: data['width'],
            fit: BoxFit.cover,
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (context, url) => const Icon(Icons.image),
          ),
        );
      },
      fileClick: (Map<String, dynamic> stringURl) {},
      customPainter: (File data) {
        return CustomImageEditor(imageFile: data);
      },
      locationData: '',
      onPopPressed: () {},
    );
  }
}
