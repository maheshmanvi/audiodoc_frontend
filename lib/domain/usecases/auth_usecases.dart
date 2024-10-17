import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/exception/network_exception.dart';
import 'package:audiodoc/commons/utils/either.dart';
import 'package:audiodoc/domain/entity/login_request.dart';
import 'package:audiodoc/domain/entity/login_response.dart';
import 'package:audiodoc/domain/repo/auth_repo.dart';

class AuthUseCases {
  final AuthRepo _authRepo;

  AuthUseCases({required AuthRepo authRepo}) : _authRepo = authRepo;

  Future<Either<AppException, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _authRepo.login(request);
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }


}
