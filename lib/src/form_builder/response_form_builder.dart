// ignore_for_file: use_build_context_synchronously
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/ext/color_extension.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/date_time_form_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/checkbox_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/instruction_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/radio_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/yes_no_na_input_widget.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import 'widgets/labeled_widget.dart';

class ResponseFormBuilder extends StatefulWidget {
  const ResponseFormBuilder({
    super.key,
    required this.surveyForm,
    required this.hasGeolocation,
    required this.imageBuild,
    required this.fileClick,
  });

  final SurveyPageForm surveyForm;
  final bool hasGeolocation;

  final Widget Function(Map<String, dynamic>) imageBuild;
  final Function(Map<String, dynamic> url) fileClick;

  @override
  State<ResponseFormBuilder> createState() => _ResponseFormBuilderState();
}

class _ResponseFormBuilderState extends State<ResponseFormBuilder> {
  int questionNumber = 0;

  final formValue = FormValue();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static DateTime? _parseToDateTime(dynamic value, DatePickerType pickerType) {
    if (value is! String) {
      return null;
    } else if (value.isEmpty) {
      return null;
    }

    switch (pickerType) {
      case DatePickerType.dateTime:
        return DateTime.parse(value);
      case DatePickerType.date:
        return DateTime.parse(value);
      case DatePickerType.time:
        final dt = value.split(':');
        final dur = Duration(
          hours: int.parse(dt.first),
          minutes: int.parse(dt.last),
        );
        return DateTime(0).add(dur);
    }
  }

