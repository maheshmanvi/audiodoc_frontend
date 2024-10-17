import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomePageController extends GetxController {

  final NotesController notesController = Get.find<NotesController>();

  void startRecording(BuildContext context) {
    context.goNamed(AppRoutes.nameNewNote, queryParameters: {'start': 'true'});
  }

  void goToNewNoteView(BuildContext context) {
    context.goNamed(AppRoutes.nameNewNote);
  }

  void refreshNotes() async {
    await notesController.fetchNotes();
  }

}
