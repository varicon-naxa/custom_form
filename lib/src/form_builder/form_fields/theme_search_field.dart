import 'package:flutter/material.dart';
import 'package:varicon_form_builder/src/core/debouncer.dart';

///Themed search text field widget
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
  final String name;
  final String hintText;
  final String? labelText;
  final bool? enable;
  final Function(String) onChange;
  final TextEditingController? controllerText;
  final int? maxLength;
  final Widget? suffixicon;
  final Function()? onEditingComplete;
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
