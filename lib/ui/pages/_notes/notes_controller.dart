import 'dart:html' as html;

import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/domain/entity/attachment.dart';
import 'package:audiodoc/domain/usecases/note_usecases.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/notes_list_vm.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_controller.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:audiodoc/ui/widgets/attachment/attachment_preview_dialog_view.dart';
import 'package:audiodoc/ui/widgets/confirm_dialog.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesController extends GetxController {
  final NoteUseCases _noteUseCases = sl();

  final searchController = TextEditingController();

  void onNoteTap(BuildContext context, {required String id}) {
    context.goNamed(AppRoutes.nameViewNoteById, pathParameters: {'id': id});
  }

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  final noteListState = DataState.rxInitial<NotesListVm>();

  NotesListVm get noteListVm => noteListState.value.data!;

  List<NoteListItemVm> get noteListItems => noteListVm.items;

  Future<void> fetchNotes() async {
    try {
      noteListState.value = DataState.loading();
      await waitForFrame();

      String searchQuery = searchController.text;

      final response = await _noteUseCases.findAll(search: searchQuery);
      if (response.isLeft) throw response.left;

      noteListState.value = DataState.success(data: NotesListVm.fromEntity(response.right));
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      noteListState.value = DataState.error(exception: appException);
    }
  }

  Future<void> openAttachment({required BuildContext context, required Attachment attachment}) async {
    String attachmentURL = _noteUseCases.getBaseUrl(attachment.relativeUrl);

    if (attachment.type.isDoc || attachment.type.isDocx) {
      _openDoc(context, attachmentURL);
      return;
    }

    if (attachment.type.isPDF || attachment.type.isImage) {
      _openPDF(context: context, attachment: attachment, attachmentUrl: attachmentURL);
      return;
    }
  }

  Future<void> _openDoc(BuildContext context, String attachmentURL) async {
    openURL(context, _noteUseCases.getWordDocViewerURL(attachmentURL));
  }

  Future<void> _openPDF({required BuildContext context, required Attachment attachment, required String attachmentUrl}) async {
    AttachmentPreviewDialogView.showAttachmentPreviewDialog(
      context: context,
      file: AttachmentFileRequest(
        name: attachment.name,
        type: attachment.type,
        networkUrl: attachmentUrl,
      ),
    );
  }

  Future<void> openURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      AppSnackBar.showErrorToast(context, message: 'Failed to open attachment');
    }
  }

  void openNewNote(BuildContext context) {
    context.goNamed(AppRoutes.nameNewNote);
  }

  void refreshNotes() async {
    await fetchNotes();
  }

  void deleteNoteById(BuildContext context, {required String id}) async {
    final bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Delete Note',
      message: 'Are you sure you want to delete this note?',
      confirmButtonColor: context.theme.colors.error,
      confirmTextColor: context.theme.colors.onError,
      confirmText: "Yes, Delete",
    );

    if (confirmed == null || confirmed == false) return;

    final deleteResponse = await _noteUseCases.deleteById(id);
    if (deleteResponse.isLeft) {
      AppException appException = AppException.fromAnyException(deleteResponse.left);
      AppSnackBar.showErrorToast(context, message: appException.message);
      return;
    }

    if (confirmed == true) {
      AppSnackBar.showSuccessToast(context, message: 'Note deleted successfully');
      fetchNotes();
    }

    // if it is currently opened, then refresh the notes
    ViewNoteController? viewNoteController = (Get.isRegistered<ViewNoteController>()) ? Get.find<ViewNoteController>() : null;
    if ((viewNoteController?.initLoadState.value.isSuccess == true) && (viewNoteController?.id == id) == true) {
      viewNoteController?.fetchNote();
    }
  }

  void downloadRecording(String url, String name) {
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
  }
}
