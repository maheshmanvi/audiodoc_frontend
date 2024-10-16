import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/pages/new_note/recorder_view.dart';
import 'package:audiodoc/ui/widgets/recording_player/audio_player_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNewNoteView extends GetView<NewNotesController> {
  const DesktopNewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RecorderView(),
          const SizedBox(height: 16),
          if (controller.recordingResult.value != null) ...[
            AudioPlayerView(
              fileName: controller.recordingResult.value!.getRecodingName(),
              url: controller.recordingResult.value!.path,
            ),
          ],
        ],
      ),
    );
  }
}
