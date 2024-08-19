import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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

///Main container for the respose form builder
class ResponseFormBuilder extends StatefulWidget {
  const ResponseFormBuilder({
    super.key,
    required this.surveyForm,
    required this.hasGeolocation,
    required this.imageBuild,
    required this.fileClick,
    required this.timesheetClick,
  });

  ///Survey page form model
  ///
  ///Contains forms metadata
  ///
  ///Contains forms various input fields
  final SurveyPageForm surveyForm;

  ///Check if a form has geolocation
  ///
  ///If true, it will capture the approximate location from where the form is being submitted
  final bool hasGeolocation;

  ///Used to store image paths and file paths
  ///
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final Function(Map<String, dynamic> url) fileClick;

  /// Function to handle Timesheet id click
  ///
  ///  Redirect to timesheet detail page
  final Function(String) timesheetClick;

  @override
  State<ResponseFormBuilder> createState() => _ResponseFormBuilderState();
}

class _ResponseFormBuilderState extends State<ResponseFormBuilder> {
  int questionNumber = 0;

  ///Values to be submitted via forms
  final formValue = FormValue();

  ///initializing the state
  @override
  void initState() {
    super.initState();
  }

  ///Dispose resources
  @override
  void dispose() {
    super.dispose();
  }

  ///method to get device screen type
  bool get isTablet {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide =
        firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
    return logicalShortestSide > 600;
  }

