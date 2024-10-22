import 'dart:async';
import 'dart:html' as html;
import 'dart:ui';

import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../pages/view_note/cue.dart';
import 'player_speed.dart';

class AudioPlayerViewController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final String url;
  late final AudioSource audioSource;
  final RxBool isRenaming = false.obs;

  final ViewNoteController viewNoteController = Get.find<ViewNoteController>();
  List<Cue> cues = [];

  // final SubtitleController subtitleController = SubtitleController();
  // late VideoPlayerController videoPlayerController;
  // final RxBool isVideoPlaying = false.obs;

  // Observable for tracking the current position
  final Rx<Duration> currentPosition = Rx<Duration>(Duration.zero);
  final Rx<Duration> totalDuration = Rx<Duration>(Duration.zero); // Added totalDuration
  Timer? _positionTimer;
  final Rx<PlayerSpeed> speed = Rx<PlayerSpeed>(PlayerSpeed.x1);
  final Rx<ProcessingState> processingState = Rx<ProcessingState>(ProcessingState.idle);
  final Rx<bool> isPlaying = Rx<bool>(false);

  final VoidCallback onRenameComplete;

  AudioPlayerViewController({
    required this.url, required this.onRenameComplete,
  }) {
    audioSource = AudioSource.uri(Uri.parse(url));
    _parseCues();

    // _initializeSubtitles();
  }

  void _parseCues() {
    String? srtContent = viewNoteController.note.recording.cues;
    List<String> lines = srtContent!.split('\n\n');

    for (var line in lines) {
      var parts = line.split('\n');
      if (parts.length < 3) continue;

      // Parse the sequence number
      int seqNumber = int.parse(parts[0]);

      // Parse the time range
      var times = parts[1].split(' --> ');
      var start = _parseDuration(times[0]);
      var end = _parseDuration(times[1]);

      // Get the subtitle text
      String text = parts.sublist(2).join('\n');

      cues.add(Cue(seqNumber: seqNumber, start: start, end: end, text: text));
    }
  }

  Duration _parseDuration(String time) {
    final parts = time.split(',');
    var seconds = Duration(
      hours: int.parse(parts[0].split(':')[0]),
      minutes: int.parse(parts[0].split(':')[1]),
      seconds: int.parse(parts[0].split(':')[2]),
      milliseconds: int.parse(parts[1]),
    );
    return seconds;
  }


//   void _initializeSubtitles() {
//     String srtContent = """
// 1
// 00:00:01,000 --> 00:00:05,000
// Welcome to the audio player!
//
// 2
// 00:00:06,000 --> 00:00:10,000
// Enjoy the subtitles!
// """;
//
//     // Check if the subtitle controller is initialized before setting content
//     if (subtitleController != null) {
//       subtitleController.subtitlesContent = srtContent; // Set the subtitle content
//       subtitleController.subtitleType = SubtitleType.srt; // Set the type
//     }
//     print("Subtitles initialized: ${subtitleController.subtitlesContent}");
//   }


  @override
  void onInit() {
    super.onInit();

    player.setAudioSource(audioSource);
    player.setSpeed(speed.value.value);
    player.setLoopMode(LoopMode.off);

    // Start listening for position updates when the player is playing
    player.playingStream.listen((isPlaying) {
      this.isPlaying.value = isPlaying;
      if (isPlaying) {
        _startPositionTracking();
      } else {
        _stopPositionTracking();
      }
    });

    // Listen for processing state changes
    player.processingStateStream.listen((processingState) {
      this.processingState.value = processingState;
      if (processingState == ProcessingState.completed) {
        _handlePlaybackCompleted();
      }
    });

    // Listen for total duration changes
    player.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero; // Update the total duration
    });
    
  }

  // Method to get the current subtitle
  String getCurrentSubtitle() {
    for (var cue in cues) {
      if (currentPosition.value >= cue.start && currentPosition.value <= cue.end) {
        return cue.text;
      }
    }
    return '';
  }

  @override
  void onClose() {
    _stopPositionTracking();
    player.dispose();
    super.onClose();
  }

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await player.setSpeed(speed);
  }

  Future<void> restart() async {
    await player.seek(Duration.zero);
    await player.play();
  }

  Future<void> rewind({int seconds = 5}) async {
    Duration newDuration;
    if (player.position - Duration(seconds: seconds) > Duration.zero) {
      newDuration = player.position - Duration(seconds: seconds);
    } else {
      newDuration = Duration.zero;
    }
    await player.seek(newDuration);
    currentPosition.value = newDuration;
  }

  Future<void> fastForward({int seconds = 5}) async {
    Duration newDuration;
    if (player.position + Duration(seconds: seconds) < totalDuration.value) {
      newDuration = player.position + Duration(seconds: seconds);
    } else {
      newDuration = totalDuration.value;
    }
    await player.seek(newDuration);
    currentPosition.value = newDuration;
  }

  // Start tracking the position of the audio
  void _startPositionTracking() {
    _stopPositionTracking(); // Ensure no multiple timers are running
    _positionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentPosition.value = player.position; // Update the current position

      // Only update subtitle content if it has been initialized
      // if (subtitleController.subtitlesContent!.isNotEmpty) {
      //   try {
      //     subtitleController.updateSubtitleContent(content: subtitleController.subtitlesContent!);
      //   } catch (e) {
      //     print("Error updating subtitles: $e");
      //   }
      // }

      // subtitleController.updateSubtitleContent(content: viewNoteController.note.recording.cues!);
    });
  }

  // Stop tracking the position
  void _stopPositionTracking() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  // Handle playback completed event
  void _handlePlaybackCompleted() async {
    await pause();
  }

  // Format the current position and total duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // Get formatted current position
  String get formattedCurrentPosition => formatDuration(currentPosition.value);

  // Get formatted total duration
  String get formattedTotalDuration => formatDuration(totalDuration.value);

  void onSeek(double value) {
    final newPosition = Duration(seconds: (value * totalDuration.value.inSeconds).toInt());
    seek(newPosition);
  }

  Future<void> playPause() async {
    if (isPlaying.value) {
      await pause();
    } else {
      // if at end, then restart
      if (currentPosition.value == totalDuration.value) {
        await restart();
      } else {
        await play();
      }
    }
  }

  void downloadAudio() {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = "recording.wav";
    anchorElement.target = '_blank';
    anchorElement.click();
  }

  void toggleRename() {
    if(isRenaming.value) {
      onRenameComplete();
    }
    isRenaming.value = !isRenaming.value;
  }
}

