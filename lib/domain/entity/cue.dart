import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cue {
  int sequence;
  Duration start;
  Duration end;
  String text;
  String speakerName;
  int speakerNumber;

  Cue({
    required this.sequence,
    required this.start,
    required this.end,
    required this.text,
    required this.speakerName,
    required this.speakerNumber,
  });

  // Method to update cue sequence
  void updateSequence(int newSequence) {
    sequence = newSequence;
  }

  @override
  String toString() {
    return '[$sequence] ${_formatDuration(start)} - ${_formatDuration(end)} $text';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));
    return "$minutes:$seconds.$milliseconds";
  }

  // Update the speaker name and reflect it in the text
  void updateSpeakerName(String newSpeakerName) {
    speakerName = newSpeakerName;
    text = text.replaceFirst(RegExp(r'Speaker \d+: '), '$newSpeakerName: ');
  }
}
