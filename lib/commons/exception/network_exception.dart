import 'package:audiodoc/commons/logging/logger.dart';
import 'package:dio/dio.dart';

import 'app_exception.dart';

class NetworkException extends AppException {
  int statusCode;

  static const String errorCodeCancelled = "network/cancelled";
  static const String errorCodeUnknown = "network/unknown";
  static const String errorCodeApiUnspecified = "api/unspecified";

  NetworkException({
    required super.errorCode,
    required super.message,
    required super.description,
    required this.statusCode,
    super.data,
  });

  bool get isCancelled => statusCode == 499;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;

  static NetworkException fromDioError(dynamic e) {
    if (e is! DioException) {
      logger.e("NetworkException.fromDioError: Not a DioException: $e");
      return NetworkException.unknownError();
    }
    DioException dioException = e;
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return NetworkException.cancelled();
      default:
        return NetworkException._parse(exception: dioException);
    }
  }

  factory NetworkException._parse({required DioException exception}) {
    int statusCode = exception.response?.statusCode ?? 0;
    if (exception.response == null) {
      return unknownError(statusCode: statusCode);
    }
    try {
      String message = exception.response!.data["message"];
      String description = exception.response!.data["description"] ?? "";
      String errorCode = exception.response!.data["errorCode"] ?? errorCodeApiUnspecified;

      return NetworkException(
        errorCode: errorCode,
        message: message,
        description: description,
        statusCode: statusCode,
      );
    } catch (e) {
      logger.e("NetworkException.parse: Failed to parse the error response: $e");
      return NetworkException.unknownError(statusCode: exception.response!.statusCode);
    }
  }

  bool get isConflict => statusCode == 409;

  static NetworkException unknownError({int? statusCode}) {
    return NetworkException(
      errorCode: errorCodeUnknown,
      message: "Something Went Wrong",
      description: "We encountered an unexpected issue. Please try again later.",
      statusCode: statusCode ?? 0,
    );
  }

  static NetworkException cancelled() {
    return NetworkException(
      errorCode: errorCodeCancelled,
      message: "Request Cancelled",
      description: "You’ve cancelled the action. If this was a mistake, please try again.",
      statusCode: 499,
    );
  }
}
