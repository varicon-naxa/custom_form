// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:varicon_form_builder/scroll/scroll_to_id.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/date_time_form_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/bottom_nav_btn_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/checkbox_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/datetime_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/dropdown_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/file_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/form_title_info_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/instruction_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/map_field_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/multi_signature_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/multple_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/phone_number_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/radio_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/yes_now_input_widget.dart';
import 'package:varicon_form_builder/src/models/form_value.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'widgets/labeled_widget.dart';
import 'widgets/signature_input_widget.dart';
import 'widgets/yes_no_na_input_widget.dart';
import 'package:geolocator/geolocator.dart';
part '_helpers.dart';
part '_navigation_button.dart';
part '_validators.dart';

///Main container for the form builder
class VariconFormBuilder extends StatefulWidget {
  const VariconFormBuilder(
      {super.key,
      required this.surveyForm,
      required this.buttonText,
      this.separatorBuilder,
      required this.onSave,
      required this.onSubmit,
      required this.attachmentSave,
      required this.imageBuild,
      required this.isCarousel,
      required this.hasGeolocation,
      required this.onFileClicked,
      this.apiCall,
      this.padding,
      this.hasSave = false});

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
  final void Function(Map<String, dynamic> formValue) onSave;

  ///Form submit callback
  ///
  ///Submit data with filled values
  final void Function(Map<String, dynamic> formValue) onSubmit;

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

  ///API call function
  ///
  ///Handles various api calls required for dropdowns
  ///
  ///Returns list of dynamic values
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  ///Check the condition if a form item should be displayed as a carousel
  final bool isCarousel;

  ///Padding for the whole form
  final EdgeInsetsGeometry? padding;

  ///Check if a form has geolocation
  ///
  ///If true, it will capture the approximate location from where the form is being submitted
  final bool hasGeolocation;

  ///Check if a form has save button
  ///
  ///Shows the save button on the form
  final bool hasSave;

  ///Function to handle file click
  ///
  ///Returns the file path for form contents like images, files, instructions
  final void Function(String stringURl) onFileClicked;

  @override
  State<VariconFormBuilder> createState() => VariconFormBuilderState();

  final Widget Function()? separatorBuilder;
}

class VariconFormBuilderState extends State<VariconFormBuilder> {
  ///Global key to be inizialized for custom forms
  late final GlobalKey<FormState> formKey;

  ///Global key to be inizialized for signature
  late final GlobalKey<SignatureState> signKey;

  ScrollToId? scrollToId;
  final ScrollController scrollControllerId = ScrollController();

  ///Global key list to make each field unique

  ///Track total form question counts
  final Map<String, GlobalKey<FormFieldState<dynamic>>> _formFieldKeys = {};
  final Map<GlobalKey<FormFieldState<dynamic>>, String> _fieldKeyToIdMap = {};
  int questionNumber = 0;
  bool isScrolled = false;

  ///Values to be submitted via forms
  final formValue = FormValue();

  // Initialize the keys and mapping
  void _initializeKeys(List<InputField> inputFields) {
    for (var field in inputFields) {
      final key = GlobalKey<FormFieldState<dynamic>>();
      _formFieldKeys[field.id] = key;
      _fieldKeyToIdMap[key] = field.id;
    }
  }

  @override
  void initState() {
    super.initState();

    ///Initializing custom form state
    ///
    ///Sets input fields and global keys
    _initializeKeys(widget.surveyForm.inputFields);

    formKey = GlobalKey<FormState>();
    signKey = GlobalKey<SignatureState>();

    /// Create ScrollToId instance
    scrollToId = ScrollToId(scrollController: scrollControllerId);

    // scrollControllerId.addListener(() => detectScroll());

    _getCurrentPosition();
  }

  @override
  void dispose() {
    scrollControllerId.dispose();
    super.dispose();
  }

  ///Position variable to store current postion for form
  Position? _currentPosition;

