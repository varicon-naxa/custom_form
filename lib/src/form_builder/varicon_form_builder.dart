// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads, unrelated_type_equality_checks

import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/scroll/scroll_to_id.dart';
import 'package:varicon_form_builder/src/form_builder/form_fields/date_time_form_field.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/bottom_nav_btn_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/checkbox_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_location.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/datetime_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/dropdown_input_widget.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/expandable_widget.dart';
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
      required this.autoSave,
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

  ///Used to store image paths and file paths
  ///With height and width
  final void Function(Map<String, dynamic>) autoSave;

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
  // final Map<String, GlobalKey<FormFieldState<dynamic>>> _formFieldKeys = {};

  final Map<GlobalKey<FormFieldState<dynamic>>, String> _fieldKeyToIdMap = {};
  bool isScrolled = false;

  ///Values to be submitted via forms
  final formValue = FormValue();

  // // Initialize the keys and mapping
  // void _initializeKeys(List<InputField> inputFields) {
  //   for (var field in inputFields) {
  //     final key = GlobalKey<FormFieldState<dynamic>>();
  //     _formFieldKeys[field.id] = key;
  //     _fieldKeyToIdMap[key] = field.id;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    formValue.setOnSaveCallback(widget.autoSave);

    ///Initializing custom form state
    ///
    ///Sets input fields and global keys
    // _initializeKeys(widget.surveyForm.inputFields);

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

  @override
  Widget build(BuildContext context) {
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
                id: 'form_title',
                child: FormTitleInfoWidget(
                  hasGeolocation: widget.hasGeolocation,
                  surveyForm: widget.surveyForm,
                  currentPosition: _currentPosition,
                  scrollController: scrollControllerId,
                ),
              ),
              ScrollContent(
                id: 'form-body',
                child: FormInputWidgets(
                  scrollToId: scrollToId!,
                  surveyForm: widget.surveyForm,
                  formValue: formValue,
                  // formFieldKeys: _formFieldKeys,
                  currentPosition: _currentPosition,
                  attachmentSave: widget.attachmentSave,
                  imageBuild: widget.imageBuild,
                  onFileClicked: widget.onFileClicked,
                  hasGeolocation: widget.hasGeolocation,
                  apiCall: widget.apiCall,
                ),
              ),
              if (widget.hasSave) ...[
                ScrollContent(id: 'spacing', child: AppSpacing.sizedBoxH_08()),
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
            ],
          ),
        ),
      ),
    );
  }
}

class FormInputWidgets extends StatefulWidget {
  const FormInputWidgets({
    super.key,
    required this.scrollToId,
    required this.surveyForm,
    required this.formValue,
    // required this.formFieldKeys,
    required this.currentPosition,
    required this.attachmentSave,
    required this.imageBuild,
    this.apiCall,
    required this.onFileClicked,
    required this.hasGeolocation,
  });
  final ScrollToId scrollToId;
  final SurveyPageForm surveyForm;
  final FormValue formValue;
  final Position? currentPosition;
  final void Function(String stringURl) onFileClicked;
  final bool hasGeolocation;
  // final Map<String, GlobalKey<FormFieldState<dynamic>>> formFieldKeys;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<FormInputWidgets> createState() => _FormInputWidgetsState();
}

class _FormInputWidgetsState extends State<FormInputWidgets> {
  ///Track total form question counts
  final Map<String, GlobalKey<FormFieldState<dynamic>>> _formFieldKeys = {};
  final Map<GlobalKey<FormFieldState<dynamic>>, String> _fieldKeyToIdMap = {};
  bool isScrolled = false;

  ///Values to be submitted via forms
  final formValue = FormValue();

  // Add this map to store table states
  final Map<String, TableField> _tableState = {};

  // Add this map to store visible rows for each table
  final Map<String, List<bool>> _visibleRows = {};

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

    // // scrollControllerId.addListener(() => detectScroll());

