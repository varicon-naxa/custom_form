// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../json_converters/input_field_converter.dart';
import 'input_field.dart';
part 'survey_page_form.freezed.dart';
part 'survey_page_form.g.dart';

// /pages
@freezed
class SurveyPageForm with _$SurveyPageForm {
  const factory SurveyPageForm({
    @JsonKey(name: 'name') String? name,
    String? timesheet,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isResponse') bool? isResponse,
    @JsonKey(name: 'assign_to_display') List<String>? assignToDisplay,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'need_action') bool? needAction,
    @JsonKey(name: 'submitted_by') String? submittedBy,
    @JsonKey(name: 'updated_by') String? updatedBy,
    Map<String, dynamic>? setting,
    Map<String, dynamic>? status,
    @JsonKey(name: 'elements')
    @InputFieldConverter()
    @Default(<InputField>[])
    List<InputField> inputFields,
  }) = _SurveyPageForm;

  factory SurveyPageForm.fromJson(Map<String, dynamic> json) =>
      _$SurveyPageFormFromJson(json);
}
