import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/view_note/note_vm.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_main_view.dart';
import 'package:audiodoc/ui/widgets/mobile_nav_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view_note_controller.dart';

class MobileViewNoteView extends GetView<ViewNoteController> {
  const MobileViewNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MobileNavBackAppBar(
        title: "View Note",
        titleWidget: Obx(
          () {
            if (controller.initLoadState.value.isSuccess) {
              return _buildTitleWidget(context, controller.note.title);
            }
            return _buildTitleWidget(context, "View Note");
          },
        ),
        onBack: () => controller.goBack(context),
      ),
      body: ViewNoteMainView(),
    );
  }


  Widget _buildTitleWidget(BuildContext context, String text) {
    return Text(
      text,
      style: context.theme.typo.appBarTitle.copyWith(
        color: context.theme.colors.onPrimary,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

}
