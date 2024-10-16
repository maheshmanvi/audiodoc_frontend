import 'package:audiodoc/data/datasource/api_client.dart';
import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/note.dart';
import 'package:audiodoc/domain/repo/note_repo.dart';
import 'package:dio/dio.dart';

class INoteRepo implements NoteRepo {
  final ApiClient _apiClient;

  INoteRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<NoteListResponse> findAll() async {
    try {
      final response = await _apiClient.dio.get('/notes');
      return NoteListResponse.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to load notes');
    }
  }

  @override
  Future<Note> findById(String id) async {
    try {
      final response = await _apiClient.dio.get('/notes/$id');
      return Note.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to load note');
    }
  }

  @override
  Future<SaveNoteResponse> saveNote(SaveNoteRequest request) async {
    try {
      final response = await _apiClient.dio.post('/notes', data: request.toFormData(), options: Options(contentType: 'multipart/form-data'));
      return SaveNoteResponse.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to save note');
    }
  }


}
