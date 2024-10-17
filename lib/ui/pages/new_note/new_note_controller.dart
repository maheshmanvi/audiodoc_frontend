import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/domain/dto/save_note_request.dart';
import 'package:audiodoc/domain/dto/save_note_response.dart';
import 'package:audiodoc/domain/entity/attachment_type.dart';
import 'package:audiodoc/domain/entity/l_attachment.dart';
import 'package:audiodoc/domain/entity/recording_result.dart';
import 'package:audiodoc/domain/usecases/note_usecases.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/recording_controller.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class NewNotesController extends GetxController {
  final bool start;

  NewNotesController({required this.start});

  final player = AudioPlayer();

  RecordingController recordingController = Get.find<RecordingController>();
  Rx<RecordingResult?> recordingResult = Rx<RecordingResult?>(null);

  final NoteUseCases _noteUseCases = sl();

  final patientNameEC = TextEditingController();
  final patientDobEC = TextEditingController();
  DateTime? patientDob = null;
  final patientMobileEC = TextEditingController();
  final titleEC = TextEditingController();

  final NotesController notesController = Get.find<NotesController>();

  @override
  void onInit() {
    super.onInit();
    if (start) {
      startRecording();
    }
  }

  @override
  void onClose() {
    if (recordingController.isRecording()) {
      recordingController.stopRecording();
    }
    patientNameEC.dispose();
    patientDobEC.dispose();
    patientMobileEC.dispose();
    titleEC.dispose();

    if (player.playing) {
      player.stop();
    }
    super.onClose();
  }

  void goBack(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }

  final saveState = DataState.rxInitial<SaveNoteResponse>();

  Rx<LAttachment?> selectedLAttachment = Rx<LAttachment?>(null);

  void saveRecording(BuildContext context) async {
    if (recordingResult.value == null) {
      return;
    }

    try {
      saveState.value = DataState.loading();
      await waitForFrame();

      SaveNoteRequest saveNoteRequest = SaveNoteRequest(
        title: titleEC.text,
        recordingBytes: await recordingResult.value!.getRecordingBytes(),
        patientName: patientNameEC.text,
        patientDob: patientDob,
        patientMobile: patientMobileEC.text,
        lAttachment: selectedLAttachment.value,
      );

      final saveResult = await _noteUseCases.saveNote(saveNoteRequest);
      if (saveResult.isLeft) throw saveResult.left;

      saveState.value = DataState.success(data: saveResult.right);

      notesController.fetchNotes();

      context.goNamed(AppRoutes.nameNotesHome);
    } catch (e) {
      AppException exception = AppException.fromAnyException(e);
      saveState.value = DataState.error(exception: exception);
    }
  }

  Future<void> startRecording() async {
    recordingResult.value = null;
    await recordingController.startRecording();
  }

  Future<RecordingResult?> stopRecording() async {
    RecordingResult? url = await recordingController.stopRecording();
    recordingResult.value = url;
    if (titleEC.text.isEmpty) {
      titleEC.text = url!.getRecodingName();
    }
    return url;
  }

  Future<void> pauseRecording() async {
    await recordingController.pauseRecording();
  }

  Future<void> resumeRecording() async {
    await recordingController.resumeRecording();
  }

  void openDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        final day = value.day.toString().padLeft(2, '0');
        final month = value.month.toString().padLeft(2, '0');
        final year = value.year.toString();
        patientDobEC.text = '$day-$month-$year';
        patientDob = value;
      }
    });
  }

  void showFilePicker(BuildContext context) async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      allowedExtensions: AttachmentType.values.map((e) => e.extension).toList(),
      type: FileType.custom,
    );
    if (filePickerResult == null) return;

    PlatformFile file = filePickerResult.files.first;
    if (file.extension == null) {
      AppSnackBar.showError(
        context,
        message: 'Unsupported file type',
        description: 'Please select a file with supported extension',
      );
      return;
    }

    selectedLAttachment.value = LAttachment.fromPlatformFile(file);
  }

  viewSelectedAttachment(BuildContext context) async {}

  removeAttachment() async {
    selectedLAttachment.value = null;
  }

  void restartRecording() {
    startRecording();
  }

}
