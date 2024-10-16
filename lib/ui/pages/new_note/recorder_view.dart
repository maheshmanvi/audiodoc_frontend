import 'package:audiodoc/commons/utils/duration2human.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecorderView extends GetView<NewNotesController> {
  const RecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.recordingController.isRecording()) {
        return RecordingView();
      } else if (controller.recordingController.isPaused()) {
        return PausedView();
      }
      else {
        return StoppedView();
      }
    });
  }
}

class RecordingView extends GetView<NewNotesController> {
  const RecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButtonWithTooltip(
            icon: Icons.stop,
            tooltip: 'Stop Recording',
            onPressed: () async {
              await controller.stopRecording();
            },
          ),
          const SizedBox(width: 16),
          IconButtonWithTooltip(
            icon: Icons.pause,
            tooltip: 'Pause Recording',
            onPressed: () async {
              await controller.pauseRecording();
            },
          ),
          const SizedBox(width: 16),
          IconButtonWithTooltip(
            icon: Icons.refresh,
            tooltip: 'Restart Recording',
            onPressed: () async {
              await controller.stopRecording();
              await controller.startRecording();
            },
          ),
          const SizedBox(width: 16),
          RecordingTimer(),
        ],
      ),
    );
  }
}

class PausedView extends GetView<NewNotesController> {
  const PausedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButtonWithTooltip(
            icon: Icons.stop,
            tooltip: 'Stop Recording',
            onPressed: () async {
              await controller.stopRecording();
            },
          ),
          const SizedBox(width: 16),
          IconButtonWithTooltip(
            icon: Icons.play_arrow,
            tooltip: 'Resume Recording',
            onPressed: () async {
              await controller.resumeRecording();
            },
          ),
          const SizedBox(width: 16),
          IconButtonWithTooltip(
            icon: Icons.refresh,
            tooltip: 'Restart Recording',
            onPressed: () async {
              await controller.stopRecording();
              await controller.startRecording();
            },
          ),
          const SizedBox(width: 16),
          RecordingTimer(),
        ],
      ),
    );
  }
}

class StoppedView extends GetView<NewNotesController> {
  const StoppedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButtonWithTooltip(
            icon: Icons.mic,
            tooltip: 'Start Recording',
            onPressed: () async {
              await controller.startRecording();
            },
          ),
          const SizedBox(width: 16),
          RecordingTimer(),
        ],
      ),
    );
  }
}

class IconButtonWithTooltip extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const IconButtonWithTooltip({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

class RecordingTimer extends GetView<NewNotesController> {
  const RecordingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(Duration2Human.to_mm_ss(controller.recordingController.duration.value));
    });
  }
}
