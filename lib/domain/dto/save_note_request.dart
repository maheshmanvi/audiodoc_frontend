import 'dart:typed_data';

import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:dio/dio.dart';

class SaveNoteRequest {
  final String title;
  final Uint8List recordingBytes;
  final LAttachment? lAttachment;

  SaveNoteRequest({
    required this.title,
    required this.recordingBytes,
    this.lAttachment,
  });


  FormData toFormData() {
    MultipartFile recording;
    MultipartFile? attachment;
    recording = MultipartFile.fromBytes(recordingBytes, filename: 'recording.mp3');
    if (lAttachment != null) {
      attachment = MultipartFile.fromBytes(lAttachment!.bytes, filename: lAttachment!.fileName);
    }

    return FormData.fromMap({
      'title': title,
      'recording': recording,
      'attachment': attachment,
    });
  }

}