  static String getFormattedText(DateTime? value, DatePickerType type) {
    if (value == null) return '';
    switch (type) {
      case DatePickerType.date:
        return DateFormat.yMd().format(value);
      case DatePickerType.time:
        return DateFormat(DateFormat.HOUR_MINUTE).format(value);
      case DatePickerType.dateTime:
        return '${DateFormat.yMd().format(value)}, ${DateFormat(DateFormat.HOUR_MINUTE).format(value)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    questionNumber = 0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.surveyForm.title.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  widget.surveyForm.description.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xff6A737B),
                      ),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xffF3F6FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Submitted On',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: const Color(0xff212529),
                            ),
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy, h:mm a').format(
                        widget.surveyForm.updatedAt ??
                            widget.surveyForm.createdAt ??
                            DateTime.now(),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xff6A737B),
                          ),
                    ),
                  ],
                ),
                if (widget.surveyForm.timesheet != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Timesheet ID',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                      Text(
                        widget.surveyForm.timesheet ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                    ],
                  ),
                const Divider(),
                RichText(
                  text: TextSpan(
                    text: 'Last Edited ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                          text: widget.surveyForm.submittedBy != null
                              ? 'by ${widget.surveyForm.submittedBy}'
                              : '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: 'on ${DateFormat('dd/MM/yyyy, h:mm a').format(
                        widget.surveyForm.updatedAt ??
                            widget.surveyForm.createdAt ??
                            DateTime.now(),
                      )}.'),
                    ],
                  ),
                ),
                AppSpacing.sizedBoxH_08(),
                if (widget.surveyForm.status != null &&
                    widget.surveyForm.status?['id'] != null)
                  Container(
                    padding: const EdgeInsets.all(4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: HexColor.fromHex(
                            widget.surveyForm.status!['color'] ?? ''),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      widget.surveyForm.status!['label'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.surveyForm.inputFields
                  .map<Widget?>((e) {
                    /// Heading of each input field
                    ///

                    if (!(e is InstructionInputField ||
                        e is SectionInputField)) {
                      questionNumber++;
                    }
                    final labelText = '$questionNumber. ${e.label ?? ''} ';

                    return e.maybeMap(
                      text: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      longtext: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: Column(
                            children: [
                              (field.answer ?? '').isEmpty
                                  ? const Text(
                                      'No Response',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Html(
                                      data: field.answer ?? '',
                                    ),
                              const DottedLine(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.grey,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.white,
                                dashGapRadius: 0.0,
                              )
                            ],
                          ),
                        );
                      },
                      phone: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      number: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      email: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      url: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      date: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: field.answer ?? '',
                          ),
                        );
                      },
                      time: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: getFormattedText(
                                _parseToDateTime(
                                    field.answer ?? '', DatePickerType.time),
                                DatePickerType.time),
                          ),
                        );
                      },
                      datetimelocal: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: getFormattedText(
                                _parseToDateTime(field.answer ?? '',
                                    DatePickerType.dateTime),
                                DatePickerType.dateTime),
                          ),
                        );
                      },
                      // comment: (field) {
                      //   return Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       LabeledWidget(
                      //         labelText: labelText,
                      //         isRequired: e.isRequired,
                      //         child: TextFormField(
                      //           initialValue: field.answer,
                      //           readOnly: field.readOnly,
                      //           style: Theme.of(context).textTheme.bodyLarge,
                      //           keyboardType: TextInputType.text,
                      //           maxLength: field.maxLength,
                      //           maxLines: 4,
                      //           onSaved: (newValue) => formValue.saveString(
                      //             field.id,
                      //             newValue,
                      //           ),
                      //           validator: (value) => textValidator(
                      //             value: value,
                      //             inputType: "comment",
                      //             isRequired: field.isRequired,
                      //             requiredErrorText: field.requiredErrorText,
                      //           ),
                      //           decoration: widget.inputDecoration.copyWith(
                      //             hintText: field.hintText,
                      //             labelText: labelText,
                      //           ),
                      //         ),
                      //       ),
                      //       AppSpacing.sizedBoxH_12(),
                      //     ],
                      //   );
                      // },
                      dropdown: (field) {
                        String answerText = '';
                        if (e.answer != null && e.answer != '') {
                          bool containsId =
                              field.choices.any((obj) => obj.value == e.answer);

                          if (containsId) {
                            ValueText? foundObject = field.choices.firstWhere(
                              (obj) => obj.value == e.answer,
                            );
                            answerText = foundObject.text;
                          }
                        }

                        return e.answer != null && e.answer != ''
                            ? Column(
                                children: [
                                  LabeledWidget(
                                    labelText: labelText,
                                    isRequired: e.isRequired,
                                    child: _AnswerDesign(
                                      answer: answerText,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink();
                      },
                      yesno: (field) {
                        String answerText = '';
                        if (e.answer != null && e.answer != '') {
                          bool containsId =
                              field.choices.any((obj) => obj.value == e.answer);

                          if (containsId) {
                            ValueText? foundObject = field.choices.firstWhere(
                              (obj) => obj.value == e.answer,
                            );
                            answerText = foundObject.text;
                          }
                        }
                        return e.answer != null && e.answer != ''
                            ? LabeledWidget(
                                labelText: labelText,
                                isRequired: e.isRequired,
                                child: _AnswerDesign(
                                  answer: answerText,
                                ),
                              )
                            : const SizedBox.shrink();
                      },

                      yesnona: (field) {
                        return IgnorePointer(
                          ignoring: true,
                          child: LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: YesNoNaInputWidget(
                              field: field,
                              formKey: Key(field.id),
                              formValue: formValue,
                              labelText: labelText,
                            ),
                          ),
                        );
                      },

                      multipleselect: (field) {
                        List<ValueText> valueAnswer = [];

                        if (!(field.fromManualList)) {
                          List<String> answers =
                              field.answerList.toString().split(',');
                          answers.map((e) {
                            valueAnswer.add(ValueText(
                                value: DateTime.now().microsecond.toString(),
                                text: e));
                          }).toList();
                        } else {
                          if (e.answer != null && e.answer != '') {
                            List<String> answers =
                                e.answer.toString().split(',');
                            field.choices.map((e) {
                              String? data = answers.firstWhere(
                                (element) => element == e.value,
                                orElse: () {
                                  return '';
                                },
                              );
                              if (data != '') {
                                valueAnswer.add(e);
                              }
                            }).toList();
                          }
                        }

                        return IgnorePointer(
                          ignoring: true,
                          child: LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: (e.answer == null || e.answer == '')
                                ? _AnswerDesign(answer: '')
                                : _MultiAnswerDesign(answer: valueAnswer),
                          ),
                        );
                      },

                      checkbox: (field) {
                        List<ValueText> valueAnswer = [];

                        if (!(field.fromManualList)) {
                          List<String> answers =
                              field.answerList.toString().split(',');
                          answers.map((e) {
                            valueAnswer.add(ValueText(
                                value: DateTime.now().microsecond.toString(),
                                text: e));
                          }).toList();
                        }
                        return IgnorePointer(
                          ignoring: true,
                          child: LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: (!(field.fromManualList))
                                ? _MultiAnswerDesign(answer: valueAnswer)
                                : CheckboxInputWidget(
                                    field: field,
                                    formKey: Key(field.id),
                                    formValue: formValue,
                                    labelText: labelText,
                                  ),
                          ),
                        );
                      },
                      radiogroup: (field) {
                        return IgnorePointer(
                          ignoring: true,
                          child: LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: RadioInputWidget(
                              field: field,
                              formKey: Key(field.id),
                              formValue: formValue,
                              labelText: labelText,
                            ),
                          ),
                        );
                      },
                      files: (field) {
                        List<Map<String, dynamic>> answer =
                            (e.answer ?? []) as List<Map<String, dynamic>>;
                        if (answer.isNotEmpty) {
                          return LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: Wrap(
                                children: answer
                                    .map(
                                      (e) => _AnswerDesign(
                                        answer: e['name'],
                                        isFile: true,
                                        fileClick: () {
                                          widget.fileClick({
                                            'data': e['file'],
                                            'title': e['name']
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      images: (field) {
                        List<Map<String, dynamic>> answer =
                            (e.answer ?? []) as List<Map<String, dynamic>>;
                        if (answer.isNotEmpty) {
                          return LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: Column(
                                children: answer
                                    .map(
                                      (e) => _AnswerDesign(
                                        answer: e['file'],
                                        isImage: true,
                                        imageBuild: widget.imageBuild,
                                      ),
                                    )
                                    .toList(),
                              ));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      signature: (field) {
                        Map<dynamic, dynamic> answer =
                            (e.answer ?? {}) as Map<dynamic, dynamic>;
                        return (answer.containsKey('id') &&
                                answer.containsKey('file'))
                            ? LabeledWidget(
                                labelText: labelText,
                                isRequired: e.isRequired,
                                child: _AnswerDesign(
                                  answer: answer['file'],
                                  isSignature: true,
                                  imageBuild: widget.imageBuild,
                                  isImage: true,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                      instruction: (field) {
                        return LabeledWidget(
                            labelText: e.label,
                            isRequired: e.isRequired,
                            child: InstructionWidget(
                              onTap: (String url) {},
                              field: field,
                              imageBuild: widget.imageBuild,
                            ));
                      },

                      section: (field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.label ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: const Color(0xff233759)),
                              ),
                              (field.description ?? '').isEmpty
                                  ? const SizedBox.shrink()
                                  : Text(
                                      field.description ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xff6A737B),
                                          ),
                                    ),
                            ],
                          ),
                        );
                      },
                      geolocation: (field) {
                        return (widget.hasGeolocation && field.answer == null)
                            ? const SizedBox.shrink()
                            : LabeledWidget(
                                labelText: labelText,
                                isRequired: false,
                                child: (field.answer!['long'] != null)
                                    ? CustomLocation(
                                        postition: Position(
                                            longitude: field.answer!['long'],
                                            latitude: field.answer!['lat'],
                                            timestamp: DateTime.timestamp(),
                                            accuracy: 50.0,
                                            altitude: 0.0,
                                            altitudeAccuracy: 50.0,
                                            heading: 50.0,
                                            headingAccuracy: 50.0,
                                            speed: 2.0,
                                            speedAccuracy: 50.0),
                                      )
                                    : Text(
                                        'Location is disabled!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                              );
                      },

                      multisignature: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: (field.answer != null &&
                                  (field.answer ?? []).isNotEmpty)
                              ? _MultiSignatureAnswerDesign(
                                  answer: field.answer ?? [],
                                  imageBuild: widget.imageBuild,
                                )
                              : Column(
                                  children: [
                                    Text(
                                      'No Signature',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xff6A737B),
                                          ),
                                    ),
                                    const DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 1.0,
                                      dashLength: 4.0,
                                      dashColor: Colors.grey,
                                      dashRadius: 0.0,
                                      dashGapLength: 4.0,
                                      dashGapColor: Colors.white,
                                      dashGapRadius: 0.0,
                                    )
                                  ],
                                ),
                        );
                      },

                      orElse: () => null,
                    );
                  })
                  .whereType<Widget>()
                  // .separated(widget.separatorBuilder?.call())
                  .toList(),
            ),
          ),
          if (widget.hasGeolocation &&
              widget.surveyForm.setting?['location'] != null)
            LabeledWidget(
              labelText: 'Geolocation',
              isRequired: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on_outlined),
                      label: Text(
                        widget.surveyForm.setting?['location']['address'],
                        style: const TextStyle(fontSize: 16),
                      )),
                  CustomLocation(
                    postition: Position(
                        longitude: widget.surveyForm.setting?['location']
                            ['long'],
                        latitude: widget.surveyForm.setting?['location']['lat'],
                        timestamp: DateTime.timestamp(),
                        accuracy: 50.0,
                        altitude: 0.0,
                        altitudeAccuracy: 50.0,
                        heading: 50.0,
                        headingAccuracy: 50.0,
                        speed: 2.0,
                        speedAccuracy: 50.0),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _AnswerDesign extends StatelessWidget {
  _AnswerDesign({
    required this.answer,
    this.isImage = false,
    this.isSignature = false,
    this.imageBuild,
    this.fileClick,
    this.isFile = false,
  });

  final String answer;

  final Widget Function(Map<String, dynamic>)? imageBuild;
  final Function? fileClick;
  bool isImage;
  bool isFile;
  bool isSignature;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isImage
            ? imageBuild != null
                ? imageBuild!({
                    'image': answer,
                    'height': 200.0,
                    'width': isSignature ? 200.0 : double.infinity,
                  })
                : Image.network(
                    answer,
                    height: isSignature ? 150 : 200,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                      height: 75,
                      child: Icon(
                        Icons.image,
                        size: 40,
                      ),
                    ),
                  )
            : isFile
                ? GestureDetector(
                    onTap: () {
                      fileClick!();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              answer,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    answer.isEmpty ? 'No Response' : answer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: answer.isEmpty ? Colors.grey : Colors.black),
                  ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}

class _MultiAnswerDesign extends StatelessWidget {
  const _MultiAnswerDesign({
    required this.answer,
  });

  final List<ValueText> answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: answer.map((e) {
            return Text(
              e.text.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: answer.isEmpty ? Colors.grey : Colors.black,
                  ),
            );
          }).toList(),
        ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}

class _MultiSignatureAnswerDesign extends StatelessWidget {
  const _MultiSignatureAnswerDesign({
    required this.answer,
    this.imageBuild,
  });

  final List<SingleSignature> answer;
  final Widget Function(Map<String, dynamic>)? imageBuild;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: answer.map((e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBuild != null
                    ? imageBuild!({
                        'image': e.file ?? '',
                        'height': 200.0,
                        'width': 200.0,
                      })
                    : Image.network(
                        e.file ?? '',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(
                          height: 75,
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                      ),
                Text(
                  e.name ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: answer.isEmpty ? Colors.grey : Colors.black,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
        const DottedLine(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashRadius: 0.0,
          dashGapLength: 4.0,
          dashGapColor: Colors.white,
          dashGapRadius: 0.0,
        )
      ],
    );
  }
}
