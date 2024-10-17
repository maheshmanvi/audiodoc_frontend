import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/exception/network_exception.dart';
import 'package:audiodoc/commons/utils/either.dart';
import 'package:audiodoc/domain/entity/login_request.dart';
import 'package:audiodoc/domain/entity/login_response.dart';
import 'package:audiodoc/domain/repo/auth_repo.dart';
import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:session_storage/session_storage.dart';

class AuthUseCases {
  final AuthRepo _authRepo;
  final session = SessionStorage();
  final appState = sl<AppState>();

  AuthUseCases({required AuthRepo authRepo}) : _authRepo = authRepo;

  Future<Either<AppException, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _authRepo.login(request);
      final saveResult = await onAuthSuccess(response);
      if(saveResult.isLeft) throw saveResult.left;
      return Right(response);
    } catch (e) {
      return Left(NetworkException.fromDioError(e));
    }
  }

  Future<void> logout() async {
    session.clear();
    appState.onLogout();
  }

  Future<Either<AppException, LoginResponse?>> softLogin() async {
    try {
      final email = session['savedEmail'];
      final password = session['savedPassword'];
      if (email == null || password == null) {
        return Right(null);
      }
      final response = await _authRepo.login(LoginRequest(email: email, password: password));
      return Right(response);
    } catch (e) {
      session.clear();
      return Right(null);
    }
  }

  Future<Either<AppException, LoginResponse?>> onAuthSuccess(LoginResponse? loginResponse) async {
    if (loginResponse == null) {
      return Right(null);
    }
    session['email'] = loginResponse.user.email;
    session['password'] = loginResponse.user.password;
    session['savedEmail'] = loginResponse.user.email;
    session['savedPassword'] = loginResponse.user.password;
    appState.setUser(loginResponse.user);
    return Right(loginResponse);
  }

}
