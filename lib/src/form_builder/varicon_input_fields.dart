import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/models/models.dart';
import 'package:varicon_form_builder/src/widget/label_widget.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_text_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_number_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_email_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_phone_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_date_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_signature_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_multi_signature_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_file_picker_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_image_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_radio_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_checkbox_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_dropdown_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_multi_dropdown_field.dart';
import 'package:varicon_form_builder/src/form_elements/varicon_section_field.dart';
import '../custom_element/date_time_form_field.dart';
import '../form_elements/varicon_address_field.dart';
import '../form_elements/varicon_advance_table_field.dart';
import '../form_elements/varicon_long_text.dart';
import '../form_elements/varicon_other_radio_field.dart';
import '../form_elements/varicon_simple_table_field.dart';

class VariconInputFields extends StatelessWidget {
  final InputField field;
  final bool hasLabel;
  final Widget Function(Map<String, dynamic>) imageBuild;
  final Future<List<Map<String, dynamic>>> Function(List<String>)
      attachmentSave;
  final Future<List<dynamic>> Function(Map<String, dynamic>)? apiCall;

  const VariconInputFields({
    super.key,
    required this.field,
    this.hasLabel = true,
    required this.imageBuild,
    required this.attachmentSave,
    this.apiCall,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = hasLabel ? '${field.label ?? ''} ' : '';
    return field.maybeMap(
      text: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: (value.name ?? '').toLowerCase().contains('long')
              ? VariconLongText(
                  field: value,
                  formCon: TextEditingController(),
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
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconFilePickerField(
            field: value,
            attachmentSave: attachmentSave,
            labelText: labelText,
          ),
        );
      },
      images: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconImageField(
            field: value,
            labelText: labelText,
            imageBuild: imageBuild,
            attachmentSave: attachmentSave,
          ),
        );
      },
      radiogroup: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconRadioField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      yesno: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconYesNoRadioField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      yesnona: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconYesNoNaRadioField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      checkbox: (value) {
        return LabelWidget(
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          child: VariconCheckboxField(
            field: value,
            labelText: labelText,
          ),
        );
      },
      dropdown: (value) {
        return LabelWidget(
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
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
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
          key: GlobalObjectKey(value.id),
          isRequired: value.isRequired,
          labelText: labelText,
          hasSpacing: false,
          child: VariconSimpleTableField(
            field: value,
            labelText: '',
            imageBuild: imageBuild,
            apiCall: apiCall,
            attachmentSave: attachmentSave,
          ),
        );
      },
      advtable: (value) {
        return LabelWidget(
          isRequired: value.isRequired,
          labelText: labelText,
          hasSpacing: false,
          child: VariconAdvanceTableField(
            field: value,
            labelText: '',
            imageBuild: imageBuild,
            apiCall: apiCall,
            attachmentSave: attachmentSave,
          ),
        );
      },
      orElse: () {
        return const SizedBox.shrink();
      },
    );
  }
}
