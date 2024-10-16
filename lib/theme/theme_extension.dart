import 'package:audiodoc/theme/app_colors.dart';
import 'package:audiodoc/theme/app_shadows.dart';
import 'package:audiodoc/theme/app_typo.dart';
import 'package:flutter/material.dart';


extension ThemeDataExtension on ThemeData {
  AppShadows get shadows => extension<AppShadows>()!;
  AppColors get colors => extension<AppColors>()!;
  AppTypo get typo => extension<AppTypo>()!;
}
