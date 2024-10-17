import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/entity/attachment.dart';
import 'package:audiodoc/domain/entity/note.dart';
import 'package:audiodoc/domain/entity/recording.dart';

class NotesListVm {
  final List<NoteListItemVm> items;

  NotesListVm({
    required this.items,
  });

  factory NotesListVm.fromEntity(NoteListResponse noteListResponse) {
    List<NoteListItemVm> items = [];
    for (var note in noteListResponse.notes) {
      items.add(NoteListItemVm.fromEntity(note));
    }
    return NotesListVm(
      items: items,
    );
  }
}

class NoteListItemVm {
  final String id;
  final String title;
  final Recording recording;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Attachment? attachment;
  final String? patientName;
  final DateTime? patientDob;
  final String? patientMobile;

  NoteListItemVm({
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

  factory NoteListItemVm.fromEntity(Note note) {
    return NoteListItemVm(
      id: note.id,
      title: note.title,
      recording: note.recording,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      attachment: note.attachment,
      patientName: note.patientName,
      patientDob: note.patientDob,
      patientMobile: note.patientMobile,
    );
  }
}
