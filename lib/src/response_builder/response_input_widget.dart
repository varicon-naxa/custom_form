import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_checkbox_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_instruction_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_other_radio_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_radio_field.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../custom_element/date_time_form_field.dart';
import '../models/value_text.dart';
import '../widget/custom_location.dart';
import '../widget/expandable_widget.dart';
import '../widget/label_widget.dart';
import '../widget/table_expandable_header_widget.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        return DateFormat('dd/MM/yyyy').format(value);
      case DatePickerType.time:
        return DateFormat(DateFormat.HOUR_MINUTE).format(value);
      case DatePickerType.dateTime:
        return '${DateFormat('dd/MM/yyyy').format(value)}, ${DateFormat(DateFormat.HOUR_MINUTE).format(value)}';
    }
  }

  ///builds all forem input field
  Widget _buildInputField(InputField e, {bool haslabel = true}) {
    final labelText = haslabel ? '${e.label ?? ''} ' : '';
    return e.maybeMap(
      table: (field) {
        return LabelWidget(
            labelText: labelText,
            isRequired: e.isRequired,
            child:
                // field.isRow
                //     ?
                ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: field.inputFields?.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ExpandableWidget(
                    initialExpanded: true,
                    expandableHeader: TableExpandableHeaderWidget(
                      index: index,
                    ),
                    expandedHeader: TableExpandableHeaderWidget(
                      index: index,
                      isExpanded: true,
                    ),
                    expandableChild: Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        children: (field.inputFields ?? [])[index]
                            .map<Widget>((item) {
                          return Container(
                              width: double.infinity,
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
            // : Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       for (int columnIndex = 0;
            //           columnIndex < (field.inputFields?.length ?? 0);
            //           columnIndex++)
            //         Container(
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             color: const Color(0xffF5F5F5),
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           padding: const EdgeInsets.all(8),
            //           margin: const EdgeInsets.only(bottom: 12),
            //           child: ExpandableWidget(
            //             initialExpanded: true,
            //             expandableHeader: Row(
            //               children: [
            //                 Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         'Column ${columnIndex + 1} ',
            //                       ),
            //                       Text(
            //                         '${field.headers?[columnIndex]}',
            //                         maxLines: 1,
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .bodyMedium
            //                             ?.copyWith(
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 const Icon(Icons.keyboard_arrow_up)
            //               ],
            //             ),
            //             expandedHeader: Padding(
            //               padding: const EdgeInsets.only(
            //                 bottom: 8,
            //               ),
            //               child: Row(
            //                 children: [
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment:
            //                           CrossAxisAlignment.start,
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Column ${columnIndex + 1} ',
            //                         ),
            //                         Text(
            //                           '${field.headers?[columnIndex]}',
            //                           // maxLines: 2,
            //                           style: Theme.of(context)
            //                               .textTheme
            //                               .bodyMedium
            //                               ?.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   const Icon(Icons.keyboard_arrow_down)
            //                 ],
            //               ),
            //             ),
            //             expandableChild: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: (field.inputFields ?? [])
            //                   .asMap()
            //                   .entries
            //                   .map((entry) {
            //                 final row = entry.value;
            //                 return Container(
            //                     width: double.infinity,
            //                     padding: const EdgeInsets.symmetric(
            //                       horizontal: 8,
            //                     ),
            //                     child: _buildInputField(row[columnIndex],
            //                         haslabel: false));
            //               }).toList(),
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),

            );
      },
      advtable: (field) {
        return LabelWidget(
            labelText: labelText,
            isRequired: e.isRequired,
            child:
                // field.isRow
                //     ?
                ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: field.inputFields?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ExpandableWidget(
                    initialExpanded: true,
                    expandableHeader: TableExpandableHeaderWidget(
                      index: index,
                    ),
                    expandedHeader: TableExpandableHeaderWidget(
                      index: index,
                      isExpanded: true,
                    ),
                    expandableChild: Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        children: (field.inputFields ?? [])[index]
                            .map<Widget>((item) {
                          return Container(
                              width: double.infinity,
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
            // : Column(
            //     children: [
            //       for (int columnIndex = 0;
            //           columnIndex < (field.inputFields?.length ?? 0);
            //           columnIndex++)
            //         Container(
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             color: const Color(0xffF5F5F5),
            //             borderRadius: BorderRadius.circular(8.0),
            //           ),
            //           padding: const EdgeInsets.all(8),
            //           margin: const EdgeInsets.only(bottom: 12),
            //           child: ExpandableWidget(
            //             initialExpanded: true,
            //             expandableHeader: Row(
            //               children: [
            //                 Text(
            //                   'Column ${columnIndex + 1} (${field.inputFields?[columnIndex].length} Questions)',
            //                 ),
            //                 const Spacer(),
            //                 const Icon(Icons.keyboard_arrow_down)
            //               ],
            //             ),
            //             expandedHeader: Padding(
            //               padding: const EdgeInsets.only(
            //                 bottom: 8,
            //               ),
            //               child: Row(
            //                 children: [
            //                   Text(
            //                     'Column ${columnIndex + 1} (${field.inputFields?[columnIndex].length} Questions)',
            //                   ),
            //                   const Spacer(),
            //                   const Icon(Icons.keyboard_arrow_up)
            //                 ],
            //               ),
            //             ),
            //             expandableChild: Column(
            //               children: (field.inputFields ?? [])
            //                   .asMap()
            //                   .entries
            //                   .map((entry) {
            //                 final row = entry.value;
            //                 return Container(
            //                     width: double.infinity,
            //                     padding: const EdgeInsets.symmetric(
            //                       horizontal: 8,
            //                     ),
            //                     child: _buildInputField(row[columnIndex],
            //                         haslabel: true));
            //               }).toList(),
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),

            );
      },
      text: (field) {
        return LabelWidget(
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
        return LabelWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: _AnswerDesign(
            answer: field.answer ?? '',
          ),
        );
      },
      number: (field) {
        return LabelWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: _AnswerDesign(
            answer: field.answer ?? '',
          ),
        );
      },
      email: (field) {
        return LabelWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: _AnswerDesign(
            answer: field.answer ?? '',
          ),
        );
      },
      url: (field) {
        return LabelWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: _AnswerDesign(
            answer: field.answer ?? '',
          ),
        );
      },
      map: (field) {
        return LabelWidget(
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
        return LabelWidget(
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
        return LabelWidget(
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
        return LabelWidget(
          labelText: labelText,
          isRequired: e.isRequired,
          child: _AnswerDesign(
            answer: getFormattedText(
                _parseToDateTime(field.answer ?? '', DatePickerType.dateTime),
                DatePickerType.dateTime),
          ),
        );
      },
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

        return LabelWidget(
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
        return LabelWidget(
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
          child: LabelWidget(
            labelText: labelText,
            isRequired: e.isRequired,
            child: VariconYesNoNaRadioField(
              field: field,
              labelText: labelText,
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
          child: LabelWidget(
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

        List<String> answers = field.answerList.toString().split(',');
        answers.map((e) {
          valueAnswer.add(
              ValueText(value: DateTime.now().microsecond.toString(), text: e));
        }).toList();

        return IgnorePointer(
          ignoring: true,
          child: LabelWidget(
            labelText: labelText,
            isRequired: e.isRequired,
            child: VariconCheckboxField(
              field: field,
              isResponse: true,
              labelText: labelText,
            ),
          ),
        );
      },
      radiogroup: (field) {
        return IgnorePointer(
          ignoring: true,
          child: LabelWidget(
            labelText: labelText,
            isRequired: e.isRequired,
            child: VariconRadioField(
              field: field,
              isResponse: true,
              labelText: labelText,
            ),
          ),
        );
      },
      files: (field) {
        List<Map<String, dynamic>> answer = e.answer == null
            ? []
            : (e.answer ?? []) as List<Map<String, dynamic>>;
        return LabelWidget(
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

        return LabelWidget(
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
            ? LabelWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnswerDesign(
                      answer: answer['file'],
                      isSignature: true,
                      imageBuild: widget.imageBuild,
                      isImage: true,
                    ),
                    if (answer['created_at'] != null &&
                        answer['created_at'].isNotEmpty)
                      Text(
                        'Signed On: ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(answer['created_at'].toString()))}',
                      ),
                  ],
                ),
              )
            : LabelWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: _AnswerDesign(
                  answer: '',
                ),
              );
      },
      instruction: (field) {
        return LabelWidget(
            labelText: e.label,
            isRequired: e.isRequired,
            child: VariconInstructionField(
              onTap: (String url) {
                widget.fileClick(
                  {'data': url, 'title': ''},
                );
              },
              field: field,
              imageBuild: widget.imageBuild,
              labelText: e.label ?? '',
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
              const SizedBox(
                height: 8,
              ),
              (field.description ?? '').isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      field.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xff6A737B),
                          ),
                    ),
              const SizedBox(
                height: 8,
              ),
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
            : LabelWidget(
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
        return LabelWidget(
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
                    'height': isSignature ? 100.0 : 120.0,
                    'width': isSignature ? 100.0 : 150.0,
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
                        color: Colors.grey),
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
            IconButton(
              onPressed: () {},
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
            String dateFormat = e.createdAt == null
                ? ''
                : DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(e.createdAt!));
            String dateText = dateFormat.isEmpty ? '' : ' on $dateFormat';
            String signatoryNameDetail =
                'Signed By ${e.signatoryName} $dateText';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBuild != null
                    ? imageBuild!({
                        'image': e.file ?? '',
                        'height': 75.0,
                        'width': 75.0,
                      })
                    : CachedNetworkImage(
                        imageUrl: e.file ?? '',
                        height: 75,
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
                  signatoryNameDetail,
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
