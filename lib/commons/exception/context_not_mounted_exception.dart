
import 'app_exception.dart';

class ContextNotMountedException extends AppException {
  ContextNotMountedException({
    required super.errorCode,
    required super.message,
    required super.description,
  });
}
