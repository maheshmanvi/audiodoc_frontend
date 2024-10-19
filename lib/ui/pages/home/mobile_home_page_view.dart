import 'package:audiodoc/resources/app_strings.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_view.dart';
import 'package:audiodoc/ui/pages/home/home_page_controller.dart';
import 'package:audiodoc/ui/widgets/branding/brand_logo.dart';
import 'package:audiodoc/ui/widgets/current_user_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileHomePageView extends GetView<HomePageController> {
  const MobileHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MobileHomeAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Row(
          children: [
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: context.theme.colors.primaryTint90,
              tooltip: 'Refresh',
              onPressed: () => controller.refreshNotes(),
              child: Icon(
                Icons.refresh,
                color: context.theme.colors.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              icon: Icon(Icons.add, color: context.theme.colors.onPrimary),
              label: Text(
                AppStrings.newNote,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.onPrimary,
                  fontWeight: context.theme.typo.fw.semibold,
                ),
              ),
              backgroundColor: context.theme.colors.primary,
              tooltip: 'New Note',
              onPressed: () => controller.goToNewNoteView(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: NotesListView(),
    );
  }
}

class MobileHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      height: preferredSize.height,
      decoration: BoxDecoration(
        boxShadow: context.theme.shadows.appBarShadow,
        color: context.theme.colors.primary,
      ),
      child: Row(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                const SizedBox(width: 12),
                BrandLogoIcon(),
                const SizedBox(width: 8),
                VerticalDivider(color: context.theme.colors.primaryTint20),
                const SizedBox(width: 8),
                Text(AppStrings.appName, style: context.theme.typo.appBarTitle.copyWith(color: context.theme.colors.onPrimary)),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 16),
          CurrentUserView(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
