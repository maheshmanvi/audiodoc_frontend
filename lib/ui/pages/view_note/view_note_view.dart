import 'package:audiodoc/ui/pages/view_note/desktop_view_note_view.dart';
import 'package:audiodoc/ui/pages/view_note/mobile_view_note_view.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewNoteView extends StatefulWidget {
  final String id;

  const ViewNoteView({super.key, required this.id});

  @override
  State<ViewNoteView> createState() => _ViewNoteViewState();
}

class _ViewNoteViewState extends State<ViewNoteView> {
  late ViewNoteController controller;

  @override
  void initState() {
    Get.delete<ViewNoteController>();
    controller = ViewNoteController(context, id: widget.id);
    Get.put(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ViewNoteView oldWidget) {
    if (oldWidget.id != widget.id) {
      // recreate the ui
      Get.delete<ViewNoteController>();
      controller = ViewNoteController(context, id: widget.id);
      Get.put(controller);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal.targetsRootOverlay(
      controller: controller.overlayController,
      overlayChildBuilder: (ctx) {
        return AbsorbPointer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(),
            ],
          ),
        );
      },
      child: ResponsiveView(
        mobile: (ctx) => MobileViewNoteView(),
        desktop: (ctx) => DesktopViewNoteView(),
      ),
    );
  }
}
