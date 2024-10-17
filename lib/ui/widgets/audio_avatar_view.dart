import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class AudioAvatarView extends StatelessWidget {
  const AudioAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.colors.accentTint80,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          Icons.audiotrack,
          color: context.theme.colors.accentShade20,
        ),
      ),
    );
  }
}
