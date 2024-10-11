import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:uuid/uuid.dart';
import 'package:varicon_form_builder/src/form_builder/widgets/custom_expand.dart';

import '../../scroll/src/scroll_content.dart';
import '../../scroll/src/scroll_to_id.dart';
import '../../varicon_form_builder.dart';
import '../models/form_value.dart';
import 'form_fields/date_time_form_field.dart';
import 'widgets/checkbox_input_widget.dart';
import 'widgets/custom_location.dart';
import 'widgets/datetime_input_widget.dart';
import 'widgets/dropdown_input_widget.dart';
import 'widgets/file_input_widget.dart';
import 'widgets/instruction_widget.dart';
import 'widgets/labeled_widget.dart';
import 'widgets/map_field_widget.dart';
import 'widgets/multi_signature_input_widget.dart';
import 'widgets/multple_input_widget.dart';
import 'widgets/phone_number_widget.dart';
import 'widgets/radio_input_widget.dart';
import 'widgets/signature_input_widget.dart';
import 'widgets/yes_no_na_input_widget.dart';
import 'widgets/yes_now_input_widget.dart';

class InputFieldsBody extends StatefulWidget {
  final List<InputField> inputfields;
  final Map<String, GlobalKey<FormFieldState<dynamic>>> formFieldKeys;
  final Map<GlobalKey<FormFieldState<dynamic>>, String> fieldKeyToIdMap;
  final ScrollToId? scrollToId;
  final FormValue formValue;
  final void Function(String url) onFileClicked;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final bool hasGeolocation;
  final Position? currentPosition;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;

  const InputFieldsBody({
    super.key,
    required this.inputfields,
    required this.formFieldKeys,
    required this.fieldKeyToIdMap,
    required this.scrollToId,
    required this.formValue,
    required this.onFileClicked,
    required this.imageBuild,
    required this.hasGeolocation,
    required this.currentPosition,
    required this.apiCall,
    required this.attachmentSave,
  });

  @override
  State<InputFieldsBody> createState() => _InputFieldsBodyState();
}

class _InputFieldsBodyState extends State<InputFieldsBody> {
  // Add this map to store table states
  final Map<String, TableField> _tableStates = {};

  // Add this map to store visible rows for each table
  final Map<String, List<bool>> _visibleRows = {};

