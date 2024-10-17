import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/domain/entity/login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  final formKey = GlobalKey<FormState>();


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
  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      state.value = DataState.loading();
      await waitForFrame();



    }
    catch(e) {

    }

  }

}