  ///Method to handle location
  ///
  ///Checks and ask for user location permission
  Future<bool> _handleLocationPermission() async {
    if (widget.hasGeolocation) {
      bool serviceEnabled;
      LocationPermission permission;

      ///Asks for user location status
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
        return false;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }

      ///If location permission denied forever user should turn it from from app settings
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  ///Method to handle user location
  ///
  ///Check for location permission and fetch position
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // /Method to handle error/empty on submit
  // /
  // /Locates user to the form field with issue
  void scrollToFirstInvalidField() {
    // Form is invalid, find the first invalid field and scroll to it
    FocusScope.of(context).requestFocus(FocusNode()); // Unfocus current field

    for (var entry in _fieldKeyToIdMap.entries) {
      var fieldKey = entry.key;
      var fieldId = entry.value;

      if (fieldKey.currentState != null) {
        if (!fieldKey.currentState!.validate()) {
          scrollToId?.animateTo(fieldId,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
          break;
        }
      }
    }
  }

  ///Method to compare difference between two map values
  bool compareMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    // Check if both maps have the same keys
    if (!map1.keys.toSet().containsAll(map2.keys.toSet()) ||
        !map2.keys.toSet().containsAll(map1.keys.toSet())) {
      return false;
    }

    // Check if values for each key are equal
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }

  bool popInvoke() {
    Map<String, dynamic> initialResult = {};
    for (var field in widget.surveyForm.inputFields) {
      if (field.answer != null && field.answer != '') {
        if (field.answer is List) {
          if (((field.answer ?? []) as List).isNotEmpty) {
            initialResult[field.id] = field.answer;
          }
        } else {
          initialResult[field.id] = field.answer;
        }
      }
    }
    formKey.currentState?.save();
    Map<String, dynamic> fulldata = formValue.value;
    bool areEqual = compareMaps(initialResult, fulldata);

    return areEqual;
  }

  final HtmlEditorController htmlEditorController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    questionNumber = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SubmitUpdateButtonWidget(
        formKey: formKey,
        formValue: formValue,
        scrollController: scrollControllerId,
        hasGeolocation: widget.hasGeolocation,
        surveyForm: widget.surveyForm,
        currentPosition: _currentPosition,
        buttonText: widget.buttonText,
        onSubmit: widget.onSubmit,
        scrollToFirstInvalidField: scrollToFirstInvalidField,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: InteractiveScrollViewer(
              scrollToId: scrollToId,
              scrollDirection: Axis.vertical,
              children: [
                ScrollContent(
                  child: FormTitleInfoWidget(
                    hasGeolocation: widget.hasGeolocation,
                    surveyForm: widget.surveyForm,
                    currentPosition: _currentPosition,
                    scrollController: scrollControllerId,
                  ),
                  id: 'form_title',
                ),
                ...widget.surveyForm.inputFields
                    .map<ScrollContent?>((e) {
                      if (!(e is InstructionInputField ||
                          e is SectionInputField)) {
                        questionNumber++;
                      }
                      final labelText = '$questionNumber. ${e.label ?? ''} ';
                      return e.maybeMap(
                        text: (field) {
                          final TextEditingController formCon =
                              TextEditingController();
                          HtmlEditorOptions editorOptions =
                              const HtmlEditorOptions();
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          editorOptions = HtmlEditorOptions(
                            adjustHeightForKeyboard: false,
                            initialText: field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: (field.name ?? '')
                                      .toLowerCase()
                                      .contains('long')
                                  ? HtmlEditorWidget(
                                      formCon: formCon,
                                      fieldKey: _formFieldKeys[field.id],
                                      field: field,
                                      htmlEditorController:
                                          htmlEditorController,
                                      editorOptions: editorOptions,
                                      formValue: formValue,
                                    )
                                  : (field.name ?? '')
                                          .toLowerCase()
                                          .contains('address')
                                      ? MapFieldWidget(
                                          fieldKey: _formFieldKeys[field.id],
                                          // _fieldKeys[widget
                                          //     .surveyForm.inputFields
                                          //     .indexOf(e)],
                                          isRequired: field.isRequired,
                                          formValue: formValue,
                                          field: field,
                                          forMapField: true,
                                        )
                                      : TextFormField(
                                          // inputFormatters: [
                                          //   FilteringTextInputFormatter.deny(
                                          //       RegExp(r'\s')),
                                          // ],
                                          onTapOutside: (event) => FocusManager
                                              .instance.primaryFocus
                                              ?.unfocus(),
                                          initialValue: field.answer ?? '',
                                          key: _formFieldKeys[field.id],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          readOnly: field.readOnly,
                                          keyboardType: (field.name ?? '')
                                                  .toLowerCase()
                                                  .contains('long')
                                              ? TextInputType.multiline
                                              : TextInputType.text,
                                          textInputAction: (field.name ?? '')
                                                  .toLowerCase()
                                                  .contains('long')
                                              ? TextInputAction.newline
                                              : TextInputAction.next,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          maxLength: field.maxLength,
                                          maxLines: (field.name ?? '')
                                                  .toLowerCase()
                                                  .contains('long')
                                              ? 3
                                              : 1,
                                          onSaved: (newValue) {
                                            htmlEditorController
                                                .editorController!
                                                .clearFocus();
                                            formValue.saveString(
                                              field.id,
                                              newValue.toString().trim(),
                                            );
                                          },
                                          validator: (value) {
                                            return textValidator(
                                              value: value,
                                              inputType: "text",
                                              isRequired: field.isRequired,
                                              requiredErrorText:
                                                  field.requiredErrorText,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            hintText: field.hintText,
                                            // labelText: labelText,
                                          ),
                                        ),
                            ),
                          );
                        },
                        number: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: TextFormField(
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                initialValue: field.answer ?? '',
                                textInputAction: TextInputAction.next,
                                key: _formFieldKeys[field.id],
                                style: Theme.of(context).textTheme.bodyLarge,
                                readOnly: field.readOnly,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveString(
                                    field.id,
                                    newValue.toString().trim(),
                                  );
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      // RegExp(r'^[0-9]+.?[0-9]*'),
                                      RegExp(r'^\s*([0-9]+)\s*$')),
                                ],
                                validator: (value) {
                                  return numberValidator(
                                    value: (value?.isNotEmpty ?? false)
                                        ? num.tryParse(value.toString())
                                        : null,
                                    isRequired: field.isRequired,
                                    requiredErrorText: field.requiredErrorText,
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: field.hintText,
                                  // labelText: labelText,
                                ),
                              ),
                            ),
                          );
                        },
                        phone: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          PhoneNumber? phoneNumber;
                          phoneNumber = PhoneNumber.fromCompleteNumber(
                              completeNumber: field.answer ?? '');

                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: FormBuilderIntlPhoneField(
                                fieldKey: _formFieldKeys[
                                    field.id], // Pass the key here
                                name: e.label ?? '',
                                initialValue: phoneNumber.number,
                                initialCountryCode: phoneNumber.countryISOCode,
                                invalidNumberMessage: 'Invalid Phone Number',
                                isRequired: e.isRequired,
                                onSaved: (newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  Country country =
                                      PhoneNumber.getCountry(newValue);
                                  if (newValue
                                          .replaceAll('+', '')
                                          .toString()
                                          .trim() !=
                                      country.dialCode.trim()) {
                                    formValue.saveString(
                                      field.id,
                                      newValue,
                                    );
                                  } else {
                                    if (phoneNumber?.number != null) {
                                      formValue.saveString(
                                        field.id,
                                        '',
                                      );
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: field.hintText,
                                ),
                              ),
                            ),
                          );
                        },
                        email: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: TextFormField(
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                key: _formFieldKeys[field.id],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: (field.answer),
                                readOnly: field.readOnly,
                                textInputAction: TextInputAction.next,
                                style: Theme.of(context).textTheme.bodyLarge,
                                keyboardType: TextInputType.emailAddress,
                                maxLength: field.maxLength,
                                onSaved: (newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveString(
                                    field.id,
                                    newValue.toString().trim(),
                                  );
                                },
                                validator: (value) {
                                  return textValidator(
                                    value: value,
                                    inputType: "email",
                                    isRequired: field.isRequired,
                                    requiredErrorText: field.requiredErrorText,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        url: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: TextFormField(
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                key: _formFieldKeys[field.id],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                initialValue: (field.answer),
                                readOnly: field.readOnly,
                                style: Theme.of(context).textTheme.bodyLarge,
                                keyboardType: TextInputType.number,
                                maxLength: field.maxLength,
                                textInputAction: TextInputAction.next,
                                onSaved: (newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveString(
                                    field.id,
                                    newValue.toString().trim(),
                                  );
                                },
                                validator: (value) {
                                  return uriValidator(
                                    value: value,
                                    isRequired: field.isRequired,
                                    requiredErrorText: field.requiredErrorText,
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: field.hintText,
                                  // labelText: labelText,
                                ),
                              ),
                            ),
                          );
                        },
                        date: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: DateTimeInputWidget(
                                fieldKey: _formFieldKeys[field.id],
                                field: field,
                                dateTime: DatePickerType.date,
                                formValue: formValue,
                                // labelText: labelText,
                              ),
                            ),
                          );
                        },
                        time: (field) {
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: DateTimeInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                dateTime: DatePickerType.time,
                                formValue: formValue,
                                // labelText: labelText,
                              ),
                            ),
                          );
                        },
                        datetimelocal: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: DateTimeInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                dateTime: DatePickerType.dateTime,
                                formValue: formValue,
                                // labelText: labelText,
                              ),
                            ),
                          );
                        },
                        comment: (field) {
                          return ScrollContent(
                            id: field.id,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabeledWidget(
                                  labelText: labelText,
                                  isRequired: e.isRequired,
                                  child: TextFormField(
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    initialValue: field.answer,
                                    key: _formFieldKeys[field.id],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    readOnly: field.readOnly,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    keyboardType: TextInputType.text,
                                    maxLength: field.maxLength,
                                    maxLines: 4,
                                    onSaved: (newValue) {
                                      htmlEditorController.editorController!
                                          .clearFocus();
                                      formValue.saveString(
                                        field.id,
                                        newValue,
                                      );
                                    },
                                    validator: (value) => textValidator(
                                      value: value,
                                      inputType: "comment",
                                      isRequired: field.isRequired,
                                      requiredErrorText:
                                          field.requiredErrorText,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: field.hintText,
                                      // labelText: labelText,
                                    ),
                                  ),
                                ),
                                AppSpacing.sizedBoxH_12(),
                              ],
                            ),
                          );
                        },
                        dropdown: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: DropdownInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                apiCall: widget.apiCall,
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        yesno: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: YesNoInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        radiogroup: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: RadioInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        yesnona: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: YesNoNaInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        checkbox: (field) {
                          log('checkbox bhitra aayo');
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: CheckboxInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                apiCall: widget.apiCall,
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        multipleselect: (field) {
                          formValue.saveString(
                            field.id,
                            field.answer,
                          );
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: MultipleInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                apiCall: widget.apiCall,
                                formValue: formValue,
                                labelText: labelText,
                              ),
                            ),
                          );
                        },
                        files: (field) {
                          TextEditingController formCon =
                              TextEditingController();
                          if (field.answer != null &&
                              (field.answer ?? []).isNotEmpty) {
                            formValue.saveList(
                              field.id,
                              field.answer,
                            );
                          }

                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: FileInputWidget(
                                formCon: formCon,
                                emptyMsg: 'File is required',
                                filetype: FileType.any,
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                imageBuild: widget.imageBuild,
                                attachmentSave: widget.attachmentSave,
                                formValue: formValue,
                                labelText: labelText,
                                fileClicked: widget.onFileClicked,
                                onSaved: (List<Map<String, dynamic>> newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveList(
                                    field.id,
                                    newValue,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        images: (field) {
                          TextEditingController formCon =
                              TextEditingController();

                          if (field.answer != null &&
                              (field.answer ?? []).isNotEmpty) {
                            formValue.saveList(
                              field.id,
                              field.answer,
                            );
                          }
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: FileInputWidget(
                                formCon: formCon,
                                fieldKey: _formFieldKeys[field.id],
                                field: field,
                                emptyMsg: 'Image is required',
                                fileClicked: widget.onFileClicked,
                                filetype: FileType.image,
                                imageBuild: widget.imageBuild,
                                attachmentSave: widget.attachmentSave,
                                formValue: formValue,
                                labelText: labelText,
                                onSaved: (List<Map<String, dynamic>> newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveList(
                                    field.id,
                                    newValue,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        signature: (field) {
                          if (field.answer != null &&
                              field.answer != {} &&
                              field.answer.toString() != '{}') {
                            formValue.saveMap(
                              field.id,
                              field.answer ?? {},
                            );
                          }
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: SignatureInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                attachmentSave: widget.attachmentSave,
                                formValue: formValue,
                                labelText: labelText,
                                imageBuild: widget.imageBuild,
                                onSaved: (Map<String, dynamic> newValue) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                  formValue.saveMap(
                                    field.id,
                                    newValue,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        multisignature: (field) {
                          if (field.answer != null &&
                              (field.answer ?? []).isNotEmpty) {
                            formValue.saveList(
                              field.id,
                              (field.answer ?? [])
                                  .map((e) => e.toJson())
                                  .toList(),
                            );
                          }
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                              labelText: labelText,
                              isRequired: e.isRequired,
                              child: MultiSignatureInputWidget(
                                field: field,
                                fieldKey: _formFieldKeys[field.id],
                                formValue: formValue,
                                imageBuild: widget.imageBuild,
                                attachmentSave: widget.attachmentSave,
                                labelText: labelText,
                                onSaved: (Map<String, dynamic> result) {
                                  htmlEditorController.editorController!
                                      .clearFocus();
                                },
                              ),
                            ),
                          );
                        },
                        instruction: (field) {
                          return ScrollContent(
                            id: field.id,
                            child: LabeledWidget(
                                labelText: e.label,
                                isRequired: e.isRequired,
                                child: InstructionWidget(
                                  onTap: (String url) {
                                    widget.onFileClicked(url);
                                  },
                                  field: field,
                                  key: _formFieldKeys[field.id],
                                  imageBuild: widget.imageBuild,
                                )),
                          );
                        },
                        section: (field) {
                          return ScrollContent(
                            id: field.id,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
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
                            ),
                          );
                        },
                        geolocation: (field) {
                          return (widget.hasGeolocation)
                              ? ScrollContent(
                                  id: field.id, child: const SizedBox.shrink())
                              : ScrollContent(
                                  id: field.id,
                                  child: LabeledWidget(
                                    labelText: labelText,
                                    isRequired: false,
                                    child: (field.answer != null &&
                                            field.answer!['lat'] != null &&
                                            field.answer!['long'] != null)
                                        ? CustomLocation(
                                            postition: Position(
                                                longitude:
                                                    field.answer!['long'],
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
                                        : (_currentPosition?.latitude != null &&
                                                widget.hasGeolocation)
                                            ? CustomLocation(
                                                postition: _currentPosition!,
                                              )
                                            : Text(
                                                'Location is disabled!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                  ),
                                );
                          // },
                          // map: (field) {
                          //   if (field.answer != null && field.answer != {}) {
                          //     formValue.saveMap(
                          //       field.id,
                          //       field.answer ?? {},
                          //     );
                          //   }
                          //   return LabeledWidget(
                          //     labelText: e.label,
                          //     isRequired: e.isRequired,
                          //     child: MapFieldWidget(
                          //       formKey: _fieldKeys[
                          //           widget.surveyForm.inputFields.indexOf(e)],
                          //       formValue: formValue,
                          //       field: field,
                          //       forMapField: true,
                          //       position: (field.answer?['lat'] == null ||
                          //               field.answer?['long'] == null)
                          //           ? null
                          //           : Position(
                          //               latitude: field.answer?['lat'],
                          //               longitude: field.answer?['long'],
                          //               timestamp: DateTime.timestamp(),
                          //               accuracy: 50.0,
                          //               altitude: 0.0,
                          //               altitudeAccuracy: 50.0,
                          //               heading: 50.0,
                          //               headingAccuracy: 50.0,
                          //               speed: 2.0,
                          //               speedAccuracy: 50.0),
                          //     ),
                          //   );
                        },
                        orElse: () => null,
                      );
                    })
                    .whereType<ScrollContent>()
                    // .separated(widget.separatorBuilder?.call())
                    .toList(),
                if (widget.hasSave) ...[
                  ScrollContent(
                      id: 'spacing', child: AppSpacing.sizedBoxH_08()),
                  ScrollContent(
                    id: 'save_button',
                    child: _SaveOnlyButton(onComplete: () {
                      formKey.currentState?.save();
                      Map<String, dynamic> fulldata = formValue.value;

                      if (widget.hasGeolocation) {
                        fulldata.addAll({
                          'location': widget.surveyForm.setting?['location']
                                      ['lat'] ==
                                  null
                              ? {
                                  'lat': _currentPosition?.latitude,
                                  'long': _currentPosition?.longitude,
                                }
                              : widget.surveyForm.setting?['location']
                        });
                      }
                      widget.onSave(formValue.value);
                    }),
                  ),
                  ScrollContent(
                      id: 'spacing_2', child: AppSpacing.sizedBoxH_12()),
                ],
              ]),
        ),
      ),
    );
  }
}

// ///HTML editor widget class
// class HtmlEditorWidget extends StatefulWidget {
//   final TextInputField field;
//   final HtmlEditorController htmlEditorController;
//   final HtmlEditorOptions editorOptions;
//   final FormValue formValue;
//   final GlobalKey<FormFieldState<dynamic>>? fieldKey;
//   final TextEditingController formCon;

//   const HtmlEditorWidget({
//     super.key,
//     required this.field,
//     required this.htmlEditorController,
//     required this.editorOptions,
//     required this.formValue,
//     this.fieldKey,
//     required this.formCon,
//   });

//   @override
//   State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
// }

// class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
//   bool empty = false;
//   final _debouncer = Debouncer(milliseconds: 300);

//   void saveLongText() {
//     widget.formValue.saveString(
//       widget.field.id,
//       widget.formCon.text,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 200,
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                 ),
//                 borderRadius: BorderRadius.circular(4.0)),
//             child: HtmlEditor(
//               callbacks: Callbacks(
//                 // onFocus: () {
//                 // saveLongText();
//                 // },
//                 // onBlur: () {
//                 // saveLongText();
//                 // },
//                 onChangeContent: (code) {
//                   // if (code.toString().trim().isNotEmpty) {
//                   // _debouncer.run(() {
//                   //   Future.microtask(() {
//                   widget.formCon.text = code.toString().trim();
//                   saveLongText();
//                   setState(() {});
//                   //   });
//                   // });
//                   // }
//                 },
//               ),
//               controller: widget.htmlEditorController, //required
//               plugins: const [],
//               htmlEditorOptions: widget.editorOptions,
//               htmlToolbarOptions: const HtmlToolbarOptions(
//                 defaultToolbarButtons: [
//                   FontButtons(
//                     clearAll: false,
//                     strikethrough: false,
//                     subscript: false,
//                     superscript: false,
//                   ),
//                   ListButtons(listStyles: false),
//                   ParagraphButtons(
//                     caseConverter: false,
//                     lineHeight: false,
//                     textDirection: false,
//                     increaseIndent: false,
//                     decreaseIndent: false,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//           child: Visibility(
//             visible: true,
//             child: TextFormField(
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 enabled: false,
//                 // errorText: empty == true ? 'Long text is required' : '',
//                 labelStyle: const TextStyle(color: Colors.white),
//                 disabledBorder: InputBorder.none,
//                 contentPadding: EdgeInsets.zero,
//               ),
//               controller: widget.formCon,
//               key: widget.fieldKey,
//               readOnly: true,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               // onChanged: (value) {
//               //   setState(() {
//               //     empty = false;
//               //   });
//               // },
//               validator: (value) {
//                 // setState(() {
//                 //   empty = true;
//                 // });
//                 return textValidator(
//                   value: value.toString().trim(),
//                   inputType: "text",
//                   isRequired: (widget.field.isRequired),
//                   requiredErrorText: 'Long text is required',
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