  ///Method that takes date picker type
  ///
  ///and returns the date time value
  ///
  ///[value] is the value to be parsed
  static DateTime? _parseToDateTime(dynamic value, DatePickerType pickerType) {
    if (value is! String) {
      return null;
    } else if (value.isEmpty) {
      return null;
    }

    ///switch case to handle date types and return parsed values
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

  ///Returns formatted date time
  ///
  ///in comparision to date type
  ///
  ///and return formatted string value
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
    ///Track total form question counts
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
                Row(
                  children: [
                    Text('Submission ID:',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(widget.surveyForm.submissionNumber ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black)),
                    const VerticalDivider(),
                    Text('Form ID:',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(widget.surveyForm.formNumber ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black)),
                  ],
                ),
                Text(
                  widget.surveyForm.title.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        height: 1.2,
                      ),
                ),
                AppSpacing.sizedBoxH_08(),
                Text(
                  widget.surveyForm.description.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xff6A737B),
                      ),
                ),
                AppSpacing.sizedBoxH_08(),
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
                if ((widget.surveyForm.submittedBy ?? '').isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Submitted by',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        widget.surveyForm.submittedBy ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.createdAt != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Submitted on',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy, h:mm a').format(
                          (widget.surveyForm.createdAt ?? DateTime.now()),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.timesheet != null)
                  InkWell(
                    onTap: () {
                      widget.timesheetClick(widget.surveyForm.timesheet ?? '');
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Timesheet ID',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xff212529),
                                ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            widget.surveyForm.timesheetNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.surveyForm.equipment != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Equipment',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Text(
                        widget.surveyForm.equipmentName ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.project != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Project',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.surveyForm.jobNumber ??
                              widget.surveyForm.project ??
                              '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff6A737B),
                                  ),
                        ),
                      ),
                    ],
                  ),
                if (widget.surveyForm.updatedBy != null) ...[
                  const Divider(),
                  RichText(
                    text: TextSpan(
                      text: 'Last Edited ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                            text: 'by ${widget.surveyForm.updatedBy} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'on ${DateFormat('dd/MM/yyyy, h:mm a').format(
                          widget.surveyForm.updatedAt ?? DateTime.now(),
                        )}.'),
                      ],
                    ),
                  ),
                ],
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
                          child: (field.name ?? '')
                                  .toLowerCase()
                                  .contains('long')
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (field.answer ?? '').isEmpty
                                        ? const Text(
                                            'No Response',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          )
                                        : HtmlWidget(
                                            field.answer ?? '',
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
                                )
                              : _AnswerDesign(
                                  answer: field.answer ?? '',
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
                      map: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: (field.answer ?? '').contains('address')
                              ? _AnswerMapDesign(
                                  answer: field.answer ?? '',
                                )
                              : _AnswerDesign(
                                  answer: '',
                                ),
                        );
                      },
                      date: (field) {
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: getFormattedText(
                                _parseToDateTime(
                                    field.answer ?? '', DatePickerType.date),
                                DatePickerType.date),
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
                        if (field.answerList != null &&
                            field.answerList != '') {
                          answerText = field.answerList ?? '';
                        } else if (e.answer != null && e.answer != '') {
                          bool containsId =
                              field.choices.any((obj) => obj.value == e.answer);

                          if (containsId) {
                            ValueText? foundObject = field.choices.firstWhere(
                              (obj) => obj.value == e.answer,
                            );
                            answerText = foundObject.text;
                          } else {
                            answerText = (field.answerList ?? '');
                          }
                        }

                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: answerText,
                          ),
                        );
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
                        return LabeledWidget(
                          labelText: labelText,
                          isRequired: e.isRequired,
                          child: _AnswerDesign(
                            answer: answerText,
                          ),
                        );
                      },

                      yesnona: (field) {
                        return IgnorePointer(
                          ignoring: true,
                          child: LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: YesNoNaInputWidget(
                              field: field,
                              formValue: formValue,
                              labelText: labelText,
                              fieldKey: GlobalKey(),
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
                                    formValue: formValue,
                                    labelText: labelText,
                                    fieldKey: GlobalKey(),
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
                              formValue: formValue,
                              labelText: labelText,
                              fieldKey: GlobalKey(),
                            ),
                          ),
                        );
                      },
                      files: (field) {
                        List<Map<String, dynamic>> answer = e.answer == null
                            ? []
                            : (e.answer ?? []) as List<Map<String, dynamic>>;
                        return LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: answer.isNotEmpty
                                ? Wrap(
                                    runSpacing: 8,
                                    children: answer
                                        .map(
                                          (e) => _AnswerDesign(
                                            answer: e['name'],
                                            isFile: true,
                                            isImage: false,
                                            fileClick: () {
                                              widget.fileClick({
                                                'data': e['file'],
                                                'title': e['name']
                                              });
                                            },
                                          ),
                                        )
                                        .toList(),
                                  )
                                : _AnswerDesign(
                                    answer: '',
                                  ));
                      },
                      images: (field) {
                        List<Map<String, dynamic>> answer = e.answer == null
                            ? []
                            : (e.answer ?? []) as List<Map<String, dynamic>>;

                        return LabeledWidget(
                            labelText: labelText,
                            isRequired: e.isRequired,
                            child: answer.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isTablet ? 5 : 3,
                                      mainAxisSpacing: 6,
                                      crossAxisSpacing: 6,
                                      childAspectRatio: 0.87,
                                    ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: answer.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 120,
                                        width: 120,
                                        child: _AnswerDesign(
                                          answer: answer[index]['file'],
                                          isImage: true,
                                          imageBuild: widget.imageBuild,
                                        ),
                                      );
                                    })
                                // Wrap(
                                //     spacing: 8,
                                //     runSpacing: 8,
                                //     children: answer
                                //         .map(
                                //           (e) => _AnswerDesign(
                                //             answer: e['file'],
                                //             isImage: true,
                                //             containsLine: false,
                                //             imageBuild: widget.imageBuild,
                                //           ),
                                //         )
                                //         .toList(),

                                //     // _queueManager.getProcessedWidgets(),
                                //   )
                                : _AnswerDesign(
                                    answer: '',
                                  ));
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
                            : LabeledWidget(
                                labelText: labelText,
                                isRequired: e.isRequired,
                                child: _AnswerDesign(
                                  answer: '',
                                ),
                              );
                      },
                      instruction: (field) {
                        return LabeledWidget(
                            labelText: e.label,
                            isRequired: e.isRequired,
                            child: InstructionWidget(
                              onTap: (String url) {
                                widget.fileClick(
                                  {'data': url, 'title': ''},
                                );
                              },
                              field: field,
                              imageBuild: widget.imageBuild,
                            ));
                      },

                      section: (field) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.label ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: const Color(0xff233759),
                                        height: 1.2),
                              ),
                              AppSpacing.sizedBoxH_08(),
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
                              AppSpacing.sizedBoxH_08(),
                              const Divider(
                                height: 1,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

///Widget that represents forms answer design
///
///soley for singular form items like text, titles, single image,files
class _AnswerDesign extends StatelessWidget {
  _AnswerDesign({
    required this.answer,
    this.isImage = false,
    this.isSignature = false,
    this.imageBuild,
    this.fileClick,
    this.isFile = false,
  });

  ///String values for text, image urls, files content
  final String answer;

  ///Function for image/signature builder
  final Widget Function(Map<String, dynamic>)? imageBuild;

  ///Function to handle file cliks action
  final Function? fileClick;

  ///Checking for image
  bool isImage;

  ///Checking for file
  bool isFile;

  ///Checking for signature
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
                    'height': 120.0,
                    'width': isSignature ? 200.0 : 120,
                  })
                : CachedNetworkImage(
                    imageUrl: answer,
                    height: isSignature ? 150 : 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholderFadeInDuration: const Duration(seconds: 1),
                    placeholder: (context, url) => const Icon(Icons.image),
                    errorWidget: (context, error, stackTrace) => const SizedBox(
                      height: 75,
                      child: Icon(
                        Icons.image,
                        size: 40,
                      ),
                    ),
                  )
            : isFile
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      fileClick!();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                answer,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const Icon(Icons.download)
                        ],
                      ),
                    ),
                  )
                : Text(
                    answer.isEmpty ? 'No Response' : answer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: answer.isEmpty ? Colors.grey : Colors.black),
                  ),
        // if (containsLine)
        //   const DottedLine(
        //     direction: Axis.horizontal,
        //     alignment: WrapAlignment.center,
        //     lineLength: double.infinity,
        //     lineThickness: 1.0,
        //     dashLength: 4.0,
        //     dashColor: Colors.grey,
        //     dashRadius: 0.0,
        //     dashGapLength: 4.0,
        //     dashGapColor: Colors.white,
        //     dashGapRadius: 0.0,
        //   )
     
      ],
    );
  }
}

