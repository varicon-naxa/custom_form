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

    /// Text that is displayed to the frontend.
    @JsonKey(readValue: readText) required String text,
  }) = _ValueText;

  const factory ValueText.none({
    @Default('none') String value,
    required String text,
    bool? action,
    bool? isOtherField,
  }) = NoneValueText;

  const factory ValueText.other({
    @Default('other') String value,
    required String text,
    bool? action,
    bool? isOtherField,
  }) = OtherValueText;

  factory ValueText.fromJson(Map<String, dynamic> json) =>
      _$ValueTextFromJson(json);
}

String readText(Map map, String key) => map[key] ?? map['label'] ?? '';
String readValue(Map map, String key) => map[key] ?? map['id'] ?? '';
