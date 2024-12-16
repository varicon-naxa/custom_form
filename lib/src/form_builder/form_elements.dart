import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/scroll/src/interactive_scroll_viewer.dart';
import 'package:varicon_form_builder/scroll/src/scroll_content.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/phone_number_widget.dart';
import 'package:varicon_form_builder/varicon_form_builder.dart';
import '../../scroll/src/scroll_to_id.dart';
import '../models/form_value.dart';
import 'form_fields/date_time_form_field.dart';
import 'widgets/checkbox_input_widget.dart';
import 'widgets/custom_location.dart';
import 'widgets/datetime_input_widget.dart';
import 'widgets/dropdown_input_widget.dart';
import 'widgets/expandable_widget.dart';
import 'widgets/file_input_widget.dart';
import 'widgets/instruction_widget.dart';
import 'widgets/labeled_widget.dart';
import 'widgets/map_field_widget.dart';
import 'widgets/multi_signature_input_widget.dart';
import 'widgets/multple_input_widget.dart';
import 'widgets/radio_input_widget.dart';
import 'widgets/signature_input_widget.dart';
import 'widgets/yes_no_na_input_widget.dart';
import 'widgets/yes_now_input_widget.dart';

class FormInputWidgets extends StatefulWidget {
  const FormInputWidgets({
    super.key,
    required this.surveyForm,
    required this.formValue,
    // required this.formFieldKeys,
    required this.currentPosition,
    required this.attachmentSave,
    required this.imageBuild,
    required this.customPainter,
    required this.locationData,
    this.apiCall,
    required this.onFileClicked,
    required this.hasGeolocation,
  });
  final SurveyPageForm surveyForm;
  final FormValue formValue;
  final Position? currentPosition;

  ///Widget for custom image painter
  final Widget Function(File imageFile) customPainter;

  ///Current Location
  final String locationData;

  final void Function(String stringURl) onFileClicked;
  final bool hasGeolocation;
  // final Map<String, GlobalKey<FormFieldState<dynamic>>> formFieldKeys;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  @override
  State<FormInputWidgets> createState() => FormInputWidgetsState();
}

class FormInputWidgetsState extends State<FormInputWidgets> {
  late final TableStateManager _tableManager;
  final Map<String, GlobalKey<FormFieldState>> _formFieldKeys = {};
  final Map<GlobalKey<FormFieldState<dynamic>>, String> _fieldKeyToIdMap = {};
  bool isScrolled = false;

  ScrollToId? scrollToId;
  final ScrollController scrollControllerId = ScrollController();

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
    _tableManager = TableStateManager(widget.formValue);
    
    // Initialize form field keys and table states
    for (var field in widget.surveyForm.inputFields) {
      _formFieldKeys[field.id] = GlobalKey<FormFieldState>();
      if (field is TableField) {
        _tableManager.initializeTable(field);
      }
    }

    scrollToId = ScrollToId(scrollController: scrollControllerId);

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
    scrollControllerId.dispose();
    _tableManager.dispose();
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

      /// Removes all the answers from the element and adds new id for each elements in the row
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

  void scrollToFirstInvalidField() {
    // Form is invalid, find the first invalid field and scroll to it
    FocusScope.of(context).requestFocus(FocusNode()); // Unfocus current field

    // item-9304eeab-4bd9-4010-a332-86ce9e2ddf43
    for (var entry in _fieldKeyToIdMap.entries) {
      var fieldKey = entry.key;
      var fieldId = entry.value;
      log('fieldId: $fieldId');
      log('fieldkey: $fieldKey');

      if (fieldKey.currentState != null) {
        if (!fieldKey.currentState!.validate()) {
          scrollToId?.animateTo(fieldId,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
          break;
        } else {
          log('fieldKey.currentState!.validate()2 ${fieldKey.currentState?.value}');
        }
      } else {
        log('fieldKey.currentState!.validate()1 ${fieldKey.currentState?.value}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveScrollViewer(
      scrollToId: scrollToId,
      scrollDirection: Axis.vertical,
      children: widget.surveyForm.inputFields
          .map<ScrollContent?>((e) => _buildInputField(e, context))
          .whereType<ScrollContent>()
          .toList(),
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
      files: (field) => _buildFilesInput(
        field,
        labelText,
        locationData: widget.locationData,
        customPainter: widget.customPainter,
      ),
      images: (field) => _buildImagesInput(
        field,
        labelText,
        locationData: widget.locationData,
        customPainter: widget.customPainter,
      ),
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
            FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              return text.isEmpty
                  ? newValue
                  : double.tryParse(text) == null
                      ? oldValue
                      : newValue;
            }),
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
  ScrollContent _buildFilesInput(FileInputField field, String labelText,
      {required String locationData,
      required Widget Function(File imageFile) customPainter}) {
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
          locationData: locationData,
          customPainter: customPainter,
        ),
      ),
    );
  }

