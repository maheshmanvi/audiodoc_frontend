import 'package:audiodoc/ui/pages/view_note/view_note_main_view.dart';
import 'package:audiodoc/ui/widgets/mobile_nav_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_note_controller.dart';

class MobileViewNoteView extends GetView<ViewNoteController> {
  const MobileViewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileNavBackAppBar(
        title: "View Note",
        onBack: () => controller.goBack(context),
      ),
      body: ViewNoteMainView(),
    );
  }
}