  @override
  void initState() {
    super.initState();
    // Initialize table states
    for (var field in widget.inputfields) {
      if (field is TableField) {
        _tableStates[field.id] = field;
        _visibleRows[field.id] =
            List.generate(field.inputFields.length, (_) => true);
        widget.formValue.saveTableField(
          field.id,
          _tableStates[field.id]!,
        );
      } else if (field is AdvanceTableField) {
        widget.formValue.saveAdvanceTableField(
          field.id,
          field,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Uuid uuid = Uuid();

    InputField generateNewIdForField(InputField field) {
      Map<String, dynamic> updateId(Map<String, dynamic> item) {
        return Map.from(item).map((key, value) {
          if (key == 'id' && value is String) {
            return MapEntry(key, uuid.v4()); // Generate a new UUID
          }
          if (key == 'key') {
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

    return Column(
      children: widget.inputfields.map<Widget>((e) {
        final labelText = '${e.label ?? ''} ';

        return e.maybeMap(
          text: (field) {
            final HtmlEditorController htmlEditorController =
                HtmlEditorController();

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
                isRequired: e.isRequired,
                child: (field.name ?? '').toLowerCase().contains('long')
                    ? HtmlEditorWidget(
                        formCon: formCon,
                        fieldKey: widget.formFieldKeys[field.id],
                        field: field,
                        htmlEditorController: htmlEditorController,
                        editorOptions: editorOptions,
                        formValue: widget.formValue,
                      )
                    : (field.name ?? '').toLowerCase().contains('address')
                        ? MapFieldWidget(
                            fieldKey: widget.formFieldKeys[field.id],
                            // _fieldKeys[widget
                            //     .surveyForm.inputFields
                            //     .indexOf(e)],
                            isRequired: field.isRequired,
                            formValue: widget.formValue,
                            field: field,
                            forMapField: true,
                          )
                        : TextFormField(
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.deny(
                            //       RegExp(r'\s')),
                            // ],
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            initialValue: field.answer ?? '',
                            key: widget.formFieldKeys[field.id],
                            style: Theme.of(context).textTheme.bodyLarge,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLength: field.maxLength,
                            maxLines: (field.name ?? '')
                                    .toLowerCase()
                                    .contains('long')
                                ? 3
                                : 1,
                            onSaved: (newValue) {
                              // htmlEditorController
                              //     .editorController!
                              //     .clearFocus();
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
          },
          number: (field) {
            widget.formValue.saveString(
              field.id,
              field.answer,
            );
            return ScrollContent(
              id: field.id,
              child: LabeledWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: TextFormField(
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  initialValue: field.answer ?? '',
                  textInputAction: TextInputAction.next,
                  key: widget.formFieldKeys[field.id],
                  style: Theme.of(context).textTheme.bodyLarge,
                  readOnly: field.readOnly,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
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
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id], // Pass the key here
                  name: e.label ?? '',
                  initialValue: phoneNumber.number,
                  initialCountryCode: phoneNumber.countryISOCode,
                  invalidNumberMessage: 'Invalid Phone Number',
                  isRequired: e.isRequired,
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
          },
          email: (field) {
            widget.formValue.saveString(
              field.id,
              field.answer,
            );
            return ScrollContent(
              id: field.id,
              child: LabeledWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: TextFormField(
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  key: widget.formFieldKeys[field.id],
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
          },
          url: (field) {
            widget.formValue.saveString(
              field.id,
              field.answer,
            );
            return ScrollContent(
              id: field.id,
              child: LabeledWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: TextFormField(
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  key: widget.formFieldKeys[field.id],
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
          },
          date: (field) {
            widget.formValue.saveString(
              field.id,
              field.answer,
            );
            return ScrollContent(
              id: field.id,
              child: LabeledWidget(
                labelText: labelText,
                isRequired: e.isRequired,
                child: DateTimeInputWidget(
                  fieldKey: widget.formFieldKeys[field.id],
                  field: field,
                  dateTime: DatePickerType.date,
                  formValue: widget.formValue,
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
                  fieldKey: widget.formFieldKeys[field.id],
                  dateTime: DatePickerType.time,
                  formValue: widget.formValue,
                  // labelText: labelText,
                ),
              ),
            );
          },
          datetimelocal: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  dateTime: DatePickerType.dateTime,
                  formValue: widget.formValue,
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
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      initialValue: field.answer,
                      key: widget.formFieldKeys[field.id],
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
                      validator: (value) => textValidator(
                        value: value,
                        inputType: "comment",
                        isRequired: field.isRequired,
                        requiredErrorText: field.requiredErrorText,
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
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  apiCall: widget.apiCall,
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          yesno: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          radiogroup: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          yesnona: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          checkbox: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  apiCall: widget.apiCall,
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          multipleselect: (field) {
            widget.formValue.saveString(
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
                  fieldKey: widget.formFieldKeys[field.id],
                  apiCall: widget.apiCall,
                  formValue: widget.formValue,
                  labelText: labelText,
                ),
              ),
            );
          },
          files: (field) {
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
                isRequired: e.isRequired,
                child: FileInputWidget(
                  formCon: formCon,
                  emptyMsg: 'File is required',
                  filetype: FileType.any,
                  field: field,
                  fieldKey: widget.formFieldKeys[field.id],
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
          },
          images: (field) {
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
                isRequired: e.isRequired,
                child: FileInputWidget(
                  formCon: formCon,
                  fieldKey: widget.formFieldKeys[field.id],
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
          },
          signature: (field) {
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
                isRequired: e.isRequired,
                child: SignatureInputWidget(
                  field: field,
                  fieldKey: widget.formFieldKeys[field.id],
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
          },
          multisignature: (field) {
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
                isRequired: e.isRequired,
                child: MultiSignatureInputWidget(
                  field: field,
                  fieldKey: widget.formFieldKeys[field.id],
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
                    key: widget.formFieldKeys[field.id],
                    imageBuild: widget.imageBuild,
                  )),
            );
          },
          section: (field) {
            return ScrollContent(
              id: field.id,
              child: Padding(
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
              ),
            );
          },
          geolocation: (field) {
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
          advtable: (field) {
            return ScrollContent(
                id: field.id,
                child: field.isRow
                    ? Column(
                        children:
                            field.inputFields.asMap().entries.map((entry) {
                          final index = entry.key;
                          final e = entry.value;

                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: ExpandableWidget(
                              initialExpanded: true,
                              expandableHeader: Row(
                                children: [
                                  Text(
                                    'Row $index (${e.length} Questions)',
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
                                      'Row $index (${e.length} Questions)',
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                              expandableChild: InputFieldsBody(
                                inputfields: e,
                                formFieldKeys: widget.formFieldKeys,
                                fieldKeyToIdMap: widget.fieldKeyToIdMap,
                                scrollToId: widget.scrollToId,
                                formValue: widget.formValue,
                                onFileClicked: widget.onFileClicked,
                                imageBuild: widget.imageBuild,
                                hasGeolocation: widget.hasGeolocation,
                                currentPosition: widget.currentPosition,
                                apiCall: widget.apiCall,
                                attachmentSave: widget.attachmentSave,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Column(
                        children: [
                          for (int columnIndex = 0;
                              columnIndex < field.inputFields[0].length;
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
                                  children: field.inputFields
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final row = entry.value;

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: InputFieldsBody(
                                        inputfields: [row[columnIndex]],
                                        formFieldKeys: widget.formFieldKeys,
                                        fieldKeyToIdMap: widget.fieldKeyToIdMap,
                                        scrollToId: widget.scrollToId,
                                        formValue: widget.formValue,
                                        onFileClicked: widget.onFileClicked,
                                        imageBuild: widget.imageBuild,
                                        hasGeolocation: widget.hasGeolocation,
                                        currentPosition: widget.currentPosition,
                                        apiCall: widget.apiCall,
                                        attachmentSave: widget.attachmentSave,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ));
          },
          table: (field) {
            TableField table = _tableStates[field.id] ?? field;
            List<bool> visibleRows = _visibleRows[field.id] ?? [];
            List<List<InputField>> modifiedInputFields =
                table.inputFields.map((row) {
              return row.map((field) {
                return field.copyWith(
                  isRequired: table.isRequired ? field.isRequired : false,
                );
              }).toList();
            }).toList();

            return ScrollContent(
                id: field.id,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (table.isRow)
                      Column(
                        children:
                            modifiedInputFields.asMap().entries.map((entry) {
                          final index = entry.key;
                          final e = entry.value;
                          if (index >= visibleRows.length ||
                              !visibleRows[index]) {
                            return const SizedBox.shrink();
                          }

                          // Calculate the visible row number
                          final visibleRowNumber = visibleRows
                                  .sublist(0, index)
                                  .where((visible) => visible)
                                  .length +
                              1;

                          return Dismissible(
                            key: ValueKey('${field.id}_row_$index'),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                visibleRows[index] = false;
                                _visibleRows[field.id] = visibleRows;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Row $visibleRowNumber removed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      setState(() {
                                        visibleRows[index] = true;
                                        _visibleRows[field.id] = visibleRows;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: ExpandableWidget(
                                initialExpanded: true,
                                expandableHeader: Row(
                                  children: [
                                    Text(
                                      'Row $visibleRowNumber (${e.length} Questions)',
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
                                        'Row $visibleRowNumber (${e.length} Questions)',
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                                expandableChild: InputFieldsBody(
                                  inputfields: e,
                                  formFieldKeys: widget.formFieldKeys,
                                  fieldKeyToIdMap: widget.fieldKeyToIdMap,
                                  scrollToId: widget.scrollToId,
                                  formValue: widget.formValue,
                                  onFileClicked: widget.onFileClicked,
                                  imageBuild: widget.imageBuild,
                                  hasGeolocation: widget.hasGeolocation,
                                  currentPosition: widget.currentPosition,
                                  apiCall: widget.apiCall,
                                  attachmentSave: widget.attachmentSave,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    if (!table.isRow)
                      Column(
                        children: [
                          for (int columnIndex = 0;
                              columnIndex < modifiedInputFields[0].length;
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
                                  children: modifiedInputFields
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final rowIndex = entry.key;
                                    final row = entry.value;
                                    if (rowIndex >= visibleRows.length ||
                                        !visibleRows[rowIndex]) {
                                      return const SizedBox.shrink();
                                    }

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: InputFieldsBody(
                                        inputfields: [row[columnIndex]],
                                        formFieldKeys: widget.formFieldKeys,
                                        fieldKeyToIdMap: widget.fieldKeyToIdMap,
                                        scrollToId: widget.scrollToId,
                                        formValue: widget.formValue,
                                        onFileClicked: widget.onFileClicked,
                                        imageBuild: widget.imageBuild,
                                        hasGeolocation: widget.hasGeolocation,
                                        currentPosition: widget.currentPosition,
                                        apiCall: widget.apiCall,
                                        attachmentSave: widget.attachmentSave,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    AppSpacing.sizedBoxH_12(),

                    /// add action button here
                    TextButton.icon(
                      onPressed: () {
                        if (table.inputFields.isNotEmpty) {
                          List<InputField> newRow =
                              table.inputFields[0].map((field) {
                            return generateNewIdForField(field);
                          }).toList();

                          setState(() {
                            List<List<InputField>> updatedInputFields =
                                List.from(table.inputFields)..add(newRow);
                            _tableStates[field.id] =
                                table.copyWith(inputFields: updatedInputFields);
                            _visibleRows[field.id] =
                                List.from(_visibleRows[field.id] ?? [])
                                  ..add(true);
                          });
                          // Save the updated table state
                          widget.formValue.saveTableField(
                            field.id,
                            _tableStates[field.id]!,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xff98a5b9)),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Add Row',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ));
          },
          orElse: () => const SizedBox.shrink(),
        );
      }).toList(),
    );
  }
}