  ///Images input field build method
  ScrollContent _buildImagesInput(ImageInputField field, String labelText,
      {required String locationData,
      required Widget Function(File imageFile) customPainter}) {
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
          locationData: locationData,
          customPainter: customPainter,
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
    return ScrollContent(
      id: field.id,
      child: TableInputWidget(
        field: field,
        labelText: labelText,
        isRequired: field.isRequired,
        tableManager: _tableManager,
        inputBuilder: (field, context, {haslabel = true}) {
          return _buildInputField(field, context, haslabel: haslabel) ?? 
              const SizedBox.shrink();
        },
      ),
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

/// A manager class that handles the state and operations for dynamic tables in forms.
/// 
/// This class manages:
/// - Table states and their modifications
/// - Row visibility
/// - Form value updates
/// - Row addition and generation
/// 
/// It extends [ChangeNotifier] to provide state change notifications to listeners.
class TableStateManager extends ChangeNotifier {
  /// Internal storage for table states indexed by table ID
  final Map<String, TableField> _tableStates = {};

  /// Tracks visibility of rows for each table
  final Map<String, List<bool>> _visibleRows = {};

  /// Reference to the form value object for persisting changes
  final FormValue formValue;

  /// Creates a new TableStateManager instance.
  /// 
  /// [formValue] is required to persist table state changes to the form.
  TableStateManager(this.formValue);

  /// Initializes a table's state with the provided field configuration.
  /// 
  /// This method:
  /// - Sets up the initial table state
  /// - Initializes row visibility
  /// - Saves the initial state to form value
  /// - Notifies listeners of the initialization
  /// 
  /// [field] The table field configuration to initialize
  void initializeTable(TableField field) {
    _tableStates[field.id] = field;
    _visibleRows[field.id] = 
        List.generate((field.inputFields ?? []).length, (_) => true);
    formValue.saveTableField(field.id, field);
    notifyListeners();
  }

  /// Adds a new row to the specified table.
  /// 
  /// This method:
  /// - Creates a new row based on the first row's template
  /// - Generates new unique IDs for all fields in the new row
  /// - Updates the table state with the new row
  /// - Updates row visibility
  /// - Persists changes to form value
  /// - Notifies listeners of the change
  /// 
  /// [field] The table field to add a row to
  Future<void> addRow(TableField field) async {
    if ((field.inputFields ?? []).isEmpty) return;

    List<InputField> newRow = (field.inputFields ?? [])[0].map((field) {
      return _generateNewFieldId(field);
    }).toList();

    List<List<InputField>> updatedRows = 
        List.from(field.inputFields ?? [])..add(newRow);
    
    TableField updatedField = field.copyWith(
      inputFields: updatedRows,
      id: field.id,
    );

    _tableStates[field.id] = updatedField;
    _visibleRows[field.id] = List.from(_visibleRows[field.id] ?? [])..add(true);
    formValue.saveTableField(field.id, updatedField);
    notifyListeners();
  }

  /// Retrieves the current state of a table by its ID.
  /// 
  /// Returns null if the table state doesn't exist.
  /// 
  /// [id] The ID of the table to retrieve
  TableField? getTableState(String id) => _tableStates[id];

  /// Gets the visibility state of rows for a specific table.
  /// 
  /// Returns an empty list if no visibility state exists.
  /// 
  /// [id] The ID of the table to get row visibility for
  List<bool> getVisibleRows(String id) => _visibleRows[id] ?? [];

  /// Generates a new unique ID for a field and its nested components.
  /// 
  /// This method:
  /// - Creates a deep copy of the field
  /// - Generates new UUIDs for all field IDs
  /// - Clears any existing answers or keys
  /// - Maintains other field properties
  /// 
  /// [field] The field to generate new IDs for
  /// Returns a new [InputField] with updated IDs
  InputField _generateNewFieldId(InputField field) {
    var uuid = const Uuid();
    
    Map<String, dynamic> updateId(Map<String, dynamic> item) {
      return Map.from(item).map((key, value) {
        if (key == 'id' && value is String) {
          return MapEntry(key, 'item-${uuid.v4()}');
        }
        if (key == 'key' || key == 'answer') {
          return MapEntry(key, null);
        }
        if (value is Map<String, dynamic>) {
          return MapEntry(key, updateId(value));
        }
        if (value is List) {
          return MapEntry(
              key,
              value.map((e) => 
                  e is Map<String, dynamic> ? updateId(e) : e).toList());
        }
        return MapEntry(key, value);
      });
    }

    return InputField.fromJson(updateId(field.toJson()));
  }
}

/// Table input widget that handles both row and column based layouts
class TableInputWidget extends StatefulWidget {
  final TableField field;
  final String labelText;
  final bool isRequired;
  final TableStateManager tableManager;
  final Widget Function(InputField, BuildContext, {bool haslabel}) inputBuilder;

  const TableInputWidget({
    super.key,
    required this.field,
    required this.labelText,
    required this.isRequired,
    required this.tableManager,
    required this.inputBuilder,
  });

  @override
  State<TableInputWidget> createState() => _TableInputWidgetState();
}

class _TableInputWidgetState extends State<TableInputWidget> {
  late TableField currentField;

  @override
  void initState() {
    super.initState();
    currentField = widget.tableManager.getTableState(widget.field.id) ?? widget.field;
    widget.tableManager.addListener(_onTableStateChanged);
  }

  @override
  void dispose() {
    widget.tableManager.removeListener(_onTableStateChanged);
    super.dispose();
  }

  void _onTableStateChanged() {
    setState(() {
      currentField = widget.tableManager.getTableState(widget.field.id) ?? widget.field;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LabeledWidget(
      labelText: widget.labelText,
      isRequired: widget.isRequired,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentField.isRow)
            _buildRowBasedTable(context)
          else
            _buildColumnBasedTable(context),
          
          const SizedBox(height: 8),
          
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            onPressed: () async {
              await widget.tableManager.addRow(currentField);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Row'),
          )
        ],
      ),
    );
  }

  Widget _buildRowBasedTable(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < (currentField.inputFields?.length ?? 0); index++)
          _buildTableRow(context, index),
      ],
    );
  }

  Widget _buildTableRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpandableWidget(
        key: ValueKey('table_row_${currentField.id}_$index'),
        expandableHeader: TableExpandableHeaderWidget(
          index: index,
          field: currentField,
        ),
        expandedHeader: TableExpandableHeaderWidget(
          index: index,
          field: currentField,
          isExpanded: true,
        ),
        expandableChild: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: (currentField.inputFields?[index] ?? []).map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.inputBuilder(item, context, haslabel: true),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnBasedTable(BuildContext context) {
    return Column(
      children: [
        for (int columnIndex = 0; 
             columnIndex < ((currentField.inputFields ?? [])[0]).length; 
             columnIndex++)
          _buildColumnSection(context, columnIndex),
      ],
    );
  }

  Widget _buildColumnSection(BuildContext context, int columnIndex) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpandableWidget(
        initialExpanded: true,
        expandableHeader: _buildColumnHeader(columnIndex, false),
        expandedHeader: _buildColumnHeader(columnIndex, true),
        expandableChild: Column(
          children: (currentField.inputFields ?? []).asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.inputBuilder(
                row[columnIndex], 
                context,
                haslabel: rowIndex <= 0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(int columnIndex, bool isExpanded) {
    return Padding(
      padding: EdgeInsets.only(bottom: isExpanded ? 8 : 0),
      child: Row(
        children: [
          Text('Column ${columnIndex + 1}'),
          const Spacer(),
          Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
        ],
      ),
    );
  }
}
