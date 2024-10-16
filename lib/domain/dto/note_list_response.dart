import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/note.dart';

class NoteListResponse {
  final List<Note> notes;

  NoteListResponse({
    required this.notes,
  });

  factory NoteListResponse.fromMap(Map<String, dynamic> map) {
    List<Note> notes = [];
    List<dynamic> notesMap = map.getList("items");
    for (var noteMap in notesMap) {
      notes.add(Note.fromMap(noteMap));
    }
    return NoteListResponse(
      notes: notes,
    );
  }
}
