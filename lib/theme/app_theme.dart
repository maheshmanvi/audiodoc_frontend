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
      scaffoldBackgroundColor: BaseColors.white,
      cardColor: BaseColors.white,
      canvasColor: BaseColors.white,
      textTheme: AppTypo.defaultTextTheme(),
      extensions: [
        AppShadows.defaultShadows(),
        AppColors(),
        AppTypo.defaultTypo(),
      ],
    );
  }
}
