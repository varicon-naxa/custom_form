import 'package:example_form/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  const AppTextStyle._();

  ///  [displayLarge = displayLarge ?? headline1,]
  static TextStyle displayLarge = GoogleFonts.roboto(
      fontSize: 96,
      height: 1.167,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5);

  ///  [displayMedium = displayMedium ?? headline2,]
  static TextStyle displayMedium = GoogleFonts.roboto(
      fontSize: 60,
      color: Palette.primaryColor,
      height: 1.2,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5);

  ///  [displaySmall = displaySmall ?? headline3,]
  static TextStyle displaySmall = GoogleFonts.roboto(
    fontSize: 48,
    height: 1.167,
    color: Palette.primaryColor,
    fontWeight: FontWeight.w400,
  );

  ///  [headlineMedium = headlineMedium ?? headline4,]
  static TextStyle headlineMedium = GoogleFonts.roboto(
      fontSize: 24,
      height: 1.35,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15);

  ///  [headlineSmall = headlineSmall ?? headline5,]
  static TextStyle headlineSmall = GoogleFonts.roboto(
      fontSize: 22,
      height: 1.334,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0);

  ///  [titleLarge = titleLarge ?? headline6,]
  static TextStyle titleLarge = GoogleFonts.roboto(
      fontSize: 22,
      height: 1,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15);

  ///  [titleMedium = titleMedium ?? subtitle1,]
  static TextStyle titleMedium = GoogleFonts.roboto(
      fontSize: 16,
      height: 1.75,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15);

  ///  [titleSmall = titleSmall ?? subtitle2,]
  static TextStyle titleSmall = GoogleFonts.roboto(
      fontSize: 14,
      height: 1.57,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15);

  ///  [bodyLarge = bodyLarge ?? bodyText1,]
  static TextStyle bodyLarge = GoogleFonts.roboto(
      fontSize: 16,
      height: 1.75,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15);

  ///  [bodyMedium = bodyMedium ?? bodyText2,]
  static TextStyle bodyMedium = GoogleFonts.roboto(
      fontSize: 14,
      height: 1.43,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15);

  ///  [labelLarge = labelLarge ?? button,]
  static TextStyle labelLarge = GoogleFonts.roboto(
      fontSize: 16,
      height: 1.75,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15);

  ///  [bodySmall = bodySmall ?? caption,]
  static TextStyle bodySmall = GoogleFonts.roboto(
      fontSize: 12,
      height: 1.5,
      color: Palette.secondaryTextColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4);

  ///  [labelSmall = labelSmall ?? overline;]
  static TextStyle labelSmall = GoogleFonts.roboto(
      fontSize: 12,
      height: 1.5,
      color: Palette.primaryColor,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1);
}
