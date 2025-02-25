// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import '../state/current_form_provider.dart';
import '../state/link_label_provider.dart';
import '../state/required_id_provider.dart';
import '../state/table_row_expanded_provider.dart';
import '../state/table_row_provider.dart';
import '../widget/navigation_button.dart';
import 'varicon_input_fields.dart';

///Main container for the form builder
class VariconFormBuilder extends StatefulHookConsumerWidget {
  const VariconFormBuilder({
    super.key,
    required this.surveyForm,
    required this.buttonText,
    this.separatorBuilder,
    required this.onSave,
    required this.onSubmit,
    required this.attachmentSave,
    required this.imageBuild,
    required this.onFileClicked,
    required this.autoSave,
    required this.customPainter,
    required this.locationData,
    required this.onBackPressed,
    required this.formtitle,
    required this.onPopPressed,
    this.apiCall,
    this.padding,
    this.hasSave = false,
    this.hasAutoSave = false,
  });

  ///Survey page form model
  ///
  ///Contains forms metadata
  ///
  ///Contains forms various input fields
  final SurveyPageForm surveyForm;

  ///Button text title
  ///
  ///Required to be displayed on the form button
  final String buttonText;

  ///Form save callback
  ///
  ///Required to save the form data
  final void Function(List<Map<String, dynamic>> formValue) onSave;

  ///Required to save the form data
  final void Function() onPopPressed;

  ///Form submit callback
  ///
  ///Submit data with filled values
  final void Function(List<Map<String, dynamic>> formValue) onSubmit;

  ///Widget for custom image painter
  final Widget Function(File imageFile) customPainter;

  ///Current Location
  final String locationData;

  ///function to save attachments
  ///
  ///Contains function with list of attachments
  ///
  ///Used for images and files like signature
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  ///Used to store image paths and file paths
  ///With height and width
  final Widget Function(Map<String, dynamic>) imageBuild;

  ///Used to store image paths and file paths
  ///With height and width
  final void Function(List<Map<String, dynamic>>) autoSave;

  ///API call function
  ///
  ///Handles various api calls required for dropdowns
  ///
  ///Returns list of dynamic values
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  ///Padding for the whole form
  final EdgeInsetsGeometry? padding;

  ///Check if a form has save button
  ///
  ///Shows the save button on the form
  final bool hasSave;

  ///Check if a form has save button
  ///
  ///Shows the save button on the form
  final bool hasAutoSave;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final void Function(String stringURl) onFileClicked;
  final void Function(bool stringURl) onBackPressed;
  final String formtitle;

  @override
  ConsumerState<VariconFormBuilder> createState() => VariconFormBuilderState();

  final Widget Function()? separatorBuilder;
}

