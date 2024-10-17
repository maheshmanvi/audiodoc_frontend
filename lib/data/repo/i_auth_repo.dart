import 'package:audiodoc/data/datasource/api_client.dart';
import 'package:audiodoc/domain/entity/login_request.dart';
import 'package:audiodoc/domain/entity/login_response.dart';
import 'package:audiodoc/domain/repo/auth_repo.dart';

class IAuthRepo implements AuthRepo {
  final ApiClient _apiClient;

  IAuthRepo({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.dio.post("/auth/login", data: request.toMap());
    return LoginResponse.fromMap(response.data);
  }


}
