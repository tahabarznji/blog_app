import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 3,
          color: color,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      side: BorderSide.none,
    ),
    appBarTheme: const AppBarTheme()
        .copyWith(backgroundColor: AppPallete.backgroundColor),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(AppPallete.gradient2),
        errorBorder: _border(AppPallete.errorColor)),
  );
}
