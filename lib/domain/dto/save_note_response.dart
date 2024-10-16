import 'package:audiodoc/domain/entity/note.dart';

class SaveNoteResponse {
  final Note note;

  SaveNoteResponse({
    required this.note,
  });

  factory SaveNoteResponse.fromMap(Map<String, dynamic> map) {
    Note note = Note.fromMap(map["note"]);
    return SaveNoteResponse(
      note: note,
    );
  }
}
