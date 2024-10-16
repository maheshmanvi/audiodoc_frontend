import 'dart:async';
import 'dart:html';

import 'package:audiodoc/ui/widgets/recording_player/player_speed.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerViewController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final String url;
  late final AudioSource audioSource;

  // Observable for tracking the current position
  final Rx<Duration> currentPosition = Rx<Duration>(Duration.zero);
  final Rx<Duration> totalDuration = Rx<Duration>(Duration.zero); // Added totalDuration
  Timer? _positionTimer;
  final Rx<PlayerSpeed> speed = Rx<PlayerSpeed>(PlayerSpeed.x1);
  final Rx<ProcessingState> processingState = Rx<ProcessingState>(ProcessingState.idle);
  final Rx<bool> isPlaying = Rx<bool>(false);

  AudioPlayerViewController({
    required this.url,
  }) {
    audioSource = AudioSource.uri(Uri.parse("https://file-examples.com/storage/feb05093336710053a32bc1/2017/11/file_example_WAV_2MG.wav"));
  }

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

  Future<void> rewind({int seconds = 2}) async {
    Duration newDuration;
    if (player.position - Duration(seconds: seconds) > Duration.zero) {
      newDuration = player.position - Duration(seconds: seconds);
    } else {
      newDuration = Duration.zero;
    }
    await player.seek(newDuration);
    currentPosition.value = newDuration;
  }

  Future<void> fastForward({int seconds = 2}) async {
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

  // download
  void download() {
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "recording.wav")
      ..click();
  }
}
