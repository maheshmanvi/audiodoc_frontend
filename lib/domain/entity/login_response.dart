import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/current_user.dart';

class LoginResponse {
  final CurrentUser user;

  LoginResponse({
    required this.user,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      user: CurrentUser.fromMap(map.getMap('user')),
    );
  }
}
