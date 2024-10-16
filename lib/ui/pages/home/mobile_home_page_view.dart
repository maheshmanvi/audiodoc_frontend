import 'package:audiodoc/ui/pages/_notes/notes_list_view.dart';
import 'package:audiodoc/ui/pages/home/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileHomePageView extends GetView<HomePageController> {
  const MobileHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToNewNoteView(context),
        child: const Icon(Icons.add),
      ),
      body: NotesListView(),
    );
  }
}
