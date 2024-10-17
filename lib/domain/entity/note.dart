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

  final String? patientName;
  final DateTime? patientDob;
  final String? patientMobile;


  Note({
    required this.id,
    required this.title,
    required this.recording,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
    this.patientName,
    this.patientDob,
    this.patientMobile,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    String id = map.getString("id");
    String title = map.getString("title");
    Recording recording = Recording.fromMap(map.getMap("recording"));
    DateTime createdAt = map.getDateTime("createdAt");
    DateTime updatedAt = map.getDateTime("updatedAt");
    Attachment? attachment = map.hasValue("attachment") ? Attachment.fromMap(map.getMap("attachment")) : null;
    String? patientName = map.getStringNullable("patientName");
    DateTime? patientDob = map.getDateNullable("patientDob");
    String? patientMobile = map.getStringNullable("patientMobile");
    return Note(
      id: id,
      title: title,
      recording: recording,
      createdAt: createdAt,
      updatedAt: updatedAt,
      attachment: attachment,
      patientName: patientName,
      patientDob: patientDob,
      patientMobile: patientMobile,
    );
  }
}
