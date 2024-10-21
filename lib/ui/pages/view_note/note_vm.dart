import 'package:audiodoc/domain/entity/attachment.dart';
import '../../../domain/entity/note.dart';
import 'package:audiodoc/domain/entity/recording.dart';
import 'package:audiodoc/ui/pages/view_note/transcription_result.dart';


class NoteVm {
  final String id;
  final String title;
  final Recording recording;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Attachment? attachment;
  final String? patientName;
  final DateTime? patientDob;
  final String? patientMobile;
  final TranscribeResult? transcribeResult;


  NoteVm({
    required this.id,
    required this.title,
    required this.recording,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
    this.patientName,
    this.patientDob,
    this.patientMobile,
    this.transcribeResult,
  });

  factory NoteVm.fromEntity(Note note) {
    return NoteVm(
      id: note.id,
      title: note.title,
      recording: note.recording,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      attachment: note.attachment,
      patientName: note.patientName,
      patientDob: note.patientDob,
      patientMobile: note.patientMobile,
      transcribeResult: note.transcribeResult,
    );
  }


  bool hasPatientInfo() {
    return patientName != null && patientDob != null && patientMobile != null;
  }


}
