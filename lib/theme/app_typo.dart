import 'package:flutter/material.dart';

class AppFontWeight {
  final FontWeight regular;
  final FontWeight medium;
  final FontWeight semibold;
  final FontWeight bold;
  final FontWeight extraBold;
  final FontWeight black;

  AppFontWeight({
    required this.regular,
    required this.medium,
    required this.semibold,
    required this.bold,
    required this.extraBold,
    required this.black,
  });

  static AppFontWeight defaultFontWeight() {
    return AppFontWeight(
      regular: FontWeight.w400,
      medium: FontWeight.w500,
      semibold: FontWeight.w600,
      bold: FontWeight.w700,
      extraBold: FontWeight.w800,
      black: FontWeight.w900,
    );
  }
}

class AppTypo extends ThemeExtension<AppTypo> {
  static TextTheme defaultTextTheme() {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.normal, letterSpacing: 0.0),
      headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.normal, letterSpacing: 0.25),
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, letterSpacing: 0.0),
      titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, letterSpacing: 0.15),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, letterSpacing: 0.5),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
      labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, letterSpacing: 1.5),
    );
  }

  final AppFontWeight fw;
  final TextStyle appBarTitle;

  AppTypo({
    required this.fw,
    required this.appBarTitle,
  });

  @override
  ThemeExtension<AppTypo> copyWith() {
    return AppTypo.defaultTypo();
  }

  @override
  ThemeExtension<AppTypo> lerp(covariant ThemeExtension<AppTypo>? other, double t) {
    return AppTypo.defaultTypo();
  }

  static AppTypo defaultTypo() {
    AppFontWeight fw = AppFontWeight.defaultFontWeight();
    return AppTypo(
      fw: fw,
      appBarTitle: TextStyle(
        fontSize: 16,
        fontWeight: fw.semibold,
      ),
    );
  }
}
