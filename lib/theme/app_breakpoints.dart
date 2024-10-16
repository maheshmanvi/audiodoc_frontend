import 'package:flutter/material.dart';

class AppBreakPoints {
  static const double small = 576;
  static const double medium = 768;
  static const double large = 992;
  static const double xLarge = 1200;
  static const double xxLarge = 1400;
}

extension BreakPointsExtension on BuildContext {
  bool get isXSmall => MediaQuery.sizeOf(this).width < AppBreakPoints.small;

  bool get isSmall => MediaQuery.sizeOf(this).width >= AppBreakPoints.small;

  bool get isMedium => MediaQuery.sizeOf(this).width >= AppBreakPoints.medium;

  bool get isLarge => MediaQuery.sizeOf(this).width >= AppBreakPoints.large;

  bool get isXLarge => MediaQuery.sizeOf(this).width >= AppBreakPoints.xLarge;

  bool get isXXLarge => MediaQuery.sizeOf(this).width >= AppBreakPoints.xxLarge;

  bool get isMobileSize {
    Size size = MediaQuery.sizeOf(this);
    if (size.width < AppBreakPoints.medium) {
      return true;
    }
    return false;
  }

  bool get isTabletSize {
    Size size = MediaQuery.sizeOf(this);
    if (size.width >= AppBreakPoints.medium && size.width < AppBreakPoints.large) {
      return true;
    }
    return false;
  }

  bool get isDesktopSize {
    Size size = MediaQuery.sizeOf(this);
    if (size.width >= AppBreakPoints.large) {
      return true;
    }
    return false;
  }

  bool get isTabletOrDesktopSize {
    Size size = MediaQuery.sizeOf(this);
    if (size.width >= AppBreakPoints.medium) {
      return true;
    }
    return false;
  }

  bool get isMobileOrTabletSize {
    Size size = MediaQuery.sizeOf(this);
    if (size.width < AppBreakPoints.large) {
      return true;
    }
    return false;
  }

  bool get isLargerThanMobile {
    Size size = MediaQuery.sizeOf(this);
    if (size.width >= AppBreakPoints.medium) {
      return true;
    }
    return false;
  }


}
