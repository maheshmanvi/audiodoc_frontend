import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/domain/entity/login_request.dart';
import 'package:audiodoc/domain/entity/login_response.dart';
import 'package:audiodoc/domain/usecases/auth_usecases.dart';
import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  final emailEC = TextEditingController(text: "");
  final passwordEC = TextEditingController(text: "");

  final formKey = GlobalKey<FormState>();

  final _authUseCases = sl<AuthUseCases>();

  final appState = sl<AppState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailEC.dispose();
    super.onClose();
  }

  final state = DataState.rxInitial<LoginResponse>();

  void login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      state.value = DataState.loading();
      await waitForFrame();

      LoginRequest request = LoginRequest(email: emailEC.text, password: passwordEC.text);
      final response = await _authUseCases.login(request);
      if (response.isLeft) throw response.left;
      state.value = DataState.success(data: response.right);
      appState.setUser(response.right.user);

      state.value = DataState.success(data: response.right);

      context.goNamed(AppRoutes.nameNotesHome);
    } catch (e) {
      AppException exception = AppException.fromAnyException(e);
      state.value = DataState.error(exception: exception);
      AppSnackBar.showError(
        context,
        message: exception.message,
        description: exception.description,
        actionText: "OK",
      );
    }
  }
}
