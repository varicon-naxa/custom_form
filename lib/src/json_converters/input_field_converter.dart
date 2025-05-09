import 'package:json_annotation/json_annotation.dart';
import 'package:varicon_form_builder/src/models/models.dart';

///Form field input field converter
///
///Converts the input field to and from json
class InputFieldConverter
    implements JsonConverter<InputField, Map<String, dynamic>> {
  const InputFieldConverter();

  @override
  InputField fromJson(Map<String, dynamic> json) {
    return InputField.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InputField object) => object.toJson();
}
