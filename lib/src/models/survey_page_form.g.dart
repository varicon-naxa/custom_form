// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_page_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurveyPageFormImpl _$$SurveyPageFormImplFromJson(Map<String, dynamic> json) =>
    _$SurveyPageFormImpl(
      name: json['name'] as String?,
      id: json['id'] as String?,
      timesheet: json['timesheet'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      isResponse: json['isResponse'] as bool?,
      assignToDisplay: (json['assign_to_display'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      needAction: json['need_action'] as bool?,
      submittedBy: json['submitted_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      submissionNumber: json['submission_number'] as String?,
      formNumber: json['form_number'] as String?,
      timesheetNumber: json['timesheet_number'] as String?,
      equipment: json['equipment'] as String?,
      equipmentCode: json['equipment_code'] as String?,
      equipmentName: json['equipment_name'] as String?,
      project: json['project'] as String?,
      jobNumber: json['job_number'] as String?,
      setting: json['setting'] as Map<String, dynamic>?,
      status: json['status'] as Map<String, dynamic>?,
      inputFields: (json['elements'] as List<dynamic>?)
              ?.map((e) => const InputFieldConverter()
                  .fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <InputField>[],
    );

Map<String, dynamic> _$$SurveyPageFormImplToJson(
        _$SurveyPageFormImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'timesheet': instance.timesheet,
      'title': instance.title,
      'description': instance.description,
      'isResponse': instance.isResponse,
      'assign_to_display': instance.assignToDisplay,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'need_action': instance.needAction,
      'submitted_by': instance.submittedBy,
      'updated_by': instance.updatedBy,
      'submission_number': instance.submissionNumber,
      'form_number': instance.formNumber,
      'timesheet_number': instance.timesheetNumber,
      'equipment': instance.equipment,
      'equipment_code': instance.equipmentCode,
      'equipment_name': instance.equipmentName,
      'project': instance.project,
      'job_number': instance.jobNumber,
      'setting': instance.setting,
      'status': instance.status,
      'elements':
          instance.inputFields.map(const InputFieldConverter().toJson).toList(),
    };
