import 'dart:typed_data';

import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:dio/dio.dart';

class SaveNoteRequest {
  final String title;
  final Uint8List recordingBytes;
  final LAttachment? lAttachment;
  final String? patientName;
  final DateTime? patientDob;
  final String? patientMobile;

  SaveNoteRequest({
    required this.title,
    required this.recordingBytes,
    this.lAttachment,
    this.patientName,
    this.patientDob,
    this.patientMobile,
  });

  FormData toFormData() {
    MultipartFile recording;
    MultipartFile? attachment;
    recording = MultipartFile.fromBytes(recordingBytes, filename: 'recording.wav');
    if (lAttachment != null) {
      attachment = MultipartFile.fromBytes(lAttachment!.bytes, filename: lAttachment!.fileName);
    }
    return FormData.fromMap({
      'title': title,
      'recording': recording,
      'attachment': attachment,
      'patientName': patientName,
      'patientDob': patientDob?.toIso8601String(),
      'patientMobile': patientMobile,
    });
  }
}