    // _getCurrentPosition();
    for (var field in widget.surveyForm.inputFields) {
      if (field is TableField) {
        _tableState[field.id] = field;

        _visibleRows[field.id] =
            List.generate((field.inputFields ?? []).length, (_) => true);

        widget.formValue.saveTableField(
          field.id,
          _tableState[field.id]!,
        );
      }
    }
  }

  @override
  void dispose() {
    // scrollControllerId.dispose();
    super.dispose();
  }

  ///method to generate new id for field [add row]
  InputField generateNewIdForField(InputField field) {
    var uuid = const Uuid();

    Map<String, dynamic> updateId(Map<String, dynamic> item) {
      return Map.from(item).map((key, value) {
        if (key == 'id' && value is String) {
          return MapEntry(key, 'item-${uuid.v4()}'); // Generate a new UUID
        }
        if (key == 'key' || key == 'answer') {
          return MapEntry(key, null); // Generate a new UUID
        }
        if (value is Map<String, dynamic>) {
          return MapEntry(key, updateId(value));
        }
        if (value is List) {
          return MapEntry(
              key,
              value
                  .map((e) => e is Map<String, dynamic> ? updateId(e) : e)
                  .toList());
        }
        return MapEntry(key, value);
      });
    }

    // Create a new InputField with updated properties
    return InputField.fromJson(updateId(field.toJson()));
  }

  ///method to add new row in simple table field
  void addNewRow(TableField field) {
    if ((field.inputFields ?? []).isNotEmpty) {
      List<InputField> newRow = (field.inputFields ?? [])[0].map((field) {
        return generateNewIdForField(field);
      }).toList();

      setState(() {
        List<List<InputField>>? updatedTableField =
            List.from(field.inputFields ?? [])..add(newRow);

        _tableState[field.id] = field.copyWith(inputFields: updatedTableField);

        _visibleRows[field.id] = List.from(_visibleRows[field.id] ?? [])
          ..add(true);
      });

      widget.formValue.saveTableField(
        field.id,
        _tableState[field.id]!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.surveyForm.inputFields
              .map<ScrollContent?>((e) => _buildInputField(e, context))
              .whereType<ScrollContent>()
              .toList(),
        ],
      ),
    );
  }

  ///builds all forem input field
  ScrollContent? _buildInputField(InputField field, BuildContext context,
      {bool haslabel = true}) {
    final labelText = haslabel ? '${field.label ?? ''} ' : '';
    return field.maybeMap(
      text: (field) => _buildTextInput(
        field,
        labelText,
        context,
      ),
      number: (field) => _buildNumberInput(field, labelText, context),
      phone: (field) => _buildPhoneInput(field, labelText, context),
      email: (field) => _buildEmailInput(field, labelText, context),
      url: (field) => _buildUrlInput(field, labelText, context),
      date: (field) => _buildDateInput(field, labelText),
      time: (field) => _buildTimeInput(field, labelText),
      datetimelocal: (field) => _buildDateTimeInput(field, labelText),
      comment: (field) => _buildCommentInput(field, labelText, context),
      dropdown: (field) => _buildDropdownInput(field, labelText),
      yesno: (field) => _buildYesNoInput(field, labelText),
      radiogroup: (field) => _buildRadioGroupInput(field, labelText),
      yesnona: (field) => _buildYesNoNaInput(field, labelText),
      checkbox: (field) => _buildCheckboxInput(field, labelText),
      multipleselect: (field) => _buildMultipleSelectInput(field, labelText),
      files: (field) => _buildFilesInput(field, labelText),
      images: (field) => _buildImagesInput(field, labelText),
      signature: (field) => _buildSignatureInput(field, labelText),
      multisignature: (field) => _buildMultiSignatureInput(field, labelText),
      instruction: (field) => _buildInstructionInput(field, labelText),
      section: (field) => _buildSectionInput(field, context),
      geolocation: (field) => _buildGeolocationInput(field, labelText, context),
      table: (field) => _buildTableInput(field, labelText, context),
      advtable: (field) => _buildAdvTableInput(field, labelText, context),
      orElse: () => null,
    );
  }

  /// text input field build method
  ScrollContent _buildTextInput(
    TextInputField field,
    String labelText,
    BuildContext context,
  ) {
    final HtmlEditorController htmlEditorController = HtmlEditorController();
    final TextEditingController formCon = TextEditingController();
    HtmlEditorOptions editorOptions = const HtmlEditorOptions();
    widget.formValue.saveString(
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
        isRequired: field.isRequired,
        child: (field.name ?? '').toLowerCase().contains('long')
            ? HtmlEditorWidget(
                formCon: formCon,
                fieldKey: _formFieldKeys[field.id],
                field: field,
                htmlEditorController: htmlEditorController,
                editorOptions: editorOptions,
                formValue: widget.formValue,
              )
            : (field.name ?? '').toLowerCase().contains('address')
                ? MapFieldWidget(
                    fieldKey: _formFieldKeys[field.id],
                    isRequired: field.isRequired,
                    formValue: widget.formValue,
                    field: field,
                    forMapField: true,
                  )
                : TextFormField(
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    initialValue: field.answer ?? '',
                    key: _formFieldKeys[field.id],
                    style: Theme.of(context).textTheme.bodyLarge,
                    readOnly: field.readOnly,
                    keyboardType:
                        (field.name ?? '').toLowerCase().contains('long')
                            ? TextInputType.multiline
                            : TextInputType.text,
                    textInputAction:
                        (field.name ?? '').toLowerCase().contains('long')
                            ? TextInputAction.newline
                            : TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: field.maxLength,
                    maxLines: (field.name ?? '').toLowerCase().contains('long')
                        ? 3
                        : 1,
                    onChanged: (data) {
                      widget.formValue.saveString(
                        field.id,
                        data,
                      );
                    },
                    onSaved: (newValue) {
                      widget.formValue.saveString(
                        field.id,
                        newValue.toString().trim(),
                      );
                    },
                    validator: (value) {
                      return textValidator(
                        value: value,
                        inputType: "text",
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
  }

  ///Number input field build method
  ScrollContent _buildNumberInput(
    NumberInputField field,
    String labelText,
    BuildContext context,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          initialValue: field.answer ?? '',
          textInputAction: TextInputAction.next,
          key: _formFieldKeys[field.id],
          style: Theme.of(context).textTheme.bodyLarge,
          readOnly: field.readOnly,
          keyboardType: const TextInputType.numberWithOptions(
              signed: false, decimal: false),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: (newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveString(
              field.id,
              newValue.toString().trim(),
            );
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly

            // FilteringTextInputFormatter.allow(
            //     // RegExp(r'^[0-9]+.?[0-9]*'),
            //     RegExp(r'^\s*([0-9]+)\s*$')),
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
  }

  ///Phone input field build method
  ScrollContent _buildPhoneInput(
    PhoneInputField field,
    String labelText,
    BuildContext context,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    PhoneNumber? phoneNumber;
    phoneNumber =
        PhoneNumber.fromCompleteNumber(completeNumber: field.answer ?? '');

    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: FormBuilderIntlPhoneField(
          fieldKey: _formFieldKeys[field.id], // Pass the key here
          name: field.label ?? '',
          initialValue: phoneNumber.number,
          initialCountryCode: phoneNumber.countryISOCode,
          invalidNumberMessage: 'Invalid Phone Number',
          isRequired: field.isRequired,
          onSaved: (newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            Country country = PhoneNumber.getCountry(newValue);
            if (newValue.replaceAll('+', '').toString().trim() !=
                country.dialCode.trim()) {
              widget.formValue.saveString(
                field.id,
                newValue,
              );
            } else {
              if (phoneNumber?.number != null) {
                widget.formValue.saveString(
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
  }

  ///Email input field build method
  ScrollContent _buildEmailInput(
    EmailInputField field,
    String labelText,
    BuildContext context,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          key: _formFieldKeys[field.id],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: (field.answer),
          readOnly: field.readOnly,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: TextInputType.emailAddress,
          maxLength: field.maxLength,
          onSaved: (newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveString(
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
  }

  ///URL input field build method
  ScrollContent _buildUrlInput(
    UrlInputField field,
    String labelText,
    BuildContext context,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          key: _formFieldKeys[field.id],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: (field.answer),
          readOnly: field.readOnly,
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: TextInputType.number,
          maxLength: field.maxLength,
          textInputAction: TextInputAction.next,
          onSaved: (newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveString(
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
  }

  ///Date input field build method
  ScrollContent _buildDateInput(
    DateInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: DateTimeInputWidget(
          fieldKey: _formFieldKeys[field.id],
          field: field,
          dateTime: DatePickerType.date,
          formValue: widget.formValue,
          // labelText: labelText,
        ),
      ),
    );
  }

  ///Time input field build method
  ScrollContent _buildTimeInput(
    TimeInputField field,
    String labelText,
  ) {
    // widget.formValue.saveString(
    //   field.id,
    //   field.answer,
    // );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: DateTimeInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          dateTime: DatePickerType.time,
          formValue: widget.formValue,
          // labelText: labelText,
        ),
      ),
    );
  }

  ///Date time input field build method
  ScrollContent _buildDateTimeInput(
    DateTimeInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: DateTimeInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          dateTime: DatePickerType.dateTime,
          formValue: widget.formValue,
          // labelText: labelText,
        ),
      ),
    );
  }

  ///Comment input field build method
  ScrollContent _buildCommentInput(
    CommentInputField field,
    String labelText,
    BuildContext context,
  ) {
    return ScrollContent(
      id: field.id,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledWidget(
            labelText: labelText,
            isRequired: field.isRequired,
            child: TextFormField(
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              initialValue: field.answer,
              key: _formFieldKeys[field.id],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              readOnly: field.readOnly,
              style: Theme.of(context).textTheme.bodyLarge,
              keyboardType: TextInputType.text,
              maxLength: field.maxLength,
              maxLines: 4,
              onSaved: (newValue) {
                // htmlEditorController.editorController!
                //     .clearFocus();
                widget.formValue.saveString(
                  field.id,
                  newValue,
                );
              },
              validator: (value) {
                return textValidator(
                  value: value,
                  inputType: "comment",
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
          AppSpacing.sizedBoxH_12(),
        ],
      ),
    );
  }

  ///Dropdown input field build method
  ScrollContent _buildDropdownInput(
    DropdownInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: DropdownInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          apiCall: widget.apiCall,
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///YesNo input field build method
  ScrollContent _buildYesNoInput(
    YesNoInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: YesNoInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///Radio group field build method
  ScrollContent _buildRadioGroupInput(
    RadioInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: RadioInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///YesNoNa input field build method
  ScrollContent _buildYesNoNaInput(
    YesNoNaInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: YesNoNaInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///Checkbox input field build method
  ScrollContent _buildCheckboxInput(
    CheckboxInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: CheckboxInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          apiCall: widget.apiCall,
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///Multi-select build mehod
  ScrollContent _buildMultipleSelectInput(
    MultipleInputField field,
    String labelText,
  ) {
    widget.formValue.saveString(
      field.id,
      field.answer,
    );
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: MultipleInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          apiCall: widget.apiCall,
          formValue: widget.formValue,
          labelText: labelText,
        ),
      ),
    );
  }

  ///Files input field build method
  ScrollContent _buildFilesInput(
    FileInputField field,
    String labelText,
  ) {
    TextEditingController formCon = TextEditingController();
    if (field.answer != null && (field.answer ?? []).isNotEmpty) {
      widget.formValue.saveList(
        field.id,
        field.answer,
      );
    }

    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: FileInputWidget(
          formCon: formCon,
          emptyMsg: 'File is required',
          filetype: FileType.any,
          field: field,
          fieldKey: _formFieldKeys[field.id],
          imageBuild: widget.imageBuild,
          attachmentSave: widget.attachmentSave,
          formValue: widget.formValue,
          labelText: labelText,
          fileClicked: widget.onFileClicked,
          onSaved: (List<Map<String, dynamic>> newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveList(
              field.id,
              newValue,
            );
          },
        ),
      ),
    );
  }

  ///Images input field build method
  ScrollContent _buildImagesInput(
    ImageInputField field,
    String labelText,
  ) {
    TextEditingController formCon = TextEditingController();

    if (field.answer != null && (field.answer ?? []).isNotEmpty) {
      widget.formValue.saveList(
        field.id,
        field.answer,
      );
    }
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: FileInputWidget(
          formCon: formCon,
          fieldKey: _formFieldKeys[field.id],
          field: field,
          emptyMsg: 'Image is required',
          fileClicked: widget.onFileClicked,
          filetype: FileType.image,
          imageBuild: widget.imageBuild,
          attachmentSave: widget.attachmentSave,
          formValue: widget.formValue,
          labelText: labelText,
          onSaved: (List<Map<String, dynamic>> newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveList(
              field.id,
              newValue,
            );
          },
        ),
      ),
    );
  }

  ///Signature input field build method
  ScrollContent _buildSignatureInput(
    SignatureInputField field,
    String labelText,
  ) {
    if (field.answer != null &&
        field.answer != {} &&
        field.answer.toString() != '{}') {
      widget.formValue.saveMap(
        field.id,
        field.answer ?? {},
      );
    }
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: SignatureInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          attachmentSave: widget.attachmentSave,
          formValue: widget.formValue,
          labelText: labelText,
          imageBuild: widget.imageBuild,
          onSaved: (Map<String, dynamic> newValue) {
            // htmlEditorController.editorController!
            //     .clearFocus();
            widget.formValue.saveMap(
              field.id,
              newValue,
            );
          },
        ),
      ),
    );
  }

  ///Multi-signature input field build method
  ScrollContent _buildMultiSignatureInput(
    MultiSignatureInputField field,
    String labelText,
  ) {
    if (field.answer != null && (field.answer ?? []).isNotEmpty) {
      widget.formValue.saveList(
        field.id,
        (field.answer ?? []).map((e) => e.toJson()).toList(),
      );
    }
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
        labelText: labelText,
        isRequired: field.isRequired,
        child: MultiSignatureInputWidget(
          field: field,
          fieldKey: _formFieldKeys[field.id],
          formValue: widget.formValue,
          imageBuild: widget.imageBuild,
          attachmentSave: widget.attachmentSave,
          labelText: labelText,
          onSaved: (Map<String, dynamic> result) {
            // htmlEditorController.editorController!
            //     .clearFocus();
          },
        ),
      ),
    );
  }

  ///Instruction input field build method
  ScrollContent _buildInstructionInput(
    InstructionInputField field,
    String labelText,
  ) {
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
          labelText: field.label,
          isRequired: field.isRequired,
          child: InstructionWidget(
            onTap: (String url) {
              widget.onFileClicked(url);
            },
            field: field,
            key: _formFieldKeys[field.id],
            imageBuild: widget.imageBuild,
          )),
    );
  }

  ///Section input field build method
  ScrollContent _buildSectionInput(
    SectionInputField field,
    BuildContext context,
  ) {
    return ScrollContent(
      id: field.id,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label ?? '',
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
      ),
    );
  }

  ///Geolocation input field build method
  ScrollContent _buildGeolocationInput(
    GeolocationField field,
    String labelText,
    BuildContext context,
  ) {
    return (widget.hasGeolocation)
        ? ScrollContent(id: field.id, child: const SizedBox.shrink())
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
                  : (widget.currentPosition?.latitude != null &&
                          widget.hasGeolocation)
                      ? CustomLocation(
                          postition: widget.currentPosition!,
                        )
                      : Text(
                          'Location is disabled!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
            ),
          );
  }

  ///Table input field build method
  ScrollContent _buildTableInput(
    TableField field,
    String labelText,
    BuildContext context,
  ) {
    TableField currentTableField = field;
    List<bool> visibleRows = _visibleRows[field.id] ?? [];
    TableField table = _tableState[field.id] ?? field;

    List<List<InputField>> modifiedInputField =
        (table.inputFields ?? []).map((row) {
      return row.map((field) {
        return field.copyWith(
          isRequired: table.isRequired ? field.isRequired : false,
        );
      }).toList();
    }).toList();

    setState(() {
      //updating the newly added input fields
      currentTableField =
          currentTableField.copyWith(inputFields: modifiedInputField);
    });

    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
          labelText: labelText,
          isRequired: field.isRequired,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              table.isRow
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentTableField.inputFields?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ExpandableWidget(
                            expandableHeader: TableExpandableHeaderWidget(
                              index: index,
                              field: currentTableField,
                            ),
                            expandedHeader: TableExpandableHeaderWidget(
                              index: index,
                              field: currentTableField,
                              isExpanded: true,
                            ),
                            expandableChild: Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                children: currentTableField.inputFields![index]
                                    .map<Widget>((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: _buildInputField(item, context) ??
                                        const SizedBox.shrink(),
                                  );
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
                            columnIndex < modifiedInputField[0].length;
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
                                    'Column ${columnIndex + 1} ',
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_up)
                                ],
                              ),
                              expandedHeader: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Column ${columnIndex + 1}',
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                              expandableChild: Column(
                                children: modifiedInputField
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final rowIndex = entry.key;
                                  final row = entry.value;
                                  if (rowIndex >= visibleRows.length ||
                                      !visibleRows[rowIndex]) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: _buildInputField(
                                            row[columnIndex], context,
                                            haslabel: rowIndex <= 0) ??
                                        const SizedBox.shrink(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),

              //add new row button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () => addNewRow(table),
                icon: const Icon(Icons.add),
                label: const Text('Add Row'),
              )
            ],
          )),
    );
  }

  ///Advance Table input field build method
  ScrollContent _buildAdvTableInput(
    AdvTableField currentTableField,
    String labelText,
    BuildContext context,
  ) {
    AdvTableField field = currentTableField;

    List<List<InputField>> modifiedInputField =
        (field.inputFields ?? []).map((row) {
      return row.map((field) {
        return field.copyWith(
          isRequired: field.isRequired ? field.isRequired : false,
        );
      }).toList();
    }).toList();
    setState(() {
      //updating the newly added input fields
      field = field.copyWith(inputFields: modifiedInputField);
    });
    return ScrollContent(
      id: field.id,
      child: LabeledWidget(
          labelText: labelText,
          isRequired: field.isRequired,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              field.isRow
                  ? ListView.builder(
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
                              child: Column(
                                children: field.inputFields![index]
                                    .map<Widget>((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: _buildInputField(item, context) ??
                                        const SizedBox.shrink(),
                                  );
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
                            columnIndex < (field.inputFields ?? [])[0].length;
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
                                    'Column ${columnIndex + 1} ',
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_up)
                                ],
                              ),
                              expandedHeader: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Column ${columnIndex + 1}',
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                              expandableChild: Column(
                                children: (field.inputFields ?? [])
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final rowIndex = entry.key;
                                  final row = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: _buildInputField(
                                            row[columnIndex], context,
                                            haslabel: rowIndex <= 0) ??
                                        const SizedBox.shrink(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
            ],
          )),
    );
  }
}

