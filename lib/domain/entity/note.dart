import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/attachment.dart';
import 'package:audiodoc/domain/entity/recording.dart';

class Note {
  final String id;
  final String title;
  final Recording recording;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Attachment? attachment;

  Note({
    required this.id,
    required this.title,
    required this.recording,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    String id = map.getString("id");
    String title = map.getString("title");
    Recording recording = Recording.fromMap(map.getMap("recording"));
    DateTime createdAt = map.getDateTime("createdAt");
    DateTime updatedAt = map.getDateTime("updatedAt");
    Attachment? attachment = map.containsKey("attachment") ? Attachment.fromMap(map.getMap("attachment")) : null;
    return Note(
      id: id,
      title: title,
      recording: recording,
      createdAt: createdAt,
      updatedAt: updatedAt,
      attachment: attachment,
    );
  }
}
