import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:varicon_form_builder/src/form_elements/form_file_picker.dart';
import 'package:varicon_form_builder/src/form_elements/form_image_picker.dart';
import 'package:varicon_form_builder/src/helpers/validators.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import 'package:varicon_form_builder/src/state/current_form_provider.dart';
import 'package:varicon_form_builder/src/widget/label_widget.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_text_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_number_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_email_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_phone_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_date_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_signature_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_multi_signature_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_radio_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_checkbox_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_dropdown_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_multi_dropdown_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_section_field.dart';
import '../custom_element/date_time_form_field.dart';
import '../form_elements/varicon_address_field.dart';
import '../form_elements/varicon_advance_table_field.dart';
import '../form_elements/varicon_instruction_field.dart';
import '../form_elements/varicon_long_text.dart';
import '../form_elements/varicon_other_radio_field.dart';
import '../form_elements/varicon_simple_table_field.dart';

class VariconInputFields extends ConsumerWidget {
  final InputField field;
  final bool hasLabel;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;
  final Widget Function(File imageFile) customPainter;
  final String locationData;
  final Function(Map<String, dynamic> url) fileClick;
  final bool hasCustomPainter;

  const VariconInputFields({
    super.key,
    required this.field,
    this.hasLabel = true,
    required this.imageBuild,
    required this.attachmentSave,
    required this.customPainter,
    this.apiCall,
    required this.locationData,
    required this.fileClick,
    required this.hasCustomPainter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debouncer debouncer = Debouncer(milliseconds: 500);

    String stripHtml(String text) {
      return text.trim().replaceAll(RegExp(r"<[^>]*>"), ' ');
    }

    final labelText = hasLabel ? '${field.label ?? ''} ' : '';
    return field.maybeMap(
      instruction: (data) {
        return LabelWidget(
            labelText: labelText,
            isRequired: false,
            child: VariconInstructionField(
              field: data,
              labelText: labelText,
              fileClick: fileClick,
              imageBuild: imageBuild,
            ));
      },
      text: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          isEditable: value.isEditable,
          labelText: labelText,
          child: (value.name ?? '').toLowerCase().contains('long')
              ? VariconLongText(
                  field: value,
                  validator: (value) {
                    final strippedValue = stripHtml(value ?? '');
                    return textValidator(
                      value: strippedValue,
                      inputType: "text",
                      isRequired: field.isRequired,
                      requiredErrorText: 'Long text is required',
                    );
                  },
                  onChanged: (data) {
                    // debouncer.run(() {
                    ref
                        .read(currentStateNotifierProvider.notifier)
                        .saveString(value.id, data);
                    // });
                  },
                  onSaved: (value) {
                    // Handle saved value
                  },
                )
              : (value.name ?? '').toLowerCase().contains('address')
                  ? VariconAddressField(
                      field: value,
                      labelText: labelText,
                    )
                  : VariconTextField(
                      field: value,
                      labelText: labelText,
                    ),
        );
      },
      number: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconNumberField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      email: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconEmailField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      phone: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconPhoneField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      date: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconDateField(
            field: value,
            dateTime: DatePickerType.date,
            labelText: labelText,
          ),
        );
      },
      time: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconDateField(
            field: value,
            dateTime: DatePickerType.time,
            labelText: labelText,
          ),
        );
      },
      datetimelocal: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconDateField(
            dateTime: DatePickerType.dateTime,
            field: value,
            labelText: labelText,
          ),
        );
      },
      signature: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconSignatureField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
            attachmentSave: attachmentSave,
          ),
        );
      },
      multisignature: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconMultiSignatureField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
            attachmentSave: attachmentSave,
          ),
        );
      },
      files: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: FormFilePicker(
            fileField: value,
            attachmentSave: attachmentSave,
            labelText: labelText,
            imageBuild: imageBuild,
          ),
          //  VariconFilePickerField(
          //   field: value,
          //   attachmentSave: attachmentSave,
          //   customPainter: customPainter,
          //   labelText: labelText,
          // ),
        );
      },
      images: (value) {
        return LabelWidget(
            key: GlobalObjectKey(value.id),
            isEditable: value.isEditable,
            isRequired: value.isRequired,
            labelText: labelText,
            child: FormImagePicker(
              hasCustomPainter: hasCustomPainter,
              imageField: value,
              labelText: labelText,
              locationData: locationData,
              imageBuild: imageBuild,
              customPainter: customPainter,
              attachmentSave: attachmentSave,
            )
            // VariconImageField(
            //   field: value,
            //   locationData: locationData,
            //   customPainter: customPainter,
            //   labelText: labelText,
            //   imageBuild: imageBuild,
            //   attachmentSave: attachmentSave,
            // ),
            );
      },
      radiogroup: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconRadioField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
        );
      },
      yesno: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconYesNoRadioField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
          ),
        );
      },
      yesnona: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconYesNoNaRadioField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
          ),
        );
      },
      checkbox: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconCheckboxField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
        );
      },
      dropdown: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconDropdownField(
            field: value,
            labelText: labelText,
            apiCall: apiCall,
          ),
        );
      },
      multipleselect: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          isRequired: value.isRequired,
          labelText: labelText,
          key: GlobalObjectKey(value.id),
          child: VariconMultiDropdownField(
            field: value,
            labelText: labelText,
            apiCall: apiCall,
          ),
        );
      },
      section: (value) {
        return VariconSectionField(
          field: value,
          labelText: labelText,
        );
      },
      table: (value) {
        return LabelWidget(
          isEditable: value.isEditable,
          isRequired: value.isRequired,
          labelText: labelText,
          hasSpacing: false,
          child: VariconSimpleTableField(
            field: value,
            customPainter: customPainter,
            fileClick: fileClick,
            labelText: '',
            imageBuild: imageBuild,
            apiCall: apiCall,
            locationData: locationData,
            attachmentSave: attachmentSave,
          ),
        );
      },
      advtable: (value) {
        return LabelWidget(
          isRequired: value.isRequired,
          labelText: labelText,
          hasSpacing: false,
          isEditable: value.isEditable,
          child: VariconAdvanceTableField(
            field: value,
            locationData: locationData,
            customPainter: customPainter,
            labelText: '',
            imageBuild: imageBuild,
            apiCall: apiCall,
            attachmentSave: attachmentSave,
            fileClick: fileClick,
          ),
        );
      },
      orElse: () {
        return const SizedBox.shrink();
      },
    );
  }
}
