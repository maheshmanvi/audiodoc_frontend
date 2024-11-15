import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/commons/utils/time_ago_util.dart';
import 'package:audiodoc/domain/entity/attachment.dart';
import 'package:audiodoc/domain/entity/attachment_type.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/domain/entity/update_note_request.dart';
import 'package:audiodoc/domain/usecases/note_usecases.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/view_note/note_vm.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:audiodoc/ui/utils/url_open_util.dart';
import 'package:audiodoc/ui/widgets/attachment/attachment_preview_dialog_view.dart';
import 'package:audiodoc/ui/widgets/confirm_dialog.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entity/cue.dart';
import '../../../domain/entity/update_cues_request.dart';
import '../../widgets/audio_player/audio_player_controller.dart';

class ViewNoteController extends GetxController with GetSingleTickerProviderStateMixin {
  final String id;
  final BuildContext context;

  final NoteUseCases _noteUseCases = sl();

  final NotesController _notesController = Get.find();

  late final TabController tabController;

  late AudioPlayerViewController audioPlayerViewController;


  ViewNoteController(this.context, {required this.id}) {
    tabController = TabController(length: 3, vsync: this);
  }

  void goBack(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }

  final RxBool isEditing = false.obs;

  void toggleEdit() {
    if (isEditing.value) {
      updateNotes();
    }
    isEditing.value = !isEditing.value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNote();
  }

  final initLoadState = DataState.rxInitial<NoteVm>();

  NoteVm get note => initLoadState.value.data!;

  final TextEditingController titleEC = TextEditingController();

  final overlayController = OverlayPortalController();

  final formKey = GlobalKey<FormState>();

  final patientNameEC = TextEditingController();
  final patientDobEC = TextEditingController();
  DateTime? patientDob = null;
  final patientMobileEC = TextEditingController();

  Future<void> fetchNote() async {
    try {
      initLoadState.value = DataState.loading();
      await waitForFrame();

      final response = await _noteUseCases.findById(id);
      if (response.isLeft) throw response.left;

      final noteVm = NoteVm.fromEntity(response.right);
      _populateNoteVm(noteVm);

      // if (noteVm.recording.summary == null) {
      //   summarize();
      // } else {
      //   summarizeState.value = DataState.success(data: noteVm);
      // }

      if (noteVm.recording.summary == null) {

      }else{
          summarizeState.value = DataState.success(data: noteVm);
      }

      if (noteVm.recording.cues == null) {
        transcribe();
      } else {
        transcribeState.value = DataState.success(data: noteVm);
      }

      // Initialize AudioPlayerViewController after the Note is fetched
      final recording = noteVm.recording;
      if (recording.relativeUrl.isNotEmpty) {
        audioPlayerViewController = AudioPlayerViewController(
          url: _noteUseCases.getBaseUrl(recording.relativeUrl),
          onRenameComplete: () {
          },
          cues: recording.getCues(),
        );
        Get.put<AudioPlayerViewController>(audioPlayerViewController);
      }

      initLoadState.value = DataState.success(data: noteVm);
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      initLoadState.value = DataState.error(exception: appException);
    }
  }

  void _populateNoteVm(NoteVm noteVm) {
    titleEC.text = noteVm.title;
    patientNameEC.text = noteVm.patientName ?? '';
    patientDob = noteVm.patientDob;
    patientDobEC.text = (noteVm.patientDob != null) ? TimeAgoUtil.defaultDateFormat(noteVm.patientDob!) : '';
    patientMobileEC.text = noteVm.patientMobile ?? '';
    isEditing.value = false;
  }

  String getNoteFullURL(NoteVm note) {
    String url = _noteUseCases.getBaseUrl(note.recording.relativeUrl);
    logger.d('Note Full URL: $url');
    return url;
  }

  void onClickEdit() async {}

  void onClickPreviewAttachment(BuildContext context, Attachment? attachment) async {
    if (attachment == null) return;

    if (attachment.type.isDoc || attachment.type.isDocx) {
      String url = _noteUseCases.getWordDocViewerURL(attachment.relativeUrl);
      UrlOpenUtil.openURL(context, url);
      return;
    }

    AttachmentPreviewDialogView.showAttachmentPreviewDialog(
      context: context,
      file: AttachmentFileRequest(
        name: attachment.name,
        type: attachment.type,
        networkUrl: _noteUseCases.getBaseUrl(attachment.relativeUrl),
      ),
    );
  }

