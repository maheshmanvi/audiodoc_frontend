import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_router/go_router.dart';

class ViewNoteController extends GetxController {
  final String id;

  ViewNoteController({required this.id});

  void goBack(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }
}
