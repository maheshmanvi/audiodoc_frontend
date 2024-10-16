import 'package:flutter/material.dart';

class AppShadows extends ThemeExtension<AppShadows> {
  final List<BoxShadow> none;
  final List<BoxShadow> shadowXsm;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadow;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  final List<BoxShadow> shadowXl;
  final List<BoxShadow> shadow2Xl;
  final List<BoxShadow> dialogHeaderShadow;
  final List<BoxShadow> dialogShadow;
  final List<BoxShadow> appBarShadow;

  AppShadows({
    required this.none,
    required this.shadowXsm,
    required this.shadowSm,
    required this.shadow,
    required this.shadowMd,
    required this.shadowLg,
    required this.shadowXl,
    required this.shadow2Xl,
    required this.dialogHeaderShadow,
    required this.dialogShadow,
    required this.appBarShadow,
  });

  @override
  AppShadows copyWith({
    List<BoxShadow>? none,
    List<BoxShadow>? shadowXsm,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadow,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
    List<BoxShadow>? shadowXl,
    List<BoxShadow>? shadow2Xl,
    List<BoxShadow>? dialogHeaderShadow,
    List<BoxShadow>? dialogShadow,
    List<BoxShadow>? appBarShadow,
  }) {
    return AppShadows(
      none: none ?? this.none,
      shadowXsm: shadowXsm ?? this.shadowXsm,
      shadowSm: shadowSm ?? this.shadowSm,
      shadow: shadow ?? this.shadow,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
      shadowXl: shadowXl ?? this.shadowXl,
      shadow2Xl: shadow2Xl ?? this.shadow2Xl,
      dialogHeaderShadow: dialogHeaderShadow ?? this.dialogHeaderShadow,
      dialogShadow: dialogShadow ?? this.dialogShadow,
      appBarShadow: appBarShadow ?? this.appBarShadow,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) {
      return this;
    }
    return AppShadows.defaultShadows();
  }

  factory AppShadows.defaultShadows() {
    final List<BoxShadow> shadowNone = [];
    final List<BoxShadow> shadowXsm = [
      const BoxShadow(
        offset: Offset(0, 0.005),
        blurRadius: 0.005,
        color: Color.fromRGBO(0, 0, 0, 0.05),
      )
    ];
    final List<BoxShadow> shadowSm = [
      const BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        color: Color.fromRGBO(0, 0, 0, 0.05),
      )
    ];
    final List<BoxShadow> shadow = [
      const BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 3,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
      const BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ];
    final List<BoxShadow> shadowMd = [
      const BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 6,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
      const BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ];
    final List<BoxShadow> shadowLg = [
      const BoxShadow(
        offset: Offset(0, 10),
        blurRadius: 15,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
      const BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 6,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ];
    final List<BoxShadow> shadowXl = [
      const BoxShadow(
        offset: Offset(0, 20),
        blurRadius: 25,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
      const BoxShadow(
        offset: Offset(0, 8),
        blurRadius: 10,
        color: Color.fromRGBO(0, 0, 0, 0.1),
      ),
    ];
    final List<BoxShadow> shadow2Xl = [
      const BoxShadow(
        offset: Offset(0, 25),
        blurRadius: 50,
        color: Color.fromRGBO(0, 0, 0, 0.25),
      ),
    ];
    return AppShadows(
      none: shadowNone,
      shadowXsm: shadowXsm,
      shadowSm: shadowSm,
      shadow: shadow,
      shadowMd: shadowMd,
      shadowLg: shadowLg,
      shadowXl: shadowXl,
      shadow2Xl: shadow2Xl,
      dialogHeaderShadow: shadowSm,
      dialogShadow: shadowMd,
      appBarShadow: shadowSm,
    );
  }
}
