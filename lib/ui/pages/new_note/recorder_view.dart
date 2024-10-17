import 'package:audiodoc/commons/utils/duration2human.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

double _bigIconSize = 32;
double _bigIconRadius = 32;
double _bigIconPadding = 16;

class RecorderView extends GetView<NewNotesController> {
  const RecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.colors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Obx(() {
          if (controller.recordingController.isRecording()) {
            return RecordingView();
          } else if (controller.recordingController.isPaused()) {
            return PausedView();
          } else {
            return StoppedView();
          }
        }),
      ),
    );
  }
}

class RecordingView extends GetView<NewNotesController> {
  const RecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RecorderButton(
                icon: Icons.pause,
                tooltip: 'Pause Recording',
                iconColor: Colors.white,
                bgColor: Colors.amber,
                onPressed: () async => await controller.pauseRecording(),
              ),
              const SizedBox(width: 16),
              RecorderButton(
                icon: Icons.stop,
                iconColor: context.theme.colors.onError,
                bgColor: context.theme.colors.error,
                tooltip: 'Stop Recording',
                iconSize: _bigIconSize,
                borderRadius: _bigIconRadius,
                iconPadding: EdgeInsets.all(_bigIconPadding),
                onPressed: () async => await controller.stopRecording(),
              ),
              const SizedBox(width: 16),
              RecorderButton(
                icon: Icons.refresh,
                iconColor: context.theme.colors.onInfo,
                bgColor: context.theme.colors.info,
                tooltip: 'Restart Recording',
                onPressed: () async {
                  controller.restartRecording(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RecorderButton(
              icon: Icons.play_arrow,
              tooltip: 'Resume Recording',
              iconColor: context.theme.colors.onSuccess,
              onPressed: () async => await controller.resumeRecording(),
              bgColor: context.theme.colors.success,
            ),
            const SizedBox(width: 16),
            RecorderButton(
              icon: Icons.stop,
              tooltip: 'Stop Recording',
              iconColor: context.theme.colors.onError,
              onPressed: () async => await controller.stopRecording(),
              bgColor: context.theme.colors.error,
              iconSize: _bigIconSize,
              iconPadding: EdgeInsets.all(_bigIconPadding),
              borderRadius: _bigIconRadius,
            ),
            const SizedBox(width: 16),
            RecorderButton(
              icon: Icons.refresh,
              tooltip: 'Restart Recording',
              iconColor: context.theme.colors.onInfo,
              onPressed: () async {
                controller.restartRecording(context);
              },
              bgColor: context.theme.colors.info,
            ),
          ],
        ),
        const SizedBox(height: 16),
        RecordingTimer(),
      ],
    );
  }
}

class StoppedView extends GetView<NewNotesController> {
  const StoppedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RecorderButton(
          icon: Icons.mic,
          tooltip: 'Start Recording',
          iconColor: context.theme.colors.onError,
          onPressed: () async => await controller.startRecording(),
          bgColor: context.theme.colors.error,
          iconSize: _bigIconSize,
          iconPadding: EdgeInsets.all(_bigIconPadding),
          borderRadius: _bigIconRadius,
        ),
        const SizedBox(height: 16),
        RecordingTimer(),
      ],
    );
  }
}

class RecorderButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color iconColor;
  final double iconSize;
  final EdgeInsets iconPadding;
  final double borderRadius;

  const RecorderButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.bgColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.iconSize = 32,
    this.iconPadding = const EdgeInsets.all(8),
    this.borderRadius = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: iconPadding,
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecordingTimer extends GetView<NewNotesController> {
  const RecordingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        Duration2Human.to_mm_ss(controller.recordingController.duration.value),
        style: context.theme.textTheme.bodyMedium?.copyWith(color: context.theme.colors.contentPrimary, fontWeight: FontWeight.bold),
      );
    });
  }
}
