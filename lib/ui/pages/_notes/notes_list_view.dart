import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesListView extends GetView<NotesController> {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, index) => ListTile(
        onTap: () => controller.onNoteTap(context, id: index.toString()),
        title: Text('Item $index'),
      ),
      separatorBuilder: (ctx, index) => const Divider(),
      itemCount: 200,
    );
  }
}
