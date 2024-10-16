import 'package:audiodoc/ui/pages/new_note/desktop_new_note_view.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNewNoteView extends GetView<NewNotesController> {
  const MobileNewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.goBack(context),
        ),
        title: Center(child: ElevatedButton(onPressed: () => controller.saveRecording(context), child: Text("Save Recording"))),
      ),
    );
  }
}
