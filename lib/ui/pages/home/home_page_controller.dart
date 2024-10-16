import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomePageController extends GetxController {
  void startRecording(BuildContext context) {
    context.goNamed(AppRoutes.nameNewNote, queryParameters: {'start': 'true'});
  }

  goToNewNoteView(BuildContext context) {
    context.goNamed(AppRoutes.nameNewNote);
  }

}
