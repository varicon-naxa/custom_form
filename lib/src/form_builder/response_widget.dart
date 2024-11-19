import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:varicon_form_builder/src/form_builder/utils.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/expandable_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/instruction_widget.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../models/value_text.dart';
import 'form_fields/date_time_form_field.dart';
import 'widgets/checkbox_input_widget.dart';
import 'widgets/custom_location.dart';
import 'widgets/labeled_widget.dart';
import 'widgets/radio_input_widget.dart';
import 'widgets/yes_no_na_input_widget.dart';

class ResponseWidget extends StatelessWidget {
  ResponseWidget({
    super.key,
    required this.inputFields,
    required this.imageBuild,
    required this.hasGeolocation,
    required this.isTablet,
    required this.fileClick,
    required this.formValue,
  });
  final List<InputField> inputFields;

  ///Used to store image paths and file paths
  ///
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final Function(Map<String, dynamic> url) fileClick;
  final bool hasGeolocation;
  final bool isTablet;
  FormValue formValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: inputFields
          .map<Widget?>((e) {
            /// Heading of each input field
            // if (!(e is InstructionInputField ||
            //     e is SectionInputField)) {
            //   questionNumber++;
            // }
            final labelText = '${e.label ?? ''} ';
            return e.maybeMap(
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
                      : AnswerDesign(
                          answer: field.answer ?? '',
                        ),
                );
              },
              phone: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: field.answer ?? '',
                  ),
                );
              },
              number: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: field.answer ?? '',
                  ),
                );
              },
              email: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: field.answer ?? '',
                  ),
                );
              },
              url: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: field.answer ?? '',
                  ),
                );
              },
              map: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: (field.answer ?? '').contains('address')
                      ? AnswerMapDesign(
                          answer: field.answer ?? '',
                        )
                      : AnswerDesign(
                          answer: '',
                        ),
                );
              },
              date: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: Utils.getFormattedText(
                        Utils.parseToDateTime(
                            field.answer ?? '', DatePickerType.date),
                        DatePickerType.date),
                  ),
                );
              },
              time: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: Utils.getFormattedText(
                        Utils.parseToDateTime(
                            field.answer ?? '', DatePickerType.time),
                        DatePickerType.time),
                  ),
                );
              },
              datetimelocal: (field) {
                return LabeledWidget(
                  labelText: labelText,
                  isRequired: e.isRequired,
                  child: AnswerDesign(
                    answer: Utils.getFormattedText(
                        Utils.parseToDateTime(
                            field.answer ?? '', DatePickerType.dateTime),
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
                  child: AnswerDesign(
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
                  child: AnswerDesign(
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
                        ? AnswerDesign(answer: '')
                        : MultiAnswerDesign(answer: valueAnswer),
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
                        ? MultiAnswerDesign(answer: valueAnswer)
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
                                  (e) => AnswerDesign(
                                    answer: e['name'],
                                    isFile: true,
                                    isImage: false,
                                    fileClick: () {
                                      fileClick({
                                        'data': e['file'],
                                        'title': e['name']
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          )
                        : AnswerDesign(
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: answer.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 120,
                                width: 120,
                                child: AnswerDesign(
                                  answer: answer[index]['file'],
                                  isImage: true,
                                  imageBuild: imageBuild,
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
                        : AnswerDesign(
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
                        child: AnswerDesign(
                          answer: answer['file'],
                          isSignature: true,
                          imageBuild: imageBuild,
                          isImage: true,
                        ),
                      )
                    : LabeledWidget(
                        labelText: labelText,
                        isRequired: e.isRequired,
                        child: AnswerDesign(
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
                        fileClick(
                          {'data': url, 'title': ''},
                        );
                      },
                      field: field,
                      imageBuild: imageBuild,
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color(0xff233759), height: 1.2),
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
                return (hasGeolocation && field.answer == null)
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
                  child:
                      (field.answer != null && (field.answer ?? []).isNotEmpty)
                          ? MultiSignatureAnswerDesign(
                              answer: field.answer ?? [],
                              imageBuild: imageBuild,
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
              table: (field) {
                return LabeledWidget(
                    labelText: labelText,
                    isRequired: e.isRequired,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // field.isRow
                        //     ?
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: field.inputFields?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ExpandableWidget(
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
                                  child: ResponseWidget(
                                    inputFields:
                                        field.inputFields?[index] ?? [],
                                    imageBuild: imageBuild,
                                    hasGeolocation: hasGeolocation,
                                    isTablet: isTablet,
                                    fileClick: fileClick,
                                    formValue: formValue,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                        // : Column(
                        //     children: [
                        //       for (int columnIndex = 0;
                        //           columnIndex <
                        //               modifiedInputField[0].length;
                        //           columnIndex++)
                        //         Container(
                        //           decoration: BoxDecoration(
                        //             color: const Color(0xffF5F5F5),
                        //             borderRadius:
                        //                 BorderRadius.circular(8.0),
                        //           ),
                        //           padding: const EdgeInsets.all(8),
                        //           margin: const EdgeInsets.only(bottom: 12),
                        //           child: ExpandableWidget(
                        //             initialExpanded: true,
                        //             expandableHeader: Row(
                        //               children: [
                        //                 Text(
                        //                   'Column ${columnIndex + 1} ',
                        //                 ),
                        //                 const Spacer(),
                        //                 const Icon(Icons.keyboard_arrow_up)
                        //               ],
                        //             ),
                        //             expandedHeader: Padding(
                        //               padding: const EdgeInsets.only(
                        //                 bottom: 8,
                        //               ),
                        //               child: Row(
                        //                 children: [
                        //                   Text(
                        //                     'Column ${columnIndex + 1}',
                        //                   ),
                        //                   const Spacer(),
                        //                   const Icon(
                        //                       Icons.keyboard_arrow_down)
                        //                 ],
                        //               ),
                        //             ),
                        //             expandableChild: Column(
                        //               children: modifiedInputField
                        //                   .asMap()
                        //                   .entries
                        //                   .map((entry) {
                        //                 final rowIndex = entry.key;
                        //                 final row = entry.value;
                        //                 if (rowIndex >=
                        //                         visibleRows.length ||
                        //                     !visibleRows[rowIndex]) {
                        //                   return const SizedBox.shrink();
                        //                 }
                        //                 return Padding(
                        //                   padding:
                        //                       const EdgeInsets.symmetric(
                        //                     horizontal: 8,
                        //                   ),
                        //                   child: _buildInputField(
                        //                           row[columnIndex], context,
                        //                           haslabel:
                        //                               rowIndex <= 0) ??
                        //                       const SizedBox.shrink(),
                        //                 );
                        //               }).toList(),
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                      ],
                    ));
                //  TableInputWidget(
                //   field: field,
                //   fieldKey: _formFieldKeys[field.id],
                //   formValue: formValue,
                //   labelText: labelText,
                // ),
              },

              orElse: () => null,
            );
          })
          .whereType<Widget>()
          // .separated(widget.separatorBuilder?.call())
          .toList(),
    );
  }
}
