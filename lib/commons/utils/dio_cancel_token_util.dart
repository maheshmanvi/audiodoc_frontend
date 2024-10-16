import 'package:dio/dio.dart';

class DioCancelTokenUtil {

  // private constructor
  DioCancelTokenUtil._();

  static CancelToken createOrReuseToken(CancelToken? existingToken) {
    // If no existing token or the existing one is cancelled, create a new one
    if (existingToken == null || existingToken.isCancelled) {
      return CancelToken();
    }
    // Return the valid existing token
    return existingToken;
  }
}