/// Widget that represent map field answer design

class _AnswerMapDesign extends StatelessWidget {
  const _AnswerMapDesign({
    required this.answer,
  });

  ///String values for text, image urls, files content
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                (answer).isEmpty ? 'No Response' : answer,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: answer.isEmpty ? Colors.grey : Colors.black),
              ),
            ),
            // if (answer.containsKey('lat') &&
            //     answer.containsKey('long') &&
            //     answer['lat'] != 0.0 &&
            //     answer['long'] != 0.0)
            IconButton(
              onPressed: () {
                ///Navigate to Simple Map Page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) {
                //       return SimpleMap(
                //         lat: answer['lat'],
                //         long: answer['long'],
                //       );
                //     },
                //   ),
                // );
              },
              icon: const Icon(
                Icons.directions,
              ),
            )
          ],
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

///Widget that represents multi-forms answer design
///
///soley for multiple form items like text, titles,image,files
class _MultiAnswerDesign extends StatelessWidget {
  const _MultiAnswerDesign({
    required this.answer,
  });

  ///Multiple string,titles,urls list
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

///Widget that represents forms signature answer design
///
///soley for multi form items signatures,images,texts
class _MultiSignatureAnswerDesign extends StatelessWidget {
  const _MultiSignatureAnswerDesign({
    required this.answer,
    this.imageBuild,
  });

  ///Multiple signature item list
  final List<SingleSignature> answer;

  ///Multiple signature image builder
  ///to view signs in image format
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
                    : CachedNetworkImage(
                        imageUrl: e.file ?? '',
                        height: 150,
                        width: double.infinity,
                        placeholderFadeInDuration: const Duration(seconds: 1),
                        placeholder: (context, url) => const Icon(Icons.image),
                        fit: BoxFit.fill,
                        errorWidget: (context, error, stackTrace) =>
                            const SizedBox(
                          height: 75,
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                      ),
                Text(
                  e.signatoryName ?? e.name ?? '',
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
