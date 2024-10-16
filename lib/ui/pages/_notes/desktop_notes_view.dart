import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_view.dart';
import 'package:audiodoc/ui/widgets/branding/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNotesView extends GetView<NotesController> {
  final Widget child;

  const DesktopNotesView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandLogo(),
      ),
      body: Row(
        children: [
          ConstrainedBox(constraints: BoxConstraints(maxWidth: 400), child: const NotesListView()),
          Expanded(child: child),
        ],
      ),
    );
  }
}
