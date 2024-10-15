import 'package:audiodoc/controllers/recording_controller.dart';
import 'package:audiodoc/models/attachment_type.dart';
import 'package:audiodoc/utils/file_size_util.dart';
import 'package:audiodoc/widgets/file_type_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachPreviewView extends GetView<RecordingController> {
  final AttachmentType type;
  final String name;
  final int size;

  const AttachPreviewView({
    required this.type,
    required this.name,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _FileTypeIcon(extension: type.extension),
            const SizedBox(width: 12.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.selectedAttachment.value!.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${FileSizeUtil.toHumanReadable(controller.selectedAttachment.value!.size)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            if(controller.selectedAttachment.value!.type.supportsLocalPreview)  ...[
              IconButton(
                tooltip: 'View attachment',
                visualDensity: VisualDensity.compact,
                onPressed: () => controller.viewSelectedAttachment(context),
                icon: Icon(Icons.remove_red_eye, size: 24),
              ),
              const SizedBox(width: 12.0),
            ],
            IconButton(
              tooltip: 'Remove attachment',
              visualDensity: VisualDensity.compact,
              onPressed: () => controller.removeAttachment(),
              icon: Icon(Icons.close, size: 24),
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
