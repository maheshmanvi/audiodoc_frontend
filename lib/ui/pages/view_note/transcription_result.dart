import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TranscribeResult {
  String transcript;
  List<Cue> cues;

  TranscribeResult({
    required this.transcript,
    required this.cues,
  });

  factory TranscribeResult.fromMap(Map<String, dynamic> map) {
    return TranscribeResult(
      transcript: map['transcript'] as String,
      cues: List<Cue>.from(map['cues']?.map((cueMap) => Cue.fromMap(cueMap))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transcript': transcript,
      'cues': cues.map((cue) => cue.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'TranscribeResult(transcript: $transcript, cues: $cues)';
  }
}

class Cue {
  final int seqNumber;
  final TimeOfDay start;
  final TimeOfDay end;
  final String text;

  Cue({
    required this.seqNumber,
    required this.start,
    required this.end,
    required this.text,
  });

  factory Cue.fromMap(Map<String, dynamic> map) {
    return Cue(
      seqNumber: map['seqNumber'] as int,
      start: TimeOfDay(
        hour: map['start']['hour'],
        minute: map['start']['minute'],
      ),
      end: TimeOfDay(
        hour: map['end']['hour'],
        minute: map['end']['minute'],
      ),
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seqNumber': seqNumber,
      'start': {'hour': start.hour, 'minute': start.minute},
      'end': {'hour': end.hour, 'minute': end.minute},
      'text': text,
    };
  }

  @override
  String toString() {
    return 'Cue(seqNumber: $seqNumber, start: $start, end: $end, text: $text)';
  }
}
