import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_main_view.dart';
import 'package:audiodoc/ui/widgets/mobile_nav_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNewNoteView extends GetView<NewNoteController> {
  const MobileNewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MobileNavBackAppBar(
        title: "New Note",
        onBack: () => controller.goBack(context),
      ),
      body: NewNoteMainView(),
    );
  }
}
