import 'package:audiodoc/models/attachment_file.dart';

class SaveRecordingRequest {
  final AttachmentFile? attachmentFile;
  final String recordingData;
  final String recordingName;

  SaveRecordingRequest({
    required this.attachmentFile,
    required this.recordingData,
    required this.recordingName,
  });
}