class VariconFormBuilderState extends ConsumerState<VariconFormBuilder> {
  final _formKey = GlobalKey<FormBuilderState>();
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(requiredNotifierProvider.notifier)
          .initialList(widget.surveyForm.inputFields);
      ref
          .read(currentStateNotifierProvider.notifier)
          .saveinitialAnswer(widget.surveyForm.inputFields);
    });
    if (widget.hasAutoSave) {
      _autoSaveTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
        final formValue = ref
            .read(currentStateNotifierProvider.notifier)
            .getFinalAnswer(widget.surveyForm.inputFields);
        widget.autoSave(formValue);
      });
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();

    super.dispose();
  }

  void onBackPressed() {
    bool isSame = ref
        .read(currentStateNotifierProvider.notifier)
        .checkInitialFinalAnswerIdentical();
    widget.onBackPressed(isSame);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentStateNotifierProvider);
    ref.watch(requiredNotifierProvider);
    // ref.watch(currentTableRowProvider);
    ref.watch(linklabelProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        widget.onPopPressed();
        onBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            widget.formtitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed,
          ),
        ),
        body: Padding(
          padding: widget.padding ?? const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.surveyForm.title.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    height: 1.2,
                                  ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.surveyForm.description.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xff6A737B),
                                  ),
                            ),
                          ],
                        ),
                        ...widget.surveyForm.inputFields.map<Widget?>((e) {
                          return VariconInputFields(
                            field: e,
                            apiCall: widget.apiCall,
                            imageBuild: widget.imageBuild,
                            attachmentSave: widget.attachmentSave,
                          );
                        }).whereType<Widget>(),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (widget.hasAutoSave)
                    Expanded(
                      child: NavigationButton(
                        buttonText: 'SUBMIT LATER',
                        onComplete: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      'The submission will be saved to draft.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                content: const Text(
                                  'Please note clocking out from Varicon will remove these draft submissions.',
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  NavigationButton(
                                    buttonText: 'OKAY',
                                    onComplete: () async {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        isAutoSave: true,
                      ),
                    ),
                  if (widget.hasAutoSave) const SizedBox(width: 12.0),
                  Expanded(
                    child: NavigationButton(
                      buttonText: widget.buttonText,
                      onComplete: () async {
                        try {
                          if (_formKey.currentState == null) return;
                          // return if form is not valid.
                          if (!_formKey.currentState!.validate()) {
                            if (ref
                                    .read(requiredNotifierProvider.notifier)
                                    .getInitialRequiredContext() !=
                                null) {
                              Scrollable.ensureVisible(
                                  (ref
                                      .read(requiredNotifierProvider.notifier)
                                      .getInitialRequiredContext())!,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceIn);
                              // String? id = ref
                              //     .read(requiredNotifierProvider.notifier)
                              //     .getInitialRequiredContextId();
                              // if (id != null) {
                              //   final tablesDatat =
                              //       ref.read(tableRowKeyProvider);

                              //   /// Prvoide Rows ID
                              //   final expandedData = ref.read(
                              //       currentTableRowProvider); // Procide Rows expansion bool

                              //   final indexIdData = ref
                              //       .read(tableRowKeyProvider.notifier)
                              //       .getIndex(id);
                              //   log('Index in Rows ${indexIdData.$1} key ${indexIdData.$2}');

                              //   ///id of the key of provided row
                              //   if (indexIdData.$1 != -1) {
                              //     if (expandedData[indexIdData.$2] != null) {
                              //       if (expandedData[indexIdData.$2] == false) {
                              //         ref
                              //             .read(
                              //                 currentTableRowProvider.notifier)
                              //             .setCurrentExpandedson(
                              //               indexIdData.$2,
                              //             );

                              //         Scrollable.ensureVisible(
                              //             (ref
                              //                 .read(requiredNotifierProvider
                              //                     .notifier)
                              //                 .getInitialRequiredContext())!,
                              //             duration:
                              //                 const Duration(milliseconds: 500),
                              //             curve: Curves.bounceIn);
                              //       } else {
                              //         Scrollable.ensureVisible(
                              //             (ref
                              //                 .read(requiredNotifierProvider
                              //                     .notifier)
                              //                 .getInitialRequiredContext())!,
                              //             duration:
                              //                 const Duration(milliseconds: 500),
                              //             curve: Curves.bounceIn);
                              //       }
                              //     } else {
                              //       Scrollable.ensureVisible(
                              //           (ref
                              //               .read(requiredNotifierProvider
                              //                   .notifier)
                              //               .getInitialRequiredContext())!,
                              //           duration:
                              //               const Duration(milliseconds: 500),
                              //           curve: Curves.bounceIn);
                              //     }
                              //   } else {
                              //     Scrollable.ensureVisible(
                              //         (ref
                              //             .read(
                              //                 requiredNotifierProvider.notifier)
                              //             .getInitialRequiredContext())!,
                              //         duration:
                              //             const Duration(milliseconds: 500),
                              //         curve: Curves.bounceIn);
                              //   }

                              //   log('Table Data' + jsonEncode(tablesDatat));
                              //   log('Table Data EXPANDED' +
                              //       jsonEncode(expandedData));
                              // } else {
                              //   Scrollable.ensureVisible(
                              //       (ref
                              //           .read(requiredNotifierProvider.notifier)
                              //           .getInitialRequiredContext())!,
                              //       duration: const Duration(milliseconds: 500),
                              //       curve: Curves.bounceIn);
                              // }
                            }
                            return;
                          } else {
                            final formValue = ref
                                .read(currentStateNotifierProvider.notifier)
                                .getFinalAnswer(
                                  widget.surveyForm.inputFields,
                                );
                            widget.onSubmit(formValue);
                          }
                        } catch (e) {
                          log('Error: $e');
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
