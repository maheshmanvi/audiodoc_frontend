import 'package:audiodoc/ui/pages/new_note/desktop_new_note_view.dart';
import 'package:audiodoc/ui/pages/new_note/mobile_new_note_view.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {



  @override
  void initState() {
    Get.delete<NewNotesController>();
    Get.put(NewNotesController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveView(
      mobile: (ctx) => MobileNewNoteView(),
      desktop: (ctx) => DesktopNewNoteView(),
    );
  }
}