///HTML editor widget class
class HtmlEditorWidget extends StatelessWidget {
  final TextInputField field;
  final HtmlEditorController htmlEditorController;
  final HtmlEditorOptions editorOptions;
  final FormValue formValue;
  final GlobalKey<FormFieldState<dynamic>>? fieldKey;
  final TextEditingController formCon;

  const HtmlEditorWidget({
    super.key,
    required this.field,
    required this.htmlEditorController,
    required this.editorOptions,
    required this.formValue,
    this.fieldKey,
    required this.formCon,
  });

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 300);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            // height: 300,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: HtmlEditor(
              callbacks: Callbacks(
                onFocus: () {
                  formValue.saveString(
                    field.id,
                    formCon.text,
                  );
                },
                // onBlur: () {
                //   formValue.saveString(
                //     field.id,
                //     formCon.text,
                //   );
                // },
                onChangeContent: (code) {
                  formCon.text = code.toString().trim();

                  // if (code.toString().trim().isNotEmpty) {
                  // _debouncer.run(() {
                  // Future.microtask(() {
                  formValue.saveString(
                    field.id,
                    code.toString().trim(),
                  );
                  // });
                  // });
                  // }
                },
              ),
              controller: htmlEditorController, //required
              plugins: const [],
              htmlEditorOptions: editorOptions,
              // textInputAction: TextInputAction.newline,
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  // StyleButtons(),
                  // FontSettingButtons(),
                  FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    subscript: false,
                    superscript: false,
                  ),
                  // ColorButtons(),
                  ListButtons(listStyles: false),
                  ParagraphButtons(
                    caseConverter: false,
                    lineHeight: false,
                    textDirection: false,
                    increaseIndent: false,
                    decreaseIndent: false,
                  ),
                  // InsertButtons(),
                  // OtherButtons(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: Visibility(
            visible: true,
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                enabled: false,
                labelStyle: TextStyle(color: Colors.white),
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              controller: formCon,
              key: fieldKey,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // var a = formValue.value;

                return textValidator(
                  value: value.toString().trim(),
                  inputType: "text",
                  isRequired: (field.isRequired),
                  requiredErrorText: 'Long text is required',
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

///Debouncer class for search feature
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 1000});

  ///checks the timer with durations
  run(VoidCallback action) {
    if (_timer != null || (_timer?.isActive ?? false)) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
