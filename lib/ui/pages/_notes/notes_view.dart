import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/recording_controller.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'desktop_notes_view.dart';

class NotesView extends StatefulWidget {
  final Widget child;

  const NotesView({super.key, required this.child});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesController controller;

  @override
  void initState() {
    Get.delete<NotesController>();
    controller = Get.put(NotesController());

    Get.delete<RecordingController>();
    Get.put(RecordingController(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveView(
      mobile: (ctx) => widget.child,
      desktop: (ctx) => DesktopNotesView(child: widget.child),
    );
  }
}
