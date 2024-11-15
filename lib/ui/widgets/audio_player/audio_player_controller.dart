import 'dart:async';
import 'dart:html' as html;
import 'dart:ui';

import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../domain/entity/cue.dart';
import 'player_speed.dart';

class AudioPlayerViewController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final String url;
  late final AudioSource audioSource;
  final RxBool isRenaming = false.obs;
  late final RxList<Cue> cues = <Cue>[].obs;
  final RxString subtitleText = ''.obs;
  final RxBool areCuesLoaded = false.obs;



  // Observable for tracking the current position
  final Rx<Duration> currentPosition = Rx<Duration>(Duration.zero);
  final Rx<Duration> totalDuration = Rx<Duration>(Duration.zero); // Added totalDuration
  Timer? _positionTimer;
  final Rx<PlayerSpeed> speed = Rx<PlayerSpeed>(PlayerSpeed.x1);
  final Rx<ProcessingState> processingState = Rx<ProcessingState>(ProcessingState.idle);
  final Rx<bool> isPlaying = Rx<bool>(false);

  final VoidCallback onRenameComplete;

  AudioPlayerViewController({
    required this.url, required this.onRenameComplete, required List<Cue> cues,
  }) {
    this.cues.addAll(cues);
    audioSource = AudioSource.uri(Uri.parse(url));
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

    // Listen for position changes
    player.positionStream.listen((position) {
      currentPosition.value = position;
    });
    
  }
  //
  // Method to get the current subtitle
  // String getCurrentSubtitle() {
  //   for (var cue in cues) {
  //     if (currentPosition.value >= cue.start && currentPosition.value <= cue.end) {
  //       return cue.text;
  //     }
  //   }
  //   return '';
  // }

  // String getCurrentSubtitle() {
  //   // Access the current position as a Duration
  //   Duration currentTime = currentPosition.value;
  //
  //   // Loop through the cues and compare the current position with each cue's start and end
  //   for (var cue in cues) {
  //     if (currentTime >= cue.start && currentTime <= cue.end) {
  //       return cue.text; // Return the subtitle text for the matching cue
  //     }
  //   }
  //
  //   return ''; // Return empty string if no matching cue found
  // }

  String getCurrentSubtitle() {
    // Access the current position as a Duration
    Duration currentTime = currentPosition.value;

    // Loop through the cues and compare the current position with each cue's start and end
    for (var cue in cues) {
      if (currentTime >= cue.start && currentTime <= cue.end) {
        return cue.text; // Return the subtitle text for the matching cue
      }
    }

    return ''; // Return empty string if no matching cue found
  }



// Helper function to check if a cue is currently active based on playback position
//   bool isCueActive(Cue cue) {
//     const tolerance = 0.2;
//     return currentPosition.value >= cue.start - tolerance && currentPosition.value <= cue.end + tolerance;
//   }

// You can use `isCueActive` method to dynamically check the active cue and render subtitles accordingly.


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

  // Future<void> playPause() async {
  //   if (isPlaying.value) {
  //     await pause();
  //   } else {
  //     // if at end, then restart
  //     if (currentPosition.value == totalDuration.value) {
  //       await restart();
  //     } else {
  //       await play();
  //     }
  //   }
  // }

  Future<void> playPause() async {
    if (isPlaying.value) {
      await player.pause();
    } else {
      // Restart if we reach the end
      if (currentPosition.value == totalDuration.value) {
        await player.seek(Duration.zero);
      }
      await player.play();
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



class SubtitleManager {
  final RxList<Cue> cues = RxList<Cue>([]); // List of subtitle cues
  final Rx<Duration> currentPosition = Rx<Duration>(Duration.zero); // Current playback position
  final Rx<String> currentSubtitle = Rx<String>('');

  // Method to update subtitle based on current position
  void updateSubtitle() {
    // Loop through cues and find the one matching the current playback position
    for (var cue in cues) {
      if (currentPosition.value >= cue.start && currentPosition.value <= cue.end) {
        currentSubtitle.value = cue.text;
        return;
      }
    }

    currentSubtitle.value = ''; // No active cue
  }

  // Add a new cue
  void addCue(Cue cue) {
    cues.add(cue);
    cues.sort((a, b) => a.start.compareTo(b.start)); // Ensure cues are sorted
  }

  // Remove a cue based on sequence number
  void removeCue(int seqNumber) {
    cues.removeWhere((cue) => cue.seqNumber == seqNumber);
  }

  // Set current position, trigger subtitle update
  void setCurrentPosition(Duration position) {
    currentPosition.value = position;
    updateSubtitle(); // Update the subtitle immediately
  }
}
