// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_page_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SurveyPageForm _$SurveyPageFormFromJson(Map<String, dynamic> json) {
  return _SurveyPageForm.fromJson(json);
}

/// @nodoc
mixin _$SurveyPageForm {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  String? get timesheet => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'isResponse')
  bool? get isResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'assign_to_display')
  List<String>? get assignToDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'need_action')
  bool? get needAction => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_by')
  String? get submittedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  String? get updatedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'submission_number')
  String? get submissionNumber => throw _privateConstructorUsedError;
  Map<String, dynamic>? get setting => throw _privateConstructorUsedError;
  Map<String, dynamic>? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'elements')
  @InputFieldConverter()
  List<InputField> get inputFields => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SurveyPageFormCopyWith<SurveyPageForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyPageFormCopyWith<$Res> {
  factory $SurveyPageFormCopyWith(
          SurveyPageForm value, $Res Function(SurveyPageForm) then) =
      _$SurveyPageFormCopyWithImpl<$Res, SurveyPageForm>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
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
      @JsonKey(name: 'submission_number') String? submissionNumber,
      Map<String, dynamic>? setting,
      Map<String, dynamic>? status,
      @JsonKey(name: 'elements')
      @InputFieldConverter()
      List<InputField> inputFields});
}

/// @nodoc
class _$SurveyPageFormCopyWithImpl<$Res, $Val extends SurveyPageForm>
    implements $SurveyPageFormCopyWith<$Res> {
  _$SurveyPageFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? timesheet = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? isResponse = freezed,
    Object? assignToDisplay = freezed,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
    Object? needAction = freezed,
    Object? submittedBy = freezed,
    Object? updatedBy = freezed,
    Object? submissionNumber = freezed,
    Object? setting = freezed,
    Object? status = freezed,
    Object? inputFields = null,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      timesheet: freezed == timesheet
          ? _value.timesheet
          : timesheet // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isResponse: freezed == isResponse
          ? _value.isResponse
          : isResponse // ignore: cast_nullable_to_non_nullable
              as bool?,
      assignToDisplay: freezed == assignToDisplay
          ? _value.assignToDisplay
          : assignToDisplay // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needAction: freezed == needAction
          ? _value.needAction
          : needAction // ignore: cast_nullable_to_non_nullable
              as bool?,
      submittedBy: freezed == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionNumber: freezed == submissionNumber
          ? _value.submissionNumber
          : submissionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: freezed == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      inputFields: null == inputFields
          ? _value.inputFields
          : inputFields // ignore: cast_nullable_to_non_nullable
              as List<InputField>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SurveyPageFormImplCopyWith<$Res>
    implements $SurveyPageFormCopyWith<$Res> {
  factory _$$SurveyPageFormImplCopyWith(_$SurveyPageFormImpl value,
          $Res Function(_$SurveyPageFormImpl) then) =
      __$$SurveyPageFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
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
      @JsonKey(name: 'submission_number') String? submissionNumber,
      Map<String, dynamic>? setting,
      Map<String, dynamic>? status,
      @JsonKey(name: 'elements')
      @InputFieldConverter()
      List<InputField> inputFields});
}

