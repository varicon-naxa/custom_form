import 'package:example/button_page.dart';
import 'package:example/theme/app_theme.dart';
import 'package:example/theme/palette.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.defaultTheme.copyWith(
          // bottomSheetTheme: AppTheme.defaultTheme.bottomSheetTheme
          //     .copyWith(backgroundColor: Colors.white),
          dialogTheme: AppTheme.defaultTheme.dialogTheme.copyWith(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Palette.primary,
            cursorColor: Palette.primary,
            selectionHandleColor: Palette.primary,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const ButtonPage(),
    );
  }
}
