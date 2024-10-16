import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/exception/network_exception.dart';
import 'package:audiodoc/commons/utils/either.dart';
import 'package:audiodoc/domain/dto/note_list_response.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/note.dart';
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

  Future<Either<AppException, NoteListResponse>> findAll() async {
    try {
      final response = await _noteRepo.findAll();
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }


}