/// @nodoc
class __$$SurveyPageFormImplCopyWithImpl<$Res>
    extends _$SurveyPageFormCopyWithImpl<$Res, _$SurveyPageFormImpl>
    implements _$$SurveyPageFormImplCopyWith<$Res> {
  __$$SurveyPageFormImplCopyWithImpl(
      _$SurveyPageFormImpl _value, $Res Function(_$SurveyPageFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? timesheet = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? isResponse = freezed,
    Object? assignToDisplay = freezed,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
    Object? needAction = freezed,
    Object? submittedBy = freezed,
    Object? updatedBy = freezed,
    Object? submissionNumber = freezed,
    Object? setting = freezed,
    Object? status = freezed,
    Object? inputFields = null,
  }) {
    return _then(_$SurveyPageFormImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      timesheet: freezed == timesheet
          ? _value.timesheet
          : timesheet // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isResponse: freezed == isResponse
          ? _value.isResponse
          : isResponse // ignore: cast_nullable_to_non_nullable
              as bool?,
      assignToDisplay: freezed == assignToDisplay
          ? _value._assignToDisplay
          : assignToDisplay // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needAction: freezed == needAction
          ? _value.needAction
          : needAction // ignore: cast_nullable_to_non_nullable
              as bool?,
      submittedBy: freezed == submittedBy
          ? _value.submittedBy
          : submittedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      submissionNumber: freezed == submissionNumber
          ? _value.submissionNumber
          : submissionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: freezed == setting
          ? _value._setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      status: freezed == status
          ? _value._status
          : status // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      inputFields: null == inputFields
          ? _value._inputFields
          : inputFields // ignore: cast_nullable_to_non_nullable
              as List<InputField>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SurveyPageFormImpl implements _SurveyPageForm {
  const _$SurveyPageFormImpl(
      {@JsonKey(name: 'name') this.name,
      this.timesheet,
      @JsonKey(name: 'title') this.title,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'isResponse') this.isResponse,
      @JsonKey(name: 'assign_to_display') final List<String>? assignToDisplay,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'need_action') this.needAction,
      @JsonKey(name: 'submitted_by') this.submittedBy,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'submission_number') this.submissionNumber,
      final Map<String, dynamic>? setting,
      final Map<String, dynamic>? status,
      @JsonKey(name: 'elements')
      @InputFieldConverter()
      final List<InputField> inputFields = const <InputField>[]})
      : _assignToDisplay = assignToDisplay,
        _setting = setting,
        _status = status,
        _inputFields = inputFields;

  factory _$SurveyPageFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurveyPageFormImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  final String? timesheet;
  @override
  @JsonKey(name: 'title')
  final String? title;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'isResponse')
  final bool? isResponse;
  final List<String>? _assignToDisplay;
  @override
  @JsonKey(name: 'assign_to_display')
  List<String>? get assignToDisplay {
    final value = _assignToDisplay;
    if (value == null) return null;
    if (_assignToDisplay is EqualUnmodifiableListView) return _assignToDisplay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'need_action')
  final bool? needAction;
  @override
  @JsonKey(name: 'submitted_by')
  final String? submittedBy;
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;
  @override
  @JsonKey(name: 'submission_number')
  final String? submissionNumber;
  final Map<String, dynamic>? _setting;
  @override
  Map<String, dynamic>? get setting {
    final value = _setting;
    if (value == null) return null;
    if (_setting is EqualUnmodifiableMapView) return _setting;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _status;
  @override
  Map<String, dynamic>? get status {
    final value = _status;
    if (value == null) return null;
    if (_status is EqualUnmodifiableMapView) return _status;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<InputField> _inputFields;
  @override
  @JsonKey(name: 'elements')
  @InputFieldConverter()
  List<InputField> get inputFields {
    if (_inputFields is EqualUnmodifiableListView) return _inputFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputFields);
  }

  @override
  String toString() {
    return 'SurveyPageForm(name: $name, timesheet: $timesheet, title: $title, description: $description, isResponse: $isResponse, assignToDisplay: $assignToDisplay, updatedAt: $updatedAt, createdAt: $createdAt, needAction: $needAction, submittedBy: $submittedBy, updatedBy: $updatedBy, submissionNumber: $submissionNumber, setting: $setting, status: $status, inputFields: $inputFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyPageFormImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timesheet, timesheet) ||
                other.timesheet == timesheet) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isResponse, isResponse) ||
                other.isResponse == isResponse) &&
            const DeepCollectionEquality()
                .equals(other._assignToDisplay, _assignToDisplay) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.needAction, needAction) ||
                other.needAction == needAction) &&
            (identical(other.submittedBy, submittedBy) ||
                other.submittedBy == submittedBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.submissionNumber, submissionNumber) ||
                other.submissionNumber == submissionNumber) &&
            const DeepCollectionEquality().equals(other._setting, _setting) &&
            const DeepCollectionEquality().equals(other._status, _status) &&
            const DeepCollectionEquality()
                .equals(other._inputFields, _inputFields));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      timesheet,
      title,
      description,
      isResponse,
      const DeepCollectionEquality().hash(_assignToDisplay),
      updatedAt,
      createdAt,
      needAction,
      submittedBy,
      updatedBy,
      submissionNumber,
      const DeepCollectionEquality().hash(_setting),
      const DeepCollectionEquality().hash(_status),
      const DeepCollectionEquality().hash(_inputFields));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyPageFormImplCopyWith<_$SurveyPageFormImpl> get copyWith =>
      __$$SurveyPageFormImplCopyWithImpl<_$SurveyPageFormImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurveyPageFormImplToJson(
      this,
    );
  }
}

abstract class _SurveyPageForm implements SurveyPageForm {
  const factory _SurveyPageForm(
      {@JsonKey(name: 'name') final String? name,
      final String? timesheet,
      @JsonKey(name: 'title') final String? title,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'isResponse') final bool? isResponse,
      @JsonKey(name: 'assign_to_display') final List<String>? assignToDisplay,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'need_action') final bool? needAction,
      @JsonKey(name: 'submitted_by') final String? submittedBy,
      @JsonKey(name: 'updated_by') final String? updatedBy,
      @JsonKey(name: 'submission_number') final String? submissionNumber,
      final Map<String, dynamic>? setting,
      final Map<String, dynamic>? status,
      @JsonKey(name: 'elements')
      @InputFieldConverter()
      final List<InputField> inputFields}) = _$SurveyPageFormImpl;

  factory _SurveyPageForm.fromJson(Map<String, dynamic> json) =
      _$SurveyPageFormImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  String? get timesheet;
  @override
  @JsonKey(name: 'title')
  String? get title;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'isResponse')
  bool? get isResponse;
  @override
  @JsonKey(name: 'assign_to_display')
  List<String>? get assignToDisplay;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'need_action')
  bool? get needAction;
  @override
  @JsonKey(name: 'submitted_by')
  String? get submittedBy;
  @override
  @JsonKey(name: 'updated_by')
  String? get updatedBy;
  @override
  @JsonKey(name: 'submission_number')
  String? get submissionNumber;
  @override
  Map<String, dynamic>? get setting;
  @override
  Map<String, dynamic>? get status;
  @override
  @JsonKey(name: 'elements')
  @InputFieldConverter()
  List<InputField> get inputFields;
  @override
  @JsonKey(ignore: true)
  _$$SurveyPageFormImplCopyWith<_$SurveyPageFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
