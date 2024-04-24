import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/core/debouncer.dart';

///Themed search text field widget
///
///Accepts name, hintText, onChange, controllerText, enable, maxLength, labelText, suffixicon and onEditingComplete
class ThemeSearchField extends StatelessWidget {
  ThemeSearchField(
      {super.key,
      required this.name,
      required this.hintText,
      required this.onChange,
      required this.controllerText,
      this.enable,
      this.maxLength,
      this.labelText,
      this.suffixicon,
      this.onEditingComplete});

  ///Search field name
  final String name;

  ///Search field hint text
  final String hintText;

  ///Search field label text
  final String? labelText;

  ///Search field enable boolean
  final bool? enable;

  ///Search field on change function
  final Function(String) onChange;

  ///Search field controller
  final TextEditingController? controllerText;

  ///Search field max length
  final int? maxLength;

  ///Search field suffix icon
  final Widget? suffixicon;

  ///Search field on editing complete function
  final Function()? onEditingComplete;

  ///Search optimization with debounce during search
  final debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    final controller = controllerText;
    return Theme(
      data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color(0xffFBAD33),
            cursorColor: Color(0xffFBAD33),
            selectionHandleColor: Color(0xffFBAD33),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
            ),
          )),
      child: TextFormField(
        onChanged: (a) {
          debouncer.run(() {
            onChange(a);
          });
        },
        key: key,
        decoration: InputDecoration(
          hintText: 'Search ',
          prefixIcon: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xff233759),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.check,
              color: Color(0xff233759),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
          ),
        ),
        maxLength: maxLength,
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
