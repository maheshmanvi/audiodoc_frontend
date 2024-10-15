import 'package:audiodoc/models/attachment_type.dart';

class RecordingDto {
  final String id;
  final String recordingName;
  final DateTime createdDate;
  final Attachment? attachment;

  RecordingDto({
    required this.id,
    required this.recordingName,
    required this.createdDate,
    this.attachment,
  });

  factory RecordingDto.fromJson(Map<String, dynamic> json) {
    return RecordingDto(
      id: json['_id'] ?? '',
      recordingName: json['recordingName'] ?? 'Unknown',
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now().toLocal(),
      attachment: json['attachment'] != null ? Attachment.fromJson(json['attachment']) : null,
    );
  }
}

class Attachment {
  final String path;
  final String name;
  final AttachmentType type;

  Attachment({
    required this.path,
    required this.name,
    required this.type,
  });

  static Attachment fromJson(Map<String, dynamic> json) {
    String path = json['path'];
    String name = json['name'];
    String extension = path.split('.').last;
    AttachmentType type = AttachmentType.fromExtension(extension);
    return Attachment(
      path: path,
      name: name,
      type: type,
    );
  }
}
