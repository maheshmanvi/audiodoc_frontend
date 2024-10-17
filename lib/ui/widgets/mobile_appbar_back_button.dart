import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class MobileAppBarBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const MobileAppBarBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back,
            color: context.theme.colors.onPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
