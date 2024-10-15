import 'package:audiodoc/controllers/recording_controller.dart';
import 'package:audiodoc/pages/attachment_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachFilesView extends GetView<RecordingController> {
  const AttachFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedAttachment.value == null) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: OutlinedButton(
            onPressed: () => controller.showFilePicker(),
            style: OutlinedButton.styleFrom(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.attach_file,
                  size: 18,
                ),
                const SizedBox(width: 8.0),
                Text("Attach File"),
              ],
            ),
          ),
        );
      } else {
        return AttachPreviewView(
          type: controller.selectedAttachment.value!.type,
          name: controller.selectedAttachment.value!.name,
          size: controller.selectedAttachment.value!.size,
        );
      }
    });
  }
}
