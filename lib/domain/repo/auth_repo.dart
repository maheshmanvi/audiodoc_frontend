import 'package:audiodoc/domain/entity/login_request.dart';
import 'package:audiodoc/domain/entity/login_response.dart';

abstract class AuthRepo {
  Future<LoginResponse> login(LoginRequest request);
}
