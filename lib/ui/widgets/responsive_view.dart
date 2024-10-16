import 'package:audiodoc/theme/app_breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveView extends StatelessWidget {
  final Widget Function(BuildContext ctx) mobile;
  final Widget Function(BuildContext ctx) desktop;

  const ResponsiveView({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, cns) {
      if (ctx.isMobileSize) {
        return mobile(context);
      } else {
        return desktop(context);
      }
    });
  }
}
