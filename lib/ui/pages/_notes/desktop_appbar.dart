import 'package:flutter/material.dart';

import 'package:audiodoc/resources/app_strings.dart';
import 'package:audiodoc/theme/app_breakpoints.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/home/home_page_controller.dart';
import 'package:audiodoc/ui/widgets/branding/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopAppBarView extends GetView<HomePageController> implements PreferredSizeWidget {
  const DesktopAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      height: preferredSize.height,
      decoration: BoxDecoration(
        boxShadow: context.theme.shadows.appBarShadow,
        color: context.theme.colors.primary,
      ),
      child: Row(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                const SizedBox(width: 12),
                BrandLogo(),
                const SizedBox(width: 8),
                VerticalDivider(color: context.theme.colors.primaryTint20),
                const SizedBox(width: 8),
                Text(AppStrings.appName, style: context.theme.typo.appBarTitle.copyWith(color: context.theme.colors.onPrimary)),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: context.theme.colors.accent,
            child: Text(
              "A",
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colors.onAccent,
                fontWeight: context.theme.typo.fw.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48);
}
