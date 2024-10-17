import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/exception/network_exception.dart';
import 'package:audiodoc/commons/utils/either.dart';
import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/domain/entity/note.dart';
import 'package:audiodoc/domain/entity/update_note_request.dart';
import 'package:audiodoc/domain/repo/note_repo.dart';

class NoteUseCases {
  final NoteRepo _noteRepo;

  NoteUseCases({required NoteRepo noteRepo}) : _noteRepo = noteRepo;

  Future<Either<AppException, SaveNoteResponse>> saveNote(SaveNoteRequest request) async {
    try {
      final response = await _noteRepo.saveNote(request);
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<Either<AppException, Note>> findById(String id) async {
    try {
      final response = await _noteRepo.findById(id);
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<Either<AppException, NoteListResponse>> findAll({String? search}) async {
    try {
      final response = await _noteRepo.findAll();
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  String getBaseUrl(String? relativeUR) {
    return _noteRepo.getBaseUrl(relativeUR);
  }

  String getWordDocViewerURL(String relativeURL) {
    return "https://docs.google.com/viewer?url=" + (relativeURL);
  }

  Future<Either<AppException, SaveNoteResponse>> updateNote(UpdateNoteRequest request) async {
    try {
      final response = await _noteRepo.updateNote(request);
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<Either<AppException, void>> deleteById(String id) async {
    try {
      await _noteRepo.deleteById(id);
      return Right(null);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<Either<AppException, void>> deleteAttachmentByNoteId(String noteId) async {
    try {
      await _noteRepo.deleteAttachmentByNoteId(noteId);
      return Right(null);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<Either<AppException, SaveNoteResponse>> addAttachment(String noteId, LAttachment attachment) async {
    try {
      final response = await _noteRepo.addAttachment(noteId, attachment);
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }
}
