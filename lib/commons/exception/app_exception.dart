
import '../logging/logger.dart';
import 'context_not_mounted_exception.dart';
import 'network_exception.dart';

class AppException implements Exception {
  String errorCode;
  String message;
  String description;
  dynamic data;

  AppException({
    required this.errorCode,
    required this.message,
    required this.description,
    this.data,
  });

  factory AppException.unknownError() {
    return AppException(
      errorCode: 'UNKNOWN_ERROR',
      message: 'Unknown error',
      description: 'An unknown error occurred',
    );
  }


  static AppException fromAnyException(dynamic e) {
    if (e is AppException) {
      logger.e('AppException.fromAnyException: e is AppException: $e');
      return e;
    }
    if(e is NetworkException) {
      logger.e('AppException.fromAnyException: e is NetworkException: $e');
      return e;
    }
    logger.e('AppException.fromAnyException: e is ${e.runtimeType}: $e');
    return AppException.unknownError();
  }

  static contextNotMounted() {
    return ContextNotMountedException(
      errorCode: 'CONTEXT_NOT_MOUNTED',
      message: 'Context not mounted',
      description: 'Context is not mounted',
    );
  }
}
