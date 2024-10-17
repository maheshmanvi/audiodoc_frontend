import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/note.dart';

abstract class NoteRepo {

  Future<SaveNoteResponse> saveNote(SaveNoteRequest request);

  Future<Note> findById(String id);

  Future<NoteListResponse> findAll();

  String getBaseUrl(String? relativeUR);

}