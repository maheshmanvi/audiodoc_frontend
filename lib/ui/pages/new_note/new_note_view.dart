import 'package:audiodoc/ui/pages/new_note/desktop_new_note_view.dart';
import 'package:audiodoc/ui/pages/new_note/mobile_new_note_view.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_controller.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/src/state.dart';

class NewNoteView extends StatefulWidget {
  final GoRouterState? routerState;

  const NewNoteView({
    super.key,
    this.routerState,
  });

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {




  @override
  void initState() {
    Get.delete<NewNotesController>();

    final startString = widget.routerState?.uri.queryParameters['start'];
    bool start = startString == 'true';


    Get.put(NewNotesController(start: start));
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
