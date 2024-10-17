import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/widgets/mobile_appbar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class MobileNavBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final VoidCallback onBack;

  const MobileNavBackAppBar({super.key, required this.title, required this.onBack, this.titleWidget});

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
          Expanded(
            child: titleWidget ??
                Text(
                  title,
                  style: context.theme.typo.appBarTitle.copyWith(
                    color: context.theme.colors.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
          const Spacer(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