///Table expandable header info and count widget
class TableExpandableHeaderWidget extends StatelessWidget {
  const TableExpandableHeaderWidget({
    super.key,
    required this.index,
    required this.field,
    this.isExpanded = false,
  });

  final bool? isExpanded;
  final int index;
  final dynamic field;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Row ${index + 1} (${field.inputFields?[index].length} Questions)',
            ),
            Icon(
              isExpanded == true
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}

///HTML editor widget class
class HtmlEditorWidget extends StatefulWidget {
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
  State<HtmlEditorWidget> createState() => _HtmlEditorWidgetState();
}

class _HtmlEditorWidgetState extends State<HtmlEditorWidget> {
  bool empty = false;

  void saveLongText() {
    widget.formValue.saveString(
      widget.field.id,
      widget.formCon.text,
    );
  }

  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r"<[^>]*>"), ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: HtmlEditor(
              callbacks: Callbacks(
                onFocus: () {
                  saveLongText();
                },
                onBlur: () {
                  saveLongText();
                },
                onChangeContent: (code) {
                  if (code.toString().isNotEmpty &&
                      empty == true &&
                      stripHtml(code.toString()).isNotEmpty) {
                    widget.formCon.text = code.toString().trim();
                    saveLongText();
                  } else {
                    widget.formCon.text = code.toString().trim();
                    widget.formCon.clear();
                    saveLongText();
                    setState(() {
                      empty = true;
                    });
                  }
                },
              ),
              controller: widget.htmlEditorController, //required
              plugins: const [],
              htmlEditorOptions: widget.editorOptions,
              htmlToolbarOptions: const HtmlToolbarOptions(
                defaultToolbarButtons: [
                  FontButtons(
                    clearAll: false,
                    strikethrough: false,
                    subscript: false,
                    superscript: false,
                  ),
                  ListButtons(listStyles: false),
                  ParagraphButtons(
                    caseConverter: false,
                    lineHeight: false,
                    textDirection: false,
                    increaseIndent: false,
                    decreaseIndent: false,
                  ),
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
              controller: widget.formCon,
              key: widget.fieldKey,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                setState(() {
                  empty = true;
                });
                if (empty == true) {
                  if ((value ?? '').isNotEmpty) {
                    saveLongText();
                  }
                  return textValidator(
                    value: stripHtml((value ?? '').toString().trim()),
                    inputType: "text",
                    isRequired: (widget.field.isRequired),
                    requiredErrorText: 'Long text is required',
                  );
                } else {
                  return null;
                }
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
