import 'package:json_annotation/json_annotation.dart';
import 'package:varicon_form_builder/src/models/value_text.dart';

///Value text converter
///
///Converts the value text to and from json
class ValueTextConverter implements JsonConverter<ValueText, dynamic> {
  const ValueTextConverter();

  @override
  ValueText fromJson(dynamic json) {
    if (json is String) {
      return ValueText(value: json, text: json);
    } else {
      return ValueText(
          value: json['value'] ?? json['id'],
          image: json['image'],
          text: json['text'] ?? json['label'],
          isOtherField: json['isOtherField'],
          notifyTo: json['notify_To'],
          previousReading: json['previous_reading'],
          engineType: json['engine_type'],
          action: json['action']);
    }
  }

  @override
  Map<String, dynamic> toJson(ValueText object) => {
        'id': object.value,
        'label': object.text,
        'action': object.action,
        'image': object.image,
        'isOtherField': object.isOtherField,
        'notify_To': object.notifyTo,
        'engine_type': object.engineType,
        'previous_reading': object.previousReading,
      };
}
