import 'package:flutter/material.dart';

class AppColors {
  // Core colors
  static const Color accent = Color(0xff1ab7c3);
  static const Color text = Color(0xff212121);
  static const Color textLight = Color(0xff8a8a8a);
  static const Color white = Color(0xffffffff);

  // Status colors
  static const Color success = Color(0xff28a745); // Green for success
  static const Color error = Color(0xffdc3545);   // Red for error
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.text),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.accent,
    ),
  );
}

class TextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 48,
  );

  static const TextStyle heading2 = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 32,
  );

  static const TextStyle heading3 = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 24,
  );

  // Body Text
  static const TextStyle body1 = TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 18,
  );

  static const TextStyle body2 = TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 16,
  );

  // Status Text Styles
  static const TextStyle success = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.success,
    fontSize: 16,
  );

  static const TextStyle error = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.error,
    fontSize: 16,
  );
}
