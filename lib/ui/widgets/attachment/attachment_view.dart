import 'package:audiodoc/commons/utils/file_size_util.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;

  const AttachmentIcon({
    super.key,
    required this.iconData,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(iconData, size: size, color: color);
  }
}

class AttachmentDetailsView extends StatelessWidget {
  final String fileName;
  final int size;
  final String extension;

  const AttachmentDetailsView({
    super.key,
    required this.fileName,
    required this.size,
    required this.extension,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fileName,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colors.contentPrimary,
            fontWeight: context.theme.typo.fw.semibold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          '${FileSizeUtil.humanReadable(size)} | ${extension.toUpperCase()}',
          style: context.theme.textTheme.bodySmall?.copyWith(
            color: context.theme.colors.contentSecondary,
          ),
        ),
      ],
    );
  }
}

class AttachmentActionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onClick;
  final String tooltip;

  const AttachmentActionButton({
    super.key,
    required this.iconData,
    required this.onClick,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      icon: Icon(iconData, size: 18),
      onPressed: onClick,
    );
  }
}

class AttachmentView extends StatelessWidget {
  final String name;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final int size;
  final String extension;
  final VoidCallback? onClickPreview;
  final VoidCallback? onClickRemove;
  final VoidCallback? onClickDownload;

  const AttachmentView({
    super.key,
    required this.name,
    required this.iconData,
    required this.iconColor,
    required this.iconSize,
    required this.size,
    required this.extension,
    this.onClickPreview,
    this.onClickRemove,
    this.onClickDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colors.surface,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AttachmentIcon(iconData: iconData, color: iconColor, size: iconSize),
            const SizedBox(width: 12.0),
            Expanded(child: AttachmentDetailsView(fileName: name, size: size, extension: extension)),
            const SizedBox(width: 12.0),
            if (onClickPreview != null) ...[
              AttachmentActionButton(
                iconData: Icons.remove_red_eye_outlined,
                onClick: onClickPreview!,
                tooltip: 'Preview',
              ),
              const SizedBox(width: 12.0),
            ],
            if (onClickDownload != null) ...[
              AttachmentActionButton(
                iconData: Icons.download_outlined,
                onClick: onClickDownload!,
                tooltip: 'Download',
              ),
              const SizedBox(width: 12.0),
            ],
            if (onClickRemove != null) ...[
              AttachmentActionButton(
                iconData: Icons.close,
                onClick: onClickRemove!,
                tooltip: 'Remove',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
