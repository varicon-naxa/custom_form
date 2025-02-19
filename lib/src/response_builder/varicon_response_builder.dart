// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import '../ext/color_extension.dart';
import 'response_input_widget.dart';

///Main container for the form builder
class VariconFormBuilder extends StatelessWidget {
  const VariconFormBuilder({
    super.key,
    required this.surveyForm,
    required this.imageBuild,
    required this.fileClick,
    required this.hasGeolocation,
    required this.formtitle,
    required this.timesheetClick,
  });

  ///Survey page form model
  ///
  ///Contains forms metadata
  ///
  ///Contains forms various input fields
  final SurveyPageForm surveyForm;

  ///Used to store image paths and file paths
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions

  final Function(Map<String, dynamic> url) fileClick;


    ///Check if a form has geolocation
  ///
  ///If true, it will capture the approximate location from where the form is being submitted
  final bool hasGeolocation;

  ///Function to handle file click

  /// Function to handle Timesheet id click
  ///
  ///  Redirect to timesheet detail page
  final Function(String) timesheetClick;

  final String formtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          formtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                        Text(surveyForm.submissionNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black)),
                        const VerticalDivider(),
                        Text('Form ID:',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(surveyForm.formNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black)),
                      ],
                    ),
                    Text(
                      surveyForm.title.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if ((surveyForm.description ?? '').isNotEmpty)
                      Text(
                        surveyForm.description.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xff6A737B),
                            ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F6FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((surveyForm.submittedBy ?? '').isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Submitted by',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                            ),
                          ),
                          Text(
                            surveyForm.submittedBy ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xff6A737B),
                                ),
                          ),
                        ],
                      ),
                    if (surveyForm.createdAt != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Submitted on',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy, h:mm a').format(
                              (surveyForm.createdAt ?? DateTime.now()),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xff6A737B),
                                ),
                          ),
                        ],
                      ),
                    if (surveyForm.timesheet != null)
                      InkWell(
                        onTap: () {
                          timesheetClick(surveyForm.timesheet ?? '');
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
                                surveyForm.timesheetNumber ?? '',
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
                    if (surveyForm.equipment != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Equipment',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                            ),
                          ),
                          Text(
                            surveyForm.equipmentName ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xff6A737B),
                                ),
                          ),
                        ],
                      ),
                    if (surveyForm.project != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Project',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff212529),
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              surveyForm.jobNumber ?? surveyForm.project ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xff6A737B),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    if (surveyForm.updatedBy != null) ...[
                      const Divider(),
                      RichText(
                        text: TextSpan(
                          text: 'Last Edited ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                                text: 'by ${surveyForm.updatedBy} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'on ${DateFormat('dd/MM/yyyy, h:mm a').format(
                              surveyForm.updatedAt ?? DateTime.now(),
                            )}.'),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 8,
                    ),
                    if (surveyForm.status != null &&
                        surveyForm.status?['id'] != null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex(
                                surveyForm.status!['color'] ?? ''),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          surveyForm.status!['label'].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                  ],
                ),
              ),
              ...surveyForm.inputFields.map<Widget?>((e) {
                return ResponseInputWidget(
                  imageBuild: imageBuild,
                  fileClick: fileClick,
                  surveyForm: surveyForm,
                  hasGeolocation: hasGeolocation,
                  timesheetClick: timesheetClick,
                );
              }).whereType<Widget>(),
            ],
          ),
        ),
      ),
    );
  }
}
