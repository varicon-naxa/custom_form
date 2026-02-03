// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'value_text.freezed.dart';
part 'value_text.g.dart';

@freezed
class ValueText with _$ValueText {
  const factory ValueText({
    /// Option Action to have color
    @JsonKey(name: 'isOtherField') bool? isOtherField,
    @JsonKey(name: 'action') bool? action,

    /// Value that is used for remote API consumption.
    @JsonKey(readValue: readValue) required String value,
    @JsonKey(name: 'notify_To') List? notifyTo,
    @JsonKey(name: 'engine_type') String? engineType,
    @JsonKey(name: 'previous_reading') String? previousReading,

    /// Text that is displayed to the frontend.
    @JsonKey(readValue: readText) required String text,

    /// Image data associated with this value text option.
    @JsonKey(name: 'image') Map<String, dynamic>? image,
  }) = _ValueText;

  const factory ValueText.none({
    @Default('none') String value,
    required String text,
    bool? action,
    bool? isOtherField,
    @JsonKey(name: 'notify_To') List? notifyTo,
    @JsonKey(name: 'engine_type') String? engineType,
    @JsonKey(name: 'previous_reading') String? previousReading,
    @JsonKey(name: 'image') Map<String, dynamic>? image,
  }) = NoneValueText;

  const factory ValueText.other({
    @Default('other') String value,
    required String text,
    bool? action,
    bool? isOtherField,
    @JsonKey(name: 'notify_To') List? notifyTo,
    @JsonKey(name: 'previous_reading') String? previousReading,
    @JsonKey(name: 'engine_type') String? engineType,
    @JsonKey(name: 'image') Map<String, dynamic>? image,
  }) = OtherValueText;

  factory ValueText.fromJson(Map<String, dynamic> json) =>
      _$ValueTextFromJson(json);
}

String readText(Map map, String key) => map[key] ?? map['label'] ?? '';
String readValue(Map map, String key) => map[key] ?? map['id'] ?? '';
