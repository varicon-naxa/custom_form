import 'package:flutter/material.dart';

///Action button widget
///
///Accepts button text, button color, text color, border color, on pressed, font size, border radius and vertical padding
class ActionButton extends StatelessWidget {
  ///Button text to be shown
  final String buttonText;

  ///Button color for button
  final Color buttonColor;

  ///Text color for button
  final Color textColor;

  ///Border color for button
  final Color? borderColor;

  ///On pressed function
  final VoidCallback onPressed;

  ///Font size for button text
  final double fontSize;

  ///Border radius for button
  final double borerRadius;

  ///Vertical padding for button
  final double verticalPadding;

  const ActionButton(
      {super.key,
      this.buttonColor = const Color(0xffFBAD33),
      this.textColor = const Color(0xff233759),
      required this.buttonText,
      this.borerRadius = 4,
      this.borderColor = const Color(0xffFBAD33),
      this.fontSize = 14,
      this.verticalPadding = 18,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(
            borerRadius,
          ),
          border: Border.all(color: borderColor ?? buttonColor),
        ),
        child: Text(
          buttonText,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: fontSize, height: 1, color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
