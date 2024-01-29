part of 'varicon_form_builder.dart';

String? textValidator({
  required String? value,
  required String inputType,
  bool isRequired = false,
  String? requiredErrorText,
}) {
  if (isRequired && (value?.isEmpty ?? true)) {
    return requiredErrorText ?? 'Response required.';
  }

  if (inputType == "email" && (value ?? '').isNotEmpty) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? '')) {
      return 'Please enter a valid e-mail address.';
    }
  }
  return null;
}

String? requiredValidator({
  required String? value,
  bool isRequired = false,
  String? requiredErrorText,
}) {
  if (isRequired && (value?.isEmpty ?? true)) {
    return requiredErrorText ?? 'Response required.';
  }

  return null;
}

String? uriValidator({
  required String? value,
  bool isRequired = false,
  String? requiredErrorText,
}) {
  if (value == null || value.isEmpty) {
    // if value is empty or null.
    if (isRequired) {
      return requiredErrorText ?? 'Response required.';
    } else {
      return null;
    }
  }

  // value is not empty or null, must validate hen
  final isValidUri = RegExp(
          r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?")
      .hasMatch(value);

  if (!isValidUri) {
    return 'Please enter a valid URL.';
  }
  return null;
}

String? numberValidator({
  num? value,
  bool isRequired = false,
  String? requiredErrorText,
  num? max,
  String? maxErrorText,
  num? min,
  String? minErrorText,
}) {
  if (isRequired && (value == null)) {
    return requiredErrorText ?? 'Response required.';
  }

  if (min != null && value! < min) {
    return minErrorText ?? 'The value should not be less than $min';
  }
  if (max != null && value! > max) {
    return maxErrorText ?? 'The value should not be greater than $max';
  }

  return null;
}

String? ratingValidator({
  required double? value,
  bool isRequired = false,
  String? requiredErrorText,
}) {
  if (!isRequired) return null;

  if (value == null || value <= 0) {
    return requiredErrorText ?? 'Rating required.';
  }

  return null;
}

String? dateTimeValidator({
  required DateTime? value,
  bool isRequired = false,
  DateTime? min,
  DateTime? max,
  required String requiredErrorText,
  required String minErrorText,
  required String maxErrorText,
}) {
  if (value == null) {
    // if value is empty or null.
    if (isRequired) {
      return requiredErrorText;
    } else {
      return null;
    }
  }

  if (min != null) {
    if (value.isBefore(min)) {
      return minErrorText;
    }
  }
  if (max != null) {
    if (value.isAfter(max)) {
      return maxErrorText;
    }
  }

  return null;
}
