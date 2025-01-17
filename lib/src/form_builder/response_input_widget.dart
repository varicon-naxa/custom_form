import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/form_builder/form_elements.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/labeled_widget.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';

import '../models/form_value.dart';
import '../models/value_text.dart';
import 'form_fields/date_time_form_field.dart';
import 'widgets/checkbox_input_widget.dart';
import 'widgets/custom_location.dart';
import 'widgets/expandable_widget.dart';
import 'widgets/instruction_widget.dart';
import 'widgets/radio_input_widget.dart';
import 'widgets/yes_no_na_input_widget.dart';

class ResponseInputWidget extends StatefulWidget {
  const ResponseInputWidget({
    super.key,
    required this.surveyForm,
    required this.hasGeolocation,
    required this.imageBuild,
    required this.fileClick,
    required this.timesheetClick,
  });

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
  State<ResponseInputWidget> createState() => _ResponseInputWidgetState();
}

class _ResponseInputWidgetState extends State<ResponseInputWidget> {
  ///Values to be submitted via forms
  final formValue = FormValue();

  ///method to get device screen type
  bool get isTablet {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide =
        firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
    return logicalShortestSide > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.surveyForm.inputFields
          .map<Widget?>((e) => _buildInputField(
                e,
              ))
          .whereType<Widget>()
          .toList(),
    );
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

  ///builds all forem input field
  Widget _buildInputField(InputField e, {bool haslabel = true}) {
    final labelText = haslabel ? '${e.label ?? ''} ' : '';
    return e.maybeMap(
      table: (field) {
        return LabeledWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: field.isRow
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: field.inputFields?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ExpandableWidget(
                        initialExpanded: true,
                        expandableHeader: TableExpandableHeaderWidget(
                          index: index,
                          field: field,
                        ),
                        expandedHeader: TableExpandableHeaderWidget(
                          index: index,
                          field: field,
                          isExpanded: true,
                        ),
                        expandableChild: Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            children: (field.inputFields ?? [])[index]
                                .map<Widget>((item) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: _buildInputField(item));
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    for (int columnIndex = 0;
                        columnIndex < (field.inputFields?.length ?? 0);
                        columnIndex++)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpandableWidget(
                          initialExpanded: true,
                          expandableHeader: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Column ${columnIndex + 1} ',
                                    ),
                                    Text(
                                      '${field.headers?[columnIndex]}',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_up)
                            ],
                          ),
                          expandedHeader: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Column ${columnIndex + 1} ',
                                      ),
                                      Text(
                                        '${field.headers?[columnIndex]}',
                                        // maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                          expandableChild: Column(
                            children: (field.inputFields ?? [])
                                .asMap()
                                .entries
                                .map((entry) {
                              final row = entry.value;
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: _buildInputField(row[columnIndex],
                                      haslabel: false));
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),

          //  TableInputWidget(
          //   field: field,
          //   fieldKey: _formFieldKeys[field.id],
          //   formValue: formValue,
          //   labelText: labelText,
          // ),
        );
      },
      advtable: (field) {
        return LabeledWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: field.isRow
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: field.inputFields?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ExpandableWidget(
                        initialExpanded: true,
                        expandableHeader: TableExpandableHeaderWidget(
                          index: index,
                          field: field,
                        ),
                        expandedHeader: TableExpandableHeaderWidget(
                          index: index,
                          field: field,
                          isExpanded: true,
                        ),
                        expandableChild: Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            children: (field.inputFields ?? [])[index]
                                .map<Widget>((item) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: _buildInputField(item));
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    for (int columnIndex = 0;
                        columnIndex < (field.inputFields?.length ?? 0);
                        columnIndex++)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpandableWidget(
                          initialExpanded: true,
                          expandableHeader: Row(
                            children: [
                              Text(
                                'Column ${columnIndex + 1} (${field.inputFields?[columnIndex].length} Questions)',
                              ),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                          expandedHeader: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Column ${columnIndex + 1} (${field.inputFields?[columnIndex].length} Questions)',
                                ),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_up)
                              ],
                            ),
                          ),
                          expandableChild: Column(
                            children: (field.inputFields ?? [])
                                .asMap()
                                .entries
                                .map((entry) {
                              final row = entry.value;
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: _buildInputField(row[columnIndex],
                                      haslabel: true));
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
      text: (field) {
        return LabeledWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: (field.name ?? '').toLowerCase().contains('long')
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
                _parseToDateTime(field.answer ?? '', DatePickerType.date),
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
                _parseToDateTime(field.answer ?? '', DatePickerType.time),
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
                _parseToDateTime(field.answer ?? '', DatePickerType.dateTime),
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
        if (field.answerList != null && field.answerList != '') {
          answerText = field.answerList ?? '';
        } else if (e.answer != null && e.answer != '') {
          bool containsId = field.choices.any((obj) => obj.value == e.answer);

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
          bool containsId = field.choices.any((obj) => obj.value == e.answer);

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
          List<String> answers = field.answerList.toString().split(',');
          answers.map((e) {
            valueAnswer.add(ValueText(
                value: DateTime.now().microsecond.toString(), text: e));
          }).toList();
        } else {
          if (e.answer != null && e.answer != '') {
            List<String> answers = e.answer.toString().split(',');
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
          List<String> answers = field.answerList.toString().split(',');
          answers.map((e) {
            valueAnswer.add(ValueText(
                value: DateTime.now().microsecond.toString(), text: e));
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
                              widget.fileClick(
                                  {'data': e['file'], 'title': e['name']});
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 5 : 3,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.75,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: answer.length,
                    itemBuilder: (context, index) {
                      return _AnswerDesign(
                        answer: answer[index]['file'],
                        isImage: true,
                        imageBuild: widget.imageBuild,
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
        return (answer.containsKey('id') && answer.containsKey('file'))
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
                    ?.copyWith(color: const Color(0xff233759), height: 1.2),
              ),
              AppSpacing.sizedBoxH_08(),
              (field.description ?? '').isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      field.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              );
      },

      multisignature: (field) {
        return LabeledWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: (field.answer != null && (field.answer ?? []).isNotEmpty)
              ? _MultiSignatureAnswerDesign(
                  answer: field.answer ?? [],
                  imageBuild: widget.imageBuild,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Signature',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

      orElse: () => Container(),
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
                    'width': isSignature ? 200.0 : 150.0,
                  })
                : CachedNetworkImage(
                    imageUrl: answer,
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
