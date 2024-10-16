import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends GetView<NotesController> {
  const Sidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(),
        Expanded(child: NotesListView()),
      ],
    );
  }
}
