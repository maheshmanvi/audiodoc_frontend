import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/widgets/audio_avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_player_controller.dart';

class AudioPlayerView extends StatefulWidget {
  final TextEditingController liveFileName;
  final String url;
  final VoidCallback onRenameComplete;

  const AudioPlayerView({
    super.key,
    required this.liveFileName,
    required this.url,
    required this.onRenameComplete,
  });

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  late final AudioPlayerViewController controller;

  @override
  void initState() {
    super.initState();
    Get.delete<AudioPlayerViewController>();
    controller = AudioPlayerViewController(url: widget.url, onRenameComplete: widget.onRenameComplete);
    Get.put(controller);
  }

  @override
  void dispose() {
    controller.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: context.theme.colors.surface,
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _AudioThumbnailView(
            audioSource: controller.audioSource,
            liveFileName: widget.liveFileName,
          ),
          Divider(height: 1, color: context.theme.colors.divider),
          _AudioControls(),
        ],
      ),
    );
  }
}

class _AudioThumbnailView extends GetView<AudioPlayerViewController> {
  final AudioSource audioSource;
  final TextEditingController liveFileName;

  const _AudioThumbnailView({
    super.key,
    required this.audioSource,
    required this.liveFileName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AudioAvatarView(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () {
                        if(controller.isRenaming.value) {
                          return TextField(
                            controller: liveFileName,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: context.theme.typo.fw.semibold,
                            ),
                            textAlign: TextAlign.start,
                          );
                        }
                        return ValueListenableBuilder(
                          valueListenable: liveFileName,
                          builder: (context, value, child) {
                            return Text(
                              value.text,
                              style: context.theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: context.theme.typo.fw.semibold,
                              ),
                              textAlign: TextAlign.start,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    _PlayerDurationView(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Obx(() {
                  if (controller.isRenaming.value) {
                    return Icon(Icons.check, size: 18);
                  }
                  return Icon(Icons.edit_outlined, size: 18);
                }),
                onPressed: () {
                  controller.toggleRename();
                },
              ),
              IconButton(
                icon: Icon(Icons.download_outlined, size: 18),
                onPressed: () {
                  controller.downloadAudio();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudioSeekBar extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var progress = controller.currentPosition.value.inMilliseconds / controller.totalDuration.value.inMilliseconds;
      if (progress.isNaN) {
        progress = 0;
      }
      return LinearProgressIndicator(
        value: progress,
        valueColor: AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
        backgroundColor: Colors.grey,
      );
    });
  }
}

class _AudioControls extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RewindButton(),
          const SizedBox(width: 16),
          _PlayPauseButton(),
          const SizedBox(width: 16),
          _FastForwardButton(),
        ],
      ),
    );
  }
}

class _RewindButton extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.replay_5),
      onPressed: controller.rewind,
    );
  }
}

class _PlayPauseButton extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        IconData iconData;
        if (controller.isPlaying.value) {
          iconData = Icons.pause;
        } else {
          iconData = Icons.play_arrow;
        }
        return IconButton(
          icon: Icon(iconData),
          onPressed: controller.playPause,
        );
      },
    );
  }
}

class _FastForwardButton extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.forward_5),
      onPressed: controller.fastForward,
    );
  }
}

class _PlayerDurationView extends GetView<AudioPlayerViewController> {
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => Text(formatDuration(controller.currentPosition.value), style: context.theme.textTheme.bodySmall)),
        Obx(() => Text("/" + formatDuration(controller.totalDuration.value), style: context.theme.textTheme.bodySmall)),
      ],
    );
  }
}
