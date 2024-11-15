import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/domain/entity/note.dart';
import 'package:audiodoc/domain/entity/update_note_request.dart';

import '../entity/update_cues_request.dart';

abstract class NoteRepo {

  Future<SaveNoteResponse> saveNote(SaveNoteRequest request);

  Future<Note> findById(String id);

  Future<NoteListResponse> findAll();

  String getBaseUrl(String? relativeUR);


  Future<SaveNoteResponse> updateNote(UpdateNoteRequest request);


  Future<void> deleteById(String id);


  Future<void> deleteAttachmentByNoteId(String noteId);


  Future<SaveNoteResponse> addAttachment(String noteId, LAttachment attachment);

  Future<Note> summarize(String noteId);

  Future<Note> transcribe(String noteId);

  Future<SaveNoteResponse> updateCues(UpdateCuesRequest updateCuesRequest);
}