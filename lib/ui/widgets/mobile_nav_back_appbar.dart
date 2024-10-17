import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/widgets/mobile_appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class MobileNavBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const MobileNavBackAppBar({super.key, required this.title, required this.onBack});

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
          MobileAppBarBackButton(onTap: () => onBack()),
          const SizedBox(width: 12),
          Text(title, style: context.theme.typo.appBarTitle.copyWith(color: context.theme.colors.onPrimary)),
          const Spacer(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
