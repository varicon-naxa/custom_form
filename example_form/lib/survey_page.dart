import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Rand;
import 'dart:typed_data';
import 'package:example_form/cache_manager.dart';
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
      customPainter: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Image Editor'),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  // return image;
                  Navigator.pop(
                    context,
                    Uint8List.fromList(
                      ('137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,2,208,0,0,5,0,8,6,0,0,0,110,206,101,61,0,0,0,1,115,82,71,66,0,174,206,28,233,0,0,0,4,115,66,73,84,8,8,8,8,124,8,100,136,0,0,32,0,73,68,65,84,120,156,236,221,205,118,27,77,146,230,249,199,204,35,64,74,202,156,58,61,167,247,189,236,77,94,208,204,106,250,156,222,204,45,204,186,110,117,214,221,61,85,89,175,4,68,184,217,44,220,3,8,240,59,8,73,16,200,255,47,15,211,249,9,2,17,193,87,15,28,230,230,246,127,254,215,255,35,5,0,0,0,224,77,6,119,191,246,125,0,0,0,0,110,198,80,74,185,246,125,0,0,0,0,110,6,1,26,0,0,0,216,96,48,179,107,223,7,0,0,0,224,102,12,153,172,33,4,0,0,0,222,138,0,13,0,0,0,108,48,68,196,181,239,3,0,0,0,112,51,88,68,8,0,0,0,108,64,19,104,0,0,0,96,3,2,52,0,0,0,176,1,1,26,0,0,0,216,128,0,13,0,0,0,108,64,128,6,0,0,0,54,32,64,3,0,0,0,27,16,160,1,0,0,128,13,8,208,0,0,0,192,6,4,104,0,0,0,96,3,2,52,0,0,0,176,1,1,26,0,0,0,216,128,0,13,0,0,0,108,64,128,6,0,0,0,54,32,64,3,0,0,0,27,16,160,1,0,0,128,13,8,208,0,0,0,192,6,4,104,0,0,0,96,3,2,52,0,0,0,176,1,1,26,0,0,0,216,128,0,13,0,0,0,108,64,128,6,0,0,0,54,32,64,3,0,0,0,27,12,36,104,0,0,0,224,237,6,203,107,223,5,0,0,0,224,118,12,78,128,6,0,0,0,222,140,10,14,0,0,0,96,3,2,52,0,0,0,176,1,1,26,0,0,0'
                          .split(',')).map((e) => int.parse(e)).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(),
        );
      },
      locationData: '',
      onPopPressed: () {},
    );
  }
}
