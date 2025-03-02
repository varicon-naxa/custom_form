// ignore_for_file: deprecated_member_use

import 'package:example_form/theme/app_text_style.dart';
import 'package:example_form/theme/palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final defaultTheme = ThemeData(
    unselectedWidgetColor: Colors.grey,
    primarySwatch: Colors.green,
    primaryColor: Palette.primaryColor,
    scaffoldBackgroundColor: Palette.mainBackground,
    hoverColor: Palette.ktoastsucess,
    dialogBackgroundColor: Colors.white,
    primaryColorLight: Palette.primaryColorLight,
    primaryColorDark: Palette.primaryColorDark,
    hintColor: Colors.white,
    canvasColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      headerForegroundColor: Colors.white,
      headerBackgroundColor: Palette.primary,
      shadowColor: Colors.white,
      //u need to match the text color also
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Palette.primary;
        }
        return Colors.white;
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Palette.primary,
      cursorColor: Palette.primary,
      selectionHandleColor: Palette.primary,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      textStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.primaryColor,
      elevation: 2,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.5),
    ),
    // hintColor: Palette.navyBackground,

    dividerTheme: const DividerThemeData(
      color: Palette.seperatorColor,
    ),
    iconTheme: const IconThemeData(
      color: Palette.primaryColor,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    colorScheme: const ColorScheme(
      background: Palette.background,
      brightness: Brightness.light,
      error: Palette.error,
      onBackground: Palette.onBackground,
      onError: Palette.error,
      onPrimary: Palette.onPrimary,
      surfaceTint: Colors.white,
      onSecondary: Palette.secondary,
      onSurface: Palette.secondaryTextColor,
      // onSurface: Palette.onBackground,
      primary: Palette.primary,
      // primaryVariant: Palette.primaryVariant,
      secondary: Palette.secondary,
      secondaryContainer: Palette.secondaryContainer,
      surface: Palette.background,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.displayLarge,
      displayMedium: AppTextStyle.displayMedium,
      displaySmall: AppTextStyle.displaySmall,
      headlineMedium: AppTextStyle.headlineMedium,
      headlineSmall: AppTextStyle.headlineSmall,
      titleLarge: AppTextStyle.titleLarge,
      titleMedium: AppTextStyle.titleMedium,
      titleSmall: AppTextStyle.titleSmall,
      bodyLarge: AppTextStyle.bodyLarge,
      bodyMedium: AppTextStyle.bodyMedium,
      labelLarge: AppTextStyle.labelLarge,
      bodySmall: AppTextStyle.bodySmall,
      labelSmall: AppTextStyle.labelSmall,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
          color: Palette.primaryColor), // Set border side color to black
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      collapsedIconColor: Palette.secondary,
      iconColor: Palette.primary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 23, vertical: 14),
      isDense: true,
      hintStyle:
          AppTextStyle.bodyMedium.copyWith(color: Palette.secondary, height: 1),
      labelStyle:
          AppTextStyle.bodyMedium.copyWith(color: Palette.secondary, height: 1),
      // counterStyle:AppTextStyle.body2.copyWith(color: Palette.primaryTextColor),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.6),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryColor, width: 0.6),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Palette.error, width: 0.6),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Palette.error, width: 0.6),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryColor, width: 0.6),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          return (states.contains(MaterialState.selected))
              ? Palette.primary
              : Palette.secondaryTextColor;
        },
      ),
    ),
  );

}
