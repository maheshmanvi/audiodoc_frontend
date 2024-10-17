import 'dart:math';

import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/controllers/recording_controller.dart';
import 'package:audiodoc/domain/entity/attachment_type.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/utils/file_size_util.dart';
import 'package:audiodoc/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachFilesView extends GetView<NewNotesController> {

  final LAttachment? lAttachment;
  final VoidCallback onClickFilePicker;
  final VoidCallback onClickPreview;
  final VoidCallback onClickRemove;

  const AttachFilesView({
    super.key,
    this.lAttachment,
    required this.onClickFilePicker,
    required this.onClickPreview,
    required this.onClickRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      if (lAttachment == null) {
        return Container(
          padding: EdgeInsets.zero,
          child: OutlinedButton(
            onPressed: () => onClickFilePicker(),
            style: OutlinedButton.styleFrom(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.attach_file,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text("Attach File"),
              ],
            ),
          ),
        );
      } else {
        return AttachPreviewView(
          type: lAttachment!.type,
          name: lAttachment!.fileName,
          size: lAttachment!.size,
          onClickPreview: () => onClickPreview(),
          onClickRemove: () => onClickRemove(),
        );
      }
    });
  }
}


class AttachPreviewView extends StatelessWidget {
  final AttachmentType type;
  final String name;
  final int size;
  final VoidCallback onClickPreview;
  final VoidCallback onClickRemove;

  const AttachPreviewView({
    required this.type,
    required this.name,
    required this.size,
    required this.onClickPreview,
    required this.onClickRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.sizeOf(context);
    double maxWidth = min(mediaQuerySize.width, 500);
    logger.d('mediaQuerySize: $mediaQuerySize, maxWidth: $maxWidth');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FileTypeIcon(extension: type.extension),
            const SizedBox(width: 12.0),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${FileSizeUtil.toHumanReadable(size)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),

            if (type.inAppPreview) ...[
              Flexible(
                child: IconButton(
                  tooltip: 'View attachment',
                  visualDensity: VisualDensity.compact,
                  onPressed: onClickPreview,
                  icon: Icon(Icons.remove_red_eye, size: 24),
                ),
              ),
              const SizedBox(width: 12.0),
            ],

            Flexible(
              child: IconButton(
                tooltip: 'Remove attachment',
                visualDensity: VisualDensity.compact,
                onPressed: onClickRemove,
                icon: Icon(Icons.close, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileTypeIcon extends GetView<RecordingController> {
  final String extension;

  const _FileTypeIcon({super.key, required this.extension});

  @override
  Widget build(BuildContext context) {
    FileTypeIcon icon = FileTypeIcon.fromExtension(extension);
    return Container(
      decoration: BoxDecoration(
        color: icon.bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        icon.iconData,
        size: 36,
        color: icon.color,
      ),
    );
  }
}
