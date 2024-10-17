import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/desktop_appbar.dart';
import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNotesView extends GetView<NotesController> {
  final Widget child;

  const DesktopNotesView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBarView(),
      body: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.colors.surface,
                border: Border(
                  right: BorderSide(
                    color: context.theme.colors.divider,
                    width: 1,
                  ),
                ),
                boxShadow: context.theme.shadows.shadowSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => controller.openNewNote(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                const SizedBox(width: 8),
                                Text("New Note"),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.colors.primary,
                              foregroundColor: context.theme.colors.onPrimary,
                              minimumSize: const Size(120, 48),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 1, color: context.theme.colors.divider),
                  Expanded(child: const NotesListView()),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
