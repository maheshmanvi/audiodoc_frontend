import 'package:flutter/material.dart';

class RecordingDto {
  final String id;
  final String recordingName;
  final DateTime createdDate;

  RecordingDto({
    required this.id,
    required this.recordingName,
    required this.createdDate,
  });

  factory RecordingDto.fromJson(Map<String, dynamic> json) {
    return RecordingDto(
      id: json['_id'] ?? '',
      recordingName: json['recordingName'] ?? 'Unknown',
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now().toLocal(),
    );
  }
}
