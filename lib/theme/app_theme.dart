import 'package:audiodoc/theme/app_colors.dart';
import 'package:audiodoc/theme/app_shadows.dart';
import 'package:audiodoc/theme/app_typo.dart';
import 'package:audiodoc/theme/base_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      primaryColor: BaseColors.primary,
      colorScheme: ColorScheme.fromSeed(
        primary: BaseColors.primary,
        seedColor: BaseColors.primary,
      ),
      scaffoldBackgroundColor: BaseColors.white,
      cardColor: BaseColors.white,
      canvasColor: BaseColors.white,
      textTheme: AppTypo.defaultTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          foregroundColor: BaseColors.white,
          backgroundColor: BaseColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: BaseColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 8,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: BaseColors.black,
          ),
          hintStyle: TextStyle(
            color: BaseColors.black,
          ),
        ),
        confirmButtonStyle: ElevatedButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: BaseColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 8,
      ),
      extensions: [
        AppShadows.defaultShadows(),
        AppColors(),
        AppTypo.defaultTypo(),
      ],
    );
  }
}
