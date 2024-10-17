import 'package:audiodoc/commons/utils/map_utils.dart';

class CurrentUser {
  final String id;
  final String name;
  final String email;
  final String password;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      id: map.getString('id'),
      name: map.getString('name'),
      email: map.getString('email'),
      password: map.getString('password'),
    );
  }
}
