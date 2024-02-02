import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final double fontSize;
  final double borerRadius;
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
        constraints: const BoxConstraints(maxWidth: 120.0),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: fontSize, height: 1, color: textColor),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(
              borerRadius,
            ),
            border: Border.all(color: borderColor ?? buttonColor)),
      ),
    );
  }
}
