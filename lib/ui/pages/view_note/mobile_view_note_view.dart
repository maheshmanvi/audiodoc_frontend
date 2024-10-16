import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_note_controller.dart';

class MobileViewNoteView extends GetView<ViewNoteController> {
  const MobileViewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.goBack(context),
        ),
        title: Text("View Note"),
      ),
      body: Text("Mobile: View Note View: ${controller.id}"),
    );
  }
}
