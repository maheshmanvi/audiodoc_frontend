import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/env.dart';
import 'package:audiodoc/infrastructure/sl.dart';
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
    dio.interceptors.add(AuthInterceptor());
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

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appState = sl<AppState>();
    if (appState.isLoggedIn) {
      options.headers['Authorization'] = 'Basic ${appState.user.id}:${appState.user.password}';
    }
    super.onRequest(options, handler);
  }
}
