import 'package:flutter/material.dart';

class Recording {
  final String id;
  final String recordingName;
  final int? recordingSize;
  final String? recordingData;
  final DateTime createdDate;

  Recording({
    required this.id,
    required this.recordingName,
    this.recordingSize,
    this.recordingData,
    required this.createdDate,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      id: json['_id'] ?? '',
      recordingName: json['recordingName'] ?? 'Unknown',
      recordingSize: json['recordingSize'],
      recordingData: json['recordingData'],
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now().toLocal(),
    );
  }
}