  Future<void> showFilePicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AttachmentType.values.map((e) => e.extension).toList(),
    );

    if (result == null) return;

    final file = result.files.single;
    final LAttachment? attachment = LAttachment.fromPlatformFile(file);
    if (attachment == null) {
      AppSnackBar.showErrorToast(context, message: 'Failed to read file');
      return;
    }

    try {
      overlayController.show();

      final response = await _noteUseCases.addAttachment(id, attachment);
      if (response.isLeft) throw response.left;

      AppSnackBar.showSuccessToast(context, message: 'Attachment added successfully');

      fetchNote();

      _notesController.fetchNotes();
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      AppSnackBar.showErrorToast(context, message: appException.message);
    } finally {
      overlayController.hide();
    }
  }

  void onClickRemoveAttachment(BuildContext context) async {
    bool? confirmation = await ConfirmDialog.show(
      context: context,
      title: 'Remove Attachment',
      message: 'Are you sure you want to remove the attachment?',
      confirmText: 'Remove',
      confirmButtonColor: context.theme.colors.error,
      confirmTextColor: context.theme.colors.onError,
    );

    if (confirmation == null || !confirmation) return;

    try {
      overlayController.show();

      final response = await _noteUseCases.deleteAttachmentByNoteId(id);
      if (response.isLeft) throw response.left;

      AppSnackBar.showSuccessToast(context, message: 'Attachment removed successfully');

      fetchNote();

      _notesController.fetchNotes();
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      AppSnackBar.showErrorToast(context, message: appException.message);
    } finally {
      overlayController.hide();
    }
  }

  void onClickDownloadAttachment(BuildContext context, Attachment? attachment) {
    if (attachment == null) return;
    UrlOpenUtil.downloadFile(context, _noteUseCases.getBaseUrl(attachment.relativeUrl));
  }

  Future<void> updateNotes() async {
    if (!formKey.currentState!.validate()) return;

    try {
      overlayController.show();
      UpdateNoteRequest updateNoteRequest = UpdateNoteRequest(
        id: id,
        title: titleEC.text,
        patientName: patientNameEC.text,
        patientDob: patientDob,
        patientMobile: patientMobileEC.text,
      );
      final response = await _noteUseCases.updateNote(updateNoteRequest);
      if (response.isLeft) throw response.left;

      AppSnackBar.showSuccessToast(context, message: 'Patient details updated successfully');

      fetchNote();

      _notesController.fetchNotes();
    } catch (e) {
      logger.e(e);
      AppException appException = AppException.fromAnyException(e);
      AppSnackBar.showErrorToast(context, message: appException.message);
    } finally {
      overlayController.hide();
    }
  }

  void openDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      barrierColor: context.theme.colors.dialogBarrier,
    ).then((value) {
      if (value != null) {
        patientDob = value;
        patientDobEC.text = TimeAgoUtil.defaultDateFormat(value);
      }
    });
  }

  final summarizeState = DataState.rxInitial<NoteVm>();
  final transcribeState = DataState.rxInitial<NoteVm>();

  Future<void> summarize() async {
    // if (summarizeState.value.isLoading) return;

    if(note.recording.summary != null) return;

    try {
      summarizeState.value = DataState.loading();
      await waitForFrame();

      final response = await _noteUseCases.summarize(id);
      if (response.isLeft) throw response.left;

      final noteVm = NoteVm.fromEntity(response.right);
      _populateNoteVm(noteVm);

      final audioPlayerViewController = Get.find<AudioPlayerViewController>();

      final recording = noteVm.recording;
      if (recording.cues != null) {
        final newCues = recording.getCues();
        audioPlayerViewController.cues.addAll(newCues);
      }

      summarizeState.value = DataState.success(data: noteVm);
      initLoadState.value = DataState.success(data: noteVm);
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      summarizeState.value = DataState.error(exception: appException);
    }
  }

  Future<void> transcribe() async {
    if (transcribeState.value.isLoading) return;
    try {
      transcribeState.value = DataState.loading();
      await waitForFrame();

      final response = await _noteUseCases.transcribe(id);
      if (response.isLeft) throw response.left;

      final noteVm = NoteVm.fromEntity(response.right);
      _populateNoteVm(noteVm);

      final audioPlayerViewController = Get.find<AudioPlayerViewController>();

      final recording = noteVm.recording;
      if (recording.cues != null) {
        final newCues = recording.getCues();
        audioPlayerViewController.cues.addAll(newCues);
      }

      transcribeState.value = DataState.success(data: noteVm);
      initLoadState.value = DataState.success(data: noteVm);
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      transcribeState.value = DataState.error(exception: appException);
    }
  }


  // Add the updateCues method using UpdateCuesRequest
  Future<void> updateCues(String cues) async {
    try {
      overlayController.show();

      // Create an UpdateCuesRequest for the cue update
      UpdateCuesRequest updateCuesRequest = UpdateCuesRequest(
        noteId: id,
        cues: cues,  // Use the subtitle text as the cue
      );

      // Send the UpdateCuesRequest to the use case to update the cues
      final response = await _noteUseCases.updateCues(updateCuesRequest);
      if (response.isLeft) throw response.left;

      // If the cues are updated, update the cue text in the note object
      note.recording.cues = cues;

      AppSnackBar.showSuccessToast(context, message: 'Subtitles (Cues) updated successfully');
      fetchNote();
    } catch (e) {
      logger.e(e);
      AppException appException = AppException.fromAnyException(e);
      AppSnackBar.showErrorToast(context, message: appException.message);
    } finally {
      overlayController.hide();
    }
  }

  void refreshCues(){

  }



}
