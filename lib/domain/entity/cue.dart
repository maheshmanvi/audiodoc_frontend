import 'package:flutter/material.dart';

class Cue {
  final int seqNumber;
  final Duration start;
  final Duration end;
  final String text;

  Cue({
    required this.seqNumber,
    required this.start,
    required this.end,
    required this.text,
  });
}