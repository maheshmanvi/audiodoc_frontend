import 'package:audiodoc/ui/widgets/recording_player/audio_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerView extends StatefulWidget {
  final String fileName;
  final String url;

  const AudioPlayerView({
    super.key,
    required this.fileName,
    required this.url,
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
    controller = AudioPlayerViewController(url: widget.url);
    Get.put(controller);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _AudioThumbnailView(
            audioSource: controller.audioSource,
            fileName: widget.fileName,
          ),
          _AudioSeekBar(),
          _AudioControls(),
        ],
      ),
    );
  }
}

class _AudioThumbnailView extends GetView<AudioPlayerViewController> {
  final AudioSource audioSource;
  final String fileName;

  const _AudioThumbnailView({
    super.key,
    required this.audioSource,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.audiotrack),
              const SizedBox(width: 16),
              Text(fileName),
            ],
          ),
          _PlayerDurationView(),
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
    return Row(
      children: [
        _RewindButton(),
        const SizedBox(width: 16),
        _PlayPauseButton(),
        const SizedBox(width: 16),
        _FastForwardButton(),
        Spacer(),
      ],
    );
  }
}

class _RewindButton extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.replay_10),
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
      icon: Icon(Icons.forward_10),
      onPressed: controller.fastForward,
    );
  }
}

class _PlayerDurationView extends GetView<AudioPlayerViewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${controller.currentPosition.value.inMinutes}:${controller.currentPosition.value.inSeconds.remainder(60)} / ${controller.totalDuration.value.inMinutes}:${controller.totalDuration.value.inSeconds.remainder(60)}',
            ),
            // state
            Text(controller.processingState.value.toString()),
          ],
        );
      },
    );
  }
}
