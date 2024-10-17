import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNewNoteView extends GetView<NewNotesController> {
  const DesktopNewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return NewNoteMainView(bodyMargin: 24,);
  }
}
