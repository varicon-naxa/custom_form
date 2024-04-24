part of 'varicon_form_builder.dart';

// TextInputType getKeyboardType(InputType inputType) {
//   switch (inputType) {
//     case InputType.text:
//       return TextInputType.text;
//     case InputType.email:
//       return TextInputType.emailAddress;
//     case InputType.url:
//       return TextInputType.url;
//     case InputType.number:
//       return TextInputType.number;
//     case InputType.date:
//       return TextInputType.datetime;
//     case InputType.time:
//       return TextInputType.datetime;
//     case InputType.datetime:
//       return TextInputType.datetime;
//   }
// }

///Predefined class for custom form spacing
class AppSpacing {
  const AppSpacing._();

  ///Spacing components for height
  ///
  ///Contains multiple height values
  static Widget sizedBoxH_02() => const SizedBox(height: 2);
  static Widget sizedBoxH_04() => const SizedBox(height: 4);
  static Widget sizedBoxH_05() => const SizedBox(height: 5);
  static Widget sizedBoxH_06() => const SizedBox(height: 6);
  static Widget sizedBoxH_08() => const SizedBox(height: 8);
  static Widget sizedBoxH_10() => const SizedBox(height: 10);
  static Widget sizedBoxH_12() => const SizedBox(height: 12);
  static Widget sizedBoxH_16() => const SizedBox(height: 16);
  static Widget sizedBoxH_20() => const SizedBox(height: 20);

  ///Spacing components for width
  ///
  ///Contains multiple width values
  static Widget sizedBoxW_02() => const SizedBox(width: 2);
  static Widget sizedBoxW_04() => const SizedBox(width: 4);
  static Widget sizedBoxW_05() => const SizedBox(width: 5);
  static Widget sizedBoxW_06() => const SizedBox(width: 6);
  static Widget sizedBoxW_08() => const SizedBox(width: 8);
  static Widget sizedBoxW_10() => const SizedBox(width: 10);
  static Widget sizedBoxW_12() => const SizedBox(width: 12);
  static Widget sizedBoxW_14() => const SizedBox(width: 14);
  static Widget sizedBoxW_16() => const SizedBox(width: 16);
  static Widget sizedBoxW_20() => const SizedBox(width: 20);
}
