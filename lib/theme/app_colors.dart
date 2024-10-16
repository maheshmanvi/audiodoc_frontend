import 'package:flutter/material.dart';

import 'base_colors.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color primaryTint100;
  final Color primaryTint90;
  final Color primaryTint80;
  final Color primaryTint70;
  final Color primaryTint60;
  final Color primaryTint50;
  final Color primaryTint40;
  final Color primaryTint30;
  final Color primaryTint20;
  final Color primaryTint10;
  final Color primaryShade10;
  final Color primaryShade20;
  final Color primaryShade30;
  final Color primaryShade40;
  final Color primaryShade50;
  final Color primaryShade60;
  final Color primaryShade70;
  final Color primaryShade80;
  final Color primaryShade90;
  final Color primaryShade100;

  final Color onPrimary;

  final Color accent;
  final Color accentTint100;
  final Color accentTint90;
  final Color accentTint80;
  final Color accentTint70;
  final Color accentTint60;
  final Color accentTint50;
  final Color accentTint40;
  final Color accentTint30;
  final Color accentTint20;
  final Color accentTint10;
  final Color accentShade10;
  final Color accentShade20;
  final Color accentShade30;
  final Color accentShade40;
  final Color accentShade50;
  final Color accentShade60;
  final Color accentShade70;
  final Color accentShade80;
  final Color accentShade90;
  final Color accentShade100;

  final Color onAccent;

  final Color info;
  final Color infoShade10;
  final Color infoShade20;
  final Color infoShade30;
  final Color infoShade40;
  final Color infoShade50;
  final Color infoShade60;
  final Color infoShade70;
  final Color infoShade80;
  final Color infoShade90;
  final Color infoShade100;
  final Color infoTint10;
  final Color infoTint20;
  final Color infoTint30;
  final Color infoTint40;
  final Color infoTint50;
  final Color infoTint60;
  final Color infoTint70;
  final Color infoTint80;
  final Color infoTint90;
  final Color infoTint95;
  final Color infoTint100;

  final Color onInfo;

  final Color error;
  final Color errorShade10;
  final Color errorShade20;
  final Color errorShade30;
  final Color errorShade40;
  final Color errorShade50;
  final Color errorShade60;
  final Color errorShade70;
  final Color errorShade80;
  final Color errorShade90;
  final Color errorShade100;
  final Color errorTint10;
  final Color errorTint20;
  final Color errorTint30;
  final Color errorTint40;
  final Color errorTint50;
  final Color errorTint60;
  final Color errorTint70;
  final Color errorTint80;
  final Color errorTint90;
  final Color errorTint95;
  final Color errorTint100;

  final Color onError;

  final Color success;
  final Color successShade10;
  final Color successShade20;
  final Color successShade30;
  final Color successShade40;
  final Color successShade50;
  final Color successShade60;
  final Color successShade70;
  final Color successShade80;
  final Color successShade90;
  final Color successShade100;
  final Color successTint10;
  final Color successTint20;
  final Color successTint30;
  final Color successTint40;
  final Color successTint50;
  final Color successTint60;
  final Color successTint70;
  final Color successTint80;
  final Color successTint90;
  final Color successTint95;
  final Color successTint100;

  final Color onSuccess;

  final Color surface;

  AppColors({
    this.primary = BaseColors.primary,
    this.primaryTint100 = BaseColors.primaryTint100,
    this.primaryTint90 = BaseColors.primaryTint90,
    this.primaryTint80 = BaseColors.primaryTint80,
    this.primaryTint70 = BaseColors.primaryTint70,
    this.primaryTint60 = BaseColors.primaryTint60,
    this.primaryTint50 = BaseColors.primaryTint50,
    this.primaryTint40 = BaseColors.primaryTint40,
    this.primaryTint30 = BaseColors.primaryTint30,
    this.primaryTint20 = BaseColors.primaryTint20,
    this.primaryTint10 = BaseColors.primaryTint10,
    this.primaryShade10 = BaseColors.primaryShade10,
    this.primaryShade20 = BaseColors.primaryShade20,
    this.primaryShade30 = BaseColors.primaryShade30,
    this.primaryShade40 = BaseColors.primaryShade40,
    this.primaryShade50 = BaseColors.primaryShade50,
    this.primaryShade60 = BaseColors.primaryShade60,
    this.primaryShade70 = BaseColors.primaryShade70,
    this.primaryShade80 = BaseColors.primaryShade80,
    this.primaryShade90 = BaseColors.primaryShade90,
    this.primaryShade100 = BaseColors.primaryShade100,
    this.onPrimary = BaseColors.primaryTint100,
    this.accent = BaseColors.accent,
    this.accentTint100 = BaseColors.accentTint100,
    this.accentTint90 = BaseColors.accentTint90,
    this.accentTint80 = BaseColors.accentTint80,
    this.accentTint70 = BaseColors.accentTint70,
    this.accentTint60 = BaseColors.accentTint60,
    this.accentTint50 = BaseColors.accentTint50,
    this.accentTint40 = BaseColors.accentTint40,
    this.accentTint30 = BaseColors.accentTint30,
    this.accentTint20 = BaseColors.accentTint20,
    this.accentTint10 = BaseColors.accentTint10,
    this.accentShade10 = BaseColors.accentShade10,
    this.accentShade20 = BaseColors.accentShade20,
    this.accentShade30 = BaseColors.accentShade30,
    this.accentShade40 = BaseColors.accentShade40,
    this.accentShade50 = BaseColors.accentShade50,
    this.accentShade60 = BaseColors.accentShade60,
    this.accentShade70 = BaseColors.accentShade70,
    this.accentShade80 = BaseColors.accentShade80,
    this.accentShade90 = BaseColors.accentShade90,
    this.accentShade100 = BaseColors.accentShade100,
    this.onAccent = BaseColors.accentShade100,
    this.info = BaseColors.info,
    this.infoShade10 = BaseColors.infoShade10,
    this.infoShade20 = BaseColors.infoShade20,
    this.infoShade30 = BaseColors.infoShade30,
    this.infoShade40 = BaseColors.infoShade40,
    this.infoShade50 = BaseColors.infoShade50,
    this.infoShade60 = BaseColors.infoShade60,
    this.infoShade70 = BaseColors.infoShade70,
    this.infoShade80 = BaseColors.infoShade80,
    this.infoShade90 = BaseColors.infoShade90,
    this.infoShade100 = BaseColors.infoShade100,
    this.infoTint10 = BaseColors.infoTint10,
    this.infoTint20 = BaseColors.infoTint20,
    this.infoTint30 = BaseColors.infoTint30,
    this.infoTint40 = BaseColors.infoTint40,
    this.infoTint50 = BaseColors.infoTint50,
    this.infoTint60 = BaseColors.infoTint60,
    this.infoTint70 = BaseColors.infoTint70,
    this.infoTint80 = BaseColors.infoTint80,
    this.infoTint90 = BaseColors.infoTint90,
    this.infoTint95 = BaseColors.infoTint95,
    this.infoTint100 = BaseColors.infoTint100,
    this.onInfo = BaseColors.infoTint100,
    this.error = BaseColors.error,
    this.errorShade10 = BaseColors.errorShade10,
    this.errorShade20 = BaseColors.errorShade20,
    this.errorShade30 = BaseColors.errorShade30,
    this.errorShade40 = BaseColors.errorShade40,
    this.errorShade50 = BaseColors.errorShade50,
    this.errorShade60 = BaseColors.errorShade60,
    this.errorShade70 = BaseColors.errorShade70,
    this.errorShade80 = BaseColors.errorShade80,
    this.errorShade90 = BaseColors.errorShade90,
    this.errorShade100 = BaseColors.errorShade100,
    this.errorTint10 = BaseColors.errorTint10,
    this.errorTint20 = BaseColors.errorTint20,
    this.errorTint30 = BaseColors.errorTint30,
    this.errorTint40 = BaseColors.errorTint40,
    this.errorTint50 = BaseColors.errorTint50,
    this.errorTint60 = BaseColors.errorTint60,
    this.errorTint70 = BaseColors.errorTint70,
    this.errorTint80 = BaseColors.errorTint80,
    this.errorTint90 = BaseColors.errorTint90,
    this.errorTint95 = BaseColors.errorTint95,
    this.errorTint100 = BaseColors.errorTint100,
    this.onError = BaseColors.errorTint100,
    this.success = BaseColors.success,
    this.successShade10 = BaseColors.successShade10,
    this.successShade20 = BaseColors.successShade20,
    this.successShade30 = BaseColors.successShade30,
    this.successShade40 = BaseColors.successShade40,
    this.successShade50 = BaseColors.successShade50,
    this.successShade60 = BaseColors.successShade60,
    this.successShade70 = BaseColors.successShade70,
    this.successShade80 = BaseColors.successShade80,
    this.successShade90 = BaseColors.successShade90,
    this.successShade100 = BaseColors.successShade100,
    this.successTint10 = BaseColors.successTint10,
    this.successTint20 = BaseColors.successTint20,
    this.successTint30 = BaseColors.successTint30,
    this.successTint40 = BaseColors.successTint40,
    this.successTint50 = BaseColors.successTint50,
    this.successTint60 = BaseColors.successTint60,
    this.successTint70 = BaseColors.successTint70,
    this.successTint80 = BaseColors.successTint80,
    this.successTint90 = BaseColors.successTint90,
    this.successTint95 = BaseColors.successTint95,
    this.successTint100 = BaseColors.successTint100,
    this.onSuccess = BaseColors.successTint100,

    this.surface = BaseColors.white,

  });

  @override
  ThemeExtension<AppColors> copyWith() {
    return AppColors();
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors();
  }
}
