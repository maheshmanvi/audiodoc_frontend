import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NotesController extends GetxController {
  void onNoteTap(BuildContext context, {required String id}) {
    context.goNamed(AppRoutes.nameViewNoteById, pathParameters: {'id': id});
  }
}
