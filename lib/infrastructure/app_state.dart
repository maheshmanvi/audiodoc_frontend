import 'package:audiodoc/domain/entity/current_user.dart';
import 'package:get/get.dart';

class AppState {
  final Rx<CurrentUser?> _user = Rx<CurrentUser?>(null);

  CurrentUser get user => _user.value!;

  bool get isLoggedIn => _user.value != null;

  void setUser(CurrentUser user) {
    _user.value = user;
  }

  void onLogout() {
    _user.value = null;
  }


}
