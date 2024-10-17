import 'package:audiodoc/infrastructure/env.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  Dio get dio => _dio;

  ApiClient.internal({required Dio dio}) : _dio = dio;

  factory ApiClient() {
    Env env = Env.instance;
    Dio dio = Dio(BaseOptions(
      baseUrl: "${env.apiScheme}://${env.apiHost}:${env.apiPort}/${env.apiPrefix}",
    ));
    return ApiClient.internal(dio: dio);
  }

  String getBaseUrl(String? relativeUR) {
    Env env = Env.instance;
    if (relativeUR != null) {
      return "${env.apiScheme}://${env.apiHost}:${env.apiPort}/$relativeUR";
    }
    return "${env.apiScheme}://${env.apiHost}:${env.apiPort}";
  }
}
