import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/domain/entity/cue.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/widgets/audio_avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';

import 'audio_player_controller.dart';

class AudioPlayerView extends StatefulWidget {
  final TextEditingController liveFileName;
  final String url;
  final VoidCallback onRenameComplete;
  final List<Cue> cues;

  const AudioPlayerView(
      {super.key,
      required this.liveFileName,
      required this.url,
      required this.onRenameComplete,
      required this.cues});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  late final AudioPlayerViewController controller;
  late BuildContext currentBuildContext;

  @override
  void initState() {
    super.initState();
    Get.delete<AudioPlayerViewController>();
    controller = AudioPlayerViewController(
      url: widget.url,
      onRenameComplete: widget.onRenameComplete,
      cues: widget.cues,
    );
    Get.put(controller);

    // Initialize ViewNoteController after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<ViewNoteController>()) {
        Get.put(ViewNoteController(currentBuildContext, id: ''));
      }
    });
  }

  @override
  void dispose() {
    controller.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentBuildContext = context;

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
                        if (controller.isRenaming.value) {
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
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
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
      var progress = controller.currentPosition.value.inMilliseconds /
          controller.totalDuration.value.inMilliseconds;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SubtitlesOldView(controller),
          // const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RewindButton(),
              const SizedBox(width: 16),
              _PlayPauseButton(),
              const SizedBox(width: 16),
              _FastForwardButton(),
            ],
          ),
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
        String url = controller.url;
        bool isBlobUrl = url.startsWith("blob:http://localhost");
        bool isRecordingUrl = url.startsWith("http://localhost");

        return IconButton(
          icon: Icon(iconData),
          // onPressed: isRecordingUrl ? controller.cues.isNotEmpty ? controller.playPause : null : controller.playPause,
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
        Obx(() => Text(formatDuration(controller.currentPosition.value),
            style: context.theme.textTheme.bodySmall)),
        Obx(() => Text("/" + formatDuration(controller.totalDuration.value),
            style: context.theme.textTheme.bodySmall)),
      ],
    );
  }
}

class SubtitlesOldView extends StatelessWidget{
  final AudioPlayerViewController audioPlayerViewController;
  late ViewNoteController controller;

  SubtitlesOldView(this.audioPlayerViewController);


  @override
  Widget build(BuildContext context) {
    controller = Get.put(ViewNoteController(context, id: ''));
    String url = audioPlayerViewController.url;
    bool isBlobUrl = url.startsWith("blob:http://localhost");
    bool isRecordingUrl = url.startsWith("http://localhost");

    if (url.isEmpty) {
      return SizedBox.shrink();
    }
    
    return isBlobUrl ? SizedBox.shrink() : Obx(() {
      return controller.summarizeState.value.when(
        initial: () => SizedBox.shrink(),
        // loading: () => Center(child: CircularProgressIndicator()),
        loading: () => Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: context.theme.colors.primaryTint50,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Please wait subtitles loading...",
                style: TextStyle(color: context.theme.colors.primaryTint50,),
              ),
            ],
          ),
        ),
        error: (exception) => Text(
          "Failed to load subtitles",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        data: (data) {
          controller.update();
          audioPlayerViewController.areCuesLoaded.value = true;
          // if (audioPlayerViewController.isPlaying.value && audioPlayerViewController.areCuesLoaded.value && isRecordingUrl) {
          if (audioPlayerViewController.areCuesLoaded.value && isRecordingUrl) {
            return SelectionArea(
              child: SizedBox(
                height: 20,
                child: Text(
                  audioPlayerViewController.getCurrentSubtitle(),
                  // style: TextStyle(color: Colors.white, backgroundColor: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return isBlobUrl ? SizedBox.shrink() : SizedBox(height: 20);
        },
      );
    });
  }

}
