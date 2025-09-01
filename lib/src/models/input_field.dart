// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:varicon_form_builder/src/json_converters/input_field_converter.dart';
import 'package:varicon_form_builder/src/json_converters/value_text_converter.dart';
import 'package:varicon_form_builder/src/models/single_signature.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

part 'input_field.freezed.dart';
part 'input_field.g.dart';

// /pages/elements
@Freezed(unionKey: 'type', fallbackUnion: 'fallback')
class InputField with _$InputField implements BasicInputField {
  // InputField that is not supported.
  const factory InputField.fallback({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = _FallbackInputField;

  const factory InputField.text({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = TextInputField;

  const factory InputField.signature({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'answer') Map<String, dynamic>? answer,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = SignatureInputField;

  const factory InputField.multisignature(
          {@JsonKey(name: 'id') required String id,
          @JsonKey(name: 'label') String? label,
          @JsonKey(name: 'name') String? name,
          @JsonKey(name: 'description') String? description,
          @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
          @JsonKey(name: 'answer') List<SingleSignature>? answer,
          @JsonKey(name: 'is_editable') @Default(true) bool isEditable}) =
      MultiSignatureInputField;

  const factory InputField.date({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = DateInputField;

  const factory InputField.instruction({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'name') String? name,
    @JsonKey(readValue: readInstruction) String? instruction,
    String? description,
    @JsonKey(name: 'attachments') List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = InstructionInputField;

  const factory InputField.section({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'instruction') String? instruction,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = SectionInputField;

  const factory InputField.time({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = TimeInputField;

  const factory InputField.url({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = UrlInputField;

  const factory InputField.number({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = NumberInputField;

  const factory InputField.phone({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    // @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    // @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    // @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    // // Fields.
    // @JsonKey(name: 'placeholder') String? hintText,
    // @JsonKey(name: 'maxLength') int? maxLength,

    // // For number field validation.
    // @JsonKey(name: 'min') dynamic min,
    // @JsonKey(name: 'minErrorText') String? minErrorText,
    // @JsonKey(name: 'max') dynamic max,
    // @JsonKey(name: 'maxErrorText') String? maxErrorText,
  }) = PhoneInputField;

  const factory InputField.email({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = EmailInputField;

  const factory InputField.datetimelocal({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = DateTimeInputField;

  const factory InputField.comment({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = CommentInputField;

  const factory InputField.dropdown({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @Default(true) @JsonKey(name: 'fromManualList') bool fromManualList,
    @JsonKey(name: 'selectedLinkListLabel') String? answerList,
    @JsonKey(name: 'islinked_query') String? linkedQuery,
    @JsonKey(name: 'isConditional') bool? isConditional,
    @JsonKey(name: 'actionMessage') String? actionMessage,
    @JsonKey(name: 'association') bool? association,

    // Fields.
    @JsonKey(name: 'allowClear') @Default(true) bool allowClear,
    @JsonKey(name: 'placeholder') String? hintText,
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
  }) = DropdownInputField;

  const factory InputField.multipleselect({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'association') bool? association,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'actionMessage') String? actionMessage,
    @JsonKey(name: 'isConditional') @Default(false) bool isConditional,
    @Default(true) @JsonKey(name: 'fromManualList') bool fromManualList,
    // Fields.
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    @JsonKey(name: 'maxSelectedChoices') int? maxSelectedChoices,
    @JsonKey(name: 'selectedLinkListLabel') String? answerList,
    @JsonKey(name: 'islinked_query') String? linkedQuery,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherErrorText') String? otherErrorText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
    // Select All
    @JsonKey(name: 'showSelectAllItem') @Default(false) bool showSelectAllItem,
  }) = MultipleInputField;

  const factory InputField.checkbox({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'actionMessage') String? actionMessage,
    @JsonKey(name: 'association') bool? association,
    @JsonKey(name: 'isConditional') @Default(false) bool isConditional,
    @Default(true) @JsonKey(name: 'fromManualList') bool fromManualList,
    @JsonKey(name: 'selectedLinkListLabel') String? answerList,
    @JsonKey(name: 'islinked_query') String? linkedQuery,
    // Fields.
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    @JsonKey(name: 'maxSelectedChoices') int? maxSelectedChoices,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
    // Select All
    @JsonKey(name: 'showSelectAllItem') @Default(false) bool showSelectAllItem,
  }) = CheckboxInputField;

  const factory InputField.radiogroup({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'association') bool? association,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'actionMessage') String? actionMessage,
    @JsonKey(name: 'selectedLinkListLabel') String? selectedLinkListLabel,
    @JsonKey(name: 'isConditional') @Default(false) bool isConditional,

    // Fields.
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherAnswer') String? otherAnswer,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherErrorText') String? otherErrorText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
    // Show clear
    @JsonKey(name: 'showClearButton') @Default(false) bool showClearButton,
  }) = RadioInputField;

  const factory InputField.yesno({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'isConditional') @Default(false) bool isConditional,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'selectedLinkListLabel') String? selectedLinkListLabel,
    @JsonKey(name: 'actionMessage') String? actionMessage,

    // Fields.
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherErrorText') String? otherErrorText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
    // Show clear
    @JsonKey(name: 'showClearButton') @Default(false) bool showClearButton,
  }) = YesNoInputField;

  const factory InputField.yesnona({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'actionMessage') String? actionMessage,
    @JsonKey(name: 'isConditional') @Default(false) bool isConditional,
    @JsonKey(name: 'selectedLinkListLabel') String? selectedLinkListLabel,

    // Fields.
    @JsonKey(name: 'choice')
    @Default([])
    @ValueTextConverter()
    List<ValueText> choices,
    // None
    @JsonKey(name: 'showNoneItem') @Default(false) bool showNoneItem,
    @JsonKey(name: 'noneText') String? noneText,
    // Other
    @JsonKey(name: 'showOtherItem') @Default(false) bool showOtherItem,
    @JsonKey(name: 'otherText') String? otherText,
    @JsonKey(name: 'otherErrorText') String? otherErrorText,
    @JsonKey(name: 'otherPlaceholder') String? otherPlaceholder,
    // Show clear
    @JsonKey(name: 'showClearButton') @Default(false) bool showClearButton,
  }) = YesNoNaInputField;

  const factory InputField.files({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') List<Map<String, dynamic>>? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isMultiple') @Default(false) bool isMultiple,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = FileInputField;

  const factory InputField.images({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') List<Map<String, dynamic>>? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isMultiple') @Default(false) bool isMultiple,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = ImageInputField;

  const factory InputField.geolocation({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'answer') Map<String, dynamic>? answer,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
  }) = GeolocationField;

  const factory InputField.map({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'addressLine') String? addressLine,
    @JsonKey(name: 'answer') String? answer,
    @JsonKey(name: 'description') String? description,
  }) = MapField;

  const factory InputField.table({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'tableId') String? tableId,
    List<String>? headers,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'answer') dynamic answer,
    @JsonKey(name: 'isRow') @Default(true) bool isRow,
    @JsonKey(name: 'contents')
    @InputFieldConverter()
    // @Default(<InputField>[])
    List<List<InputField>>? inputFields,
  }) = TableField;
  const factory InputField.advtable({
    @JsonKey(name: 'id') required String id,
    List<String>? headers,
    @JsonKey(name: 'tableId') String? tableId,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'isRequired') @Default(false) bool isRequired,
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,
    @JsonKey(name: 'requiredErrorText') String? requiredErrorText,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'visible') @Default(true) bool visible,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'answer') dynamic answer,
    @JsonKey(name: 'isRow') @Default(true) bool isRow,
    @JsonKey(name: 'contents')
    @InputFieldConverter()
    // @Default(<InputField>[])
    List<List<InputField>>? inputFields,
  }) = AdvTableField;

  factory InputField.fromJson(Map<String, dynamic> json) =>
      _$InputFieldFromJson(json);
}

abstract class BasicInputField {
  BasicInputField(
    this.id,
    this.label,
    this.description,
    this.isRequired,
    this.isEditable,
  );

  final String id;
  final String? label;
  final String? description;
  final bool? isRequired;
  final bool isEditable;
}

String? readInstruction(Map map, String key) => map[key] ?? map['description'];
