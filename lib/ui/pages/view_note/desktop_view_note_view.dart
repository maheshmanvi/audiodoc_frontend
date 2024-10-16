import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopViewNoteView extends GetView<ViewNoteController> {
  const DesktopViewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewNoteMainView();
  }
}
