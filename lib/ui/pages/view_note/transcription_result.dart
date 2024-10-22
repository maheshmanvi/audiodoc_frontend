import 'package:flutter/material.dart';

class TranscribeResult {
  String transcript;
  String cues;

  TranscribeResult({
    required this.transcript,
    required this.cues,
  });

  factory TranscribeResult.fromMap(Map<String, dynamic> map) {
    return TranscribeResult(
      transcript: map['transcript'] as String,
      cues: map['cues'] as String,
    );
  }
}
