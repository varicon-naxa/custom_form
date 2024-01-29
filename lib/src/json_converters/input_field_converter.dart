import 'package:json_annotation/json_annotation.dart';
import 'package:varicon_form_builder/src/models/models.dart';

class InputFieldConverter
    implements JsonConverter<InputField, Map<String, dynamic>> {
  const InputFieldConverter();

  @override
  InputField fromJson(Map<String, dynamic> json) {
    // final inputType = json['type'];
    return InputField.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InputField object) => {'default': object};
}
