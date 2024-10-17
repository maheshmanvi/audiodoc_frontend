import 'package:audiodoc/data/datasource/api_client.dart';
import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/domain/entity/note.dart';
import 'package:audiodoc/domain/entity/update_note_request.dart';
import 'package:audiodoc/domain/repo/note_repo.dart';
import 'package:dio/dio.dart';

class INoteRepo implements NoteRepo {
  final ApiClient _apiClient;

  INoteRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<NoteListResponse> findAll({String? search}) async {
    final response = await _apiClient.dio.get('/notes', queryParameters: {'search': search});
    return NoteListResponse.fromMap(response.data);
  }

  @override
  Future<Note> findById(String id) async {
    final response = await _apiClient.dio.get('/notes/$id');
    return Note.fromMap(response.data);
  }

  @override
  Future<SaveNoteResponse> saveNote(SaveNoteRequest request) async {
    final response = await _apiClient.dio.post('/notes', data: request.toFormData(), options: Options(contentType: 'multipart/form-data'));
    return SaveNoteResponse.fromMap(response.data);
  }

  @override
  String getBaseUrl(String? relativeUR) {
    return _apiClient.getBaseUrl(relativeUR);
  }

  @override
  Future<SaveNoteResponse> addAttachment(String noteId, LAttachment attachment) async {
    final formData = FormData.fromMap({
      'attachment': await MultipartFile.fromBytes(attachment.bytes, filename: attachment.fileName),
    });
    final response = await _apiClient.dio.post('/notes/$noteId/attachment', data: formData);
    return SaveNoteResponse.fromMap(response.data);
  }

  @override
  Future<void> deleteAttachmentByNoteId(String noteId) async {
    await _apiClient.dio.delete('/notes/$noteId/attachment');
  }

  @override
  Future<void> deleteById(String id) async {
    await _apiClient.dio.delete('/notes/$id');
  }

  @override
  Future<SaveNoteResponse> updateNote(UpdateNoteRequest request) async {
    final formData = {
      'title': request.title,
      'patientName': request.patientName,
      'patientMobile': request.patientMobile,
      'patientDob': request.patientDob?.toIso8601String(),
    };
    final response = await _apiClient.dio.post('/notes/${request.id}', data: formData);
    return SaveNoteResponse.fromMap(response.data);
  }
}
