import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;


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
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/pages/_notes/notes_controller.dart';
import 'package:audiodoc/ui/pages/_notes/recording_controller.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:audiodoc/ui/widgets/attachment/attachment_preview_dialog_view.dart';
import 'package:audiodoc/ui/widgets/confirm_dialog.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';


class NewNoteController extends GetxController {
  final bool start;
  var isLoadingAudio = false.obs;
  var audioFileName = ''.obs;
  var isAudioLoaded = false.obs;

  final BuildContext context;

  NewNoteController({
    required this.start,
    required this.context,
  });

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

  final formKey = GlobalKey<FormState>();


  void saveRecording(BuildContext context) async {
    if (recordingResult.value == null) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      AppSnackBar.showErrorToast(
        context,
        message: 'Please fill in all required fields and correct any errors in the form.',
      );
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
      AppSnackBar.showError(
        context,
        message: exception.message,
        description: exception.description,
        actionText: 'OK',
      );
    }
  }

  Future<void> startRecording() async {
    recordingResult.value = null;
    await recordingController.startRecording(
      onError: (error) {
        AppSnackBar.showError(
          context,
          message: 'Recording error',
          description: error.message,
        );
      },
    );
  }

  Future<RecordingResult?> stopRecording() async {
    RecordingResult? url = await recordingController.stopRecording();
    log("stopRecording: url = $url");
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

  Future<void> openDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      barrierColor: context.theme.colors.dialogBarrier,
    ).then(
      (value) {
        if (value != null) {
          final day = value.day.toString().padLeft(2, '0');
          final month = value.month.toString().padLeft(2, '0');
          final year = value.year.toString();
          patientDobEC.text = '$day-$month-$year';
          patientDob = value;
        }
      },
    );
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

  Future<void> restartRecording(BuildContext context) async {
    bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Restart Recording',
      message: 'Are you sure you want to restart the recording?',
      confirmButtonColor: context.theme.colors.error,
      confirmTextColor: context.theme.colors.onError,
      confirmText: 'Yes, Restart',
    );

    if (confirmed == null || confirmed == false) return;

    recordingController.stopRecording();
    recordingResult.value = null;
    startRecording();
  }

  cancelRecording(BuildContext context) {
    recordingController.stopRecording();
    recordingResult.value = null;
    context.goNamed(AppRoutes.nameNotesHome);
  }

  previewAttachment(BuildContext context) {
    if (selectedLAttachment.value == null) return;
    if (selectedLAttachment.value!.type.inAppPreview != true) {
      AppSnackBar.showError(
        context,
        message: 'Preview not available',
        description: 'This file type does not support in-app preview',
      );
      return;
    }
    AttachmentPreviewDialogView.showAttachmentPreviewDialog(
      context: context,
      file: AttachmentFileRequest(
        name: selectedLAttachment.value!.fileName,
        type: selectedLAttachment.value!.type,
        bytes: selectedLAttachment.value!.bytes,
      ),
    );
  }

  // Future<void> pickAudioFile(BuildContext context) async {
  //   isLoadingAudio.value = true;
  //   update();
  //
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //     if (result == null || result.files.single.bytes == null) {
  //       throw AppException(message: 'No file selected or file data unavailable.', errorCode: '', description: '');
  //     }
  //     await loadAudioFromBytes(result.files.single.bytes!);
  //
  //     Uint8List audioBytes = result.files.single.bytes!;
  //     List<Uint8List> _recordedBytes = [];
  //     _recordedBytes.add(audioBytes);
  //
  //     final selectedFile = result.files.single;
  //     String audioFilePath = selectedFile.path ?? 'audio_file';
  //     Duration audioDuration = await getAudioDuration(audioBytes);
  //
  //     recordingResult.value = RecordingResult.now(
  //       path: audioFilePath,
  //       duration: audioDuration,
  //     );
  //
  //     audioFileName.value = selectedFile.name;
  //     isAudioLoaded.value = true;
  //
  //     AppSnackBar.showSuccess(context, message: 'Audio file loaded successfully', description: '');
  //   } catch (e) {
  //     AppException exception = AppException.fromAnyException(e);
  //     AppSnackBar.showError(context, message: 'Audio load error', description: exception.message);
  //   } finally {
  //     isLoadingAudio.value = false;
  //     update();
  //   }
  // }

  // Future<void> pickAudioFile(BuildContext context) async {
  //   isLoadingAudio.value = true;
  //   update();
  //
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //     if (result == null || result.files.single.bytes == null) {
  //       throw AppException(
  //         message: 'No file selected or file data unavailable.',
  //         errorCode: '',
  //         description: '',
  //       );
  //     }
  //
  //     final selectedFile = result.files.single;
  //     String audioFilePath = selectedFile.path ?? 'audio_file';
  //
  //     // Access audio bytes directly
  //     Uint8List audioBytes = result.files.single.bytes!;
  //
  //     // Use a placeholder name or access the name property
  //     String audioFileName = result.files.single.name;
  //
  //     // Get the audio duration using bytes instead of path
  //     Duration audioDuration = await getAudioDuration(audioBytes);
  //
  //     // Create RecordingResult using bytes only
  //     recordingResult.value = RecordingResult.now(
  //       path: audioFilePath,
  //       duration: audioDuration,
  //     );
  //
  //     this.audioFileName.value = audioFileName;
  //     isAudioLoaded.value = true;
  //
  //     AppSnackBar.showSuccess(
  //       context,
  //       message: 'Audio file loaded successfully',
  //       description: '',
  //     );
  //   } catch (e) {
  //     AppException exception = AppException.fromAnyException(e);
  //     AppSnackBar.showError(
  //       context,
  //       message: 'Audio load error',
  //       description: exception.message,
  //     );
  //   } finally {
  //     isLoadingAudio.value = false;
  //     update();
  //   }
  // }

  // Future<void> pickAudioFile(BuildContext context) async {
  //   isLoadingAudio.value = true;
  //   update();
  //
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //     if (result == null || result.files.single.bytes == null) {
  //       throw AppException(
  //         message: 'No file selected or file data unavailable.',
  //         errorCode: '',
  //         description: '',
  //       );
  //     }
  //
  //     final selectedFile = result.files.single;
  //
  //     // Use audio bytes directly
  //     Uint8List audioBytes = selectedFile.bytes!;
  //     String audioFileName = selectedFile.name;
  //
  //     // Get audio duration from bytes (method explained below)
  //     Duration audioDuration = await getAudioDuration(audioBytes);
  //     log("Audio duration: $audioDuration");
  //     log("Audio path: $audioFileName");
  //     // log("Audio duration: $audioDuration");
  //
  //     // Create RecordingResult with dummy path and duration
  //     recordingResult.value = RecordingResult.now(
  //       path: audioFileName,
  //       duration: audioDuration,
  //     );
  //
  //     this.audioFileName.value = audioFileName;
  //     isAudioLoaded.value = true;
  //
  //     AppSnackBar.showSuccess(
  //       context,
  //       message: 'Audio file loaded successfully',
  //       description: '',
  //     );
  //   } catch (e) {
  //     AppException exception = AppException.fromAnyException(e);
  //     AppSnackBar.showError(
  //       context,
  //       message: 'Audio load error',
  //       description: exception.message,
  //     );
  //   } finally {
  //     isLoadingAudio.value = false;
  //     update();
  //   }
  // }

  // Future<Duration> getAudioDuration(Uint8List audioBytes) async {
  //   final AudioPlayer audioPlayer = AudioPlayer();
  //
  //   // Set audio source using data URI created from bytes
  //   await audioPlayer.setAudioSource(
  //     AudioSource.uri(
  //       Uri.dataFromBytes(audioBytes, mimeType: 'audio/mpeg'),  // Adjust mimeType as needed
  //     ),
  //   );
  //
  //   Duration? duration = audioPlayer.duration;
  //   await audioPlayer.dispose(); // Clean up after duration is retrieved
  //   return duration ?? Duration.zero;  // Fallback to zero if duration is unavailable
  // }

  // Future<void> pickAudioFile(BuildContext context) async {
  //   isLoadingAudio.value = true;
  //   update();
  //
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
  //     if (result == null || result.files.single.bytes == null) {
  //       throw AppException(
  //         message: 'No file selected or file data unavailable.',
  //         errorCode: '',
  //         description: '',
  //       );
  //     }
  //
  //     final selectedFile = result.files.single;
  //     String audioFilePath = selectedFile.path ?? 'audio_file';
  //
  //     // Write the audio bytes to a temporary file
  //     final Directory tempDir = await getTemporaryDirectory();
  //     final File tempFile = File('${tempDir.path}/${selectedFile.name}');
  //     await tempFile.writeAsBytes(selectedFile.bytes!);
  //
  //     // Load audio from the temporary file into the AudioPlayer
  //     await player.setAudioSource(AudioSource.uri(Uri.file(tempFile.path)));
  //
  //     log("selectedFile: $selectedFile");
  //     log("audioFilePath: $audioFilePath");
  //     log("tempDir: $tempDir");
  //     log("tempFile: $tempFile");
  //     log("tempFile: $tempFile");
  //
  //     // Set the recording result with a valid duration
  //     Duration audioDuration = await player.duration ?? Duration.zero;
  //     recordingResult.value = RecordingResult.now(
  //       path: tempFile.path,
  //       duration: audioDuration,
  //     );
  //
  //     audioFileName.value = selectedFile.name;
  //     isAudioLoaded.value = true;
  //
  //     AppSnackBar.showSuccess(context, message: 'Audio file loaded successfully', description: '');
  //   } catch (e) {
  //     AppException exception = AppException.fromAnyException(e);
  //     AppSnackBar.showError(context, message: 'Audio load error', description: exception.message);
  //   } finally {
  //     isLoadingAudio.value = false;
  //     update();
  //   }
  // }

  Future<void> pickAudioFile(BuildContext context) async {
    isLoadingAudio.value = true;
    update();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result == null || result.files.single.bytes == null) {
        throw AppException(
          message: 'No file selected or file data unavailable.',
          errorCode: '',
          description: '',
        );
      }

      final selectedFile = result.files.single;
      titleEC.text = basenameWithoutExtension(selectedFile.name);

      if (kIsWeb) {
        // Handle web case using Blob
        final bytes = Uint8List.fromList(selectedFile.bytes!);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Load audio from the Blob URL
        await player.setAudioSource(AudioSource.uri(Uri.parse(url)));

        // Optionally set the duration
        Duration? audioDuration = await player.duration;

        // log("bytes: $bytes");
        // log("blob: $blob");
        log("url: $url");
        log("audioDuration: $audioDuration");

        RecordingResult? result = RecordingResult.now(path: url, duration: audioDuration ?? Duration.zero, sttResult: 'No transcription generated');

        recordingResult.value = result;
        // recordingResult.value = RecordingResult.now(
        //   path: selectedFile.name, // We can use name for web since path isn't available
        //   duration: audioDuration ?? Duration.zero,
        // );

      } else {
        // Handle mobile case with temporary file
        final Directory tempDir = await getTemporaryDirectory();
        final File tempFile = File('${tempDir.path}/${selectedFile.name}');
        await tempFile.writeAsBytes(selectedFile.bytes!);

        // Load audio from the temporary file into the AudioPlayer
        await player.setAudioSource(AudioSource.uri(Uri.file(tempFile.path)));

        // Set the recording result with a valid duration
        Duration audioDuration = await player.duration ?? Duration.zero;

        log("tempDir: $tempDir");
        log("tempFile: $tempFile");
        log("audioDuration: $audioDuration");


        RecordingResult? result = RecordingResult.now(path: tempFile.path, duration: audioDuration ?? Duration.zero, sttResult: 'No transcription generated');
        recordingResult.value = result;



        // recordingResult.value = RecordingResult.now(
        //   path: tempFile.path,
        //   duration: audioDuration,
        // );
      }

      audioFileName.value = selectedFile.name;
      isAudioLoaded.value = true;

      AppSnackBar.showSuccess(context, message: 'Audio file loaded successfully', description: '');
    } catch (e) {
      AppException exception = AppException.fromAnyException(e);
      AppSnackBar.showError(context, message: 'Audio load error', description: exception.message);
    } finally {
      isLoadingAudio.value = false;
      update();
    }
  }

  Future<Duration> getAudioDuration(Uint8List audioBytes) async {
    final AudioPlayer audioPlayer = AudioPlayer();

    await audioPlayer.setAudioSource(
      AudioSource.uri(Uri.dataFromBytes(audioBytes, mimeType: 'audio/mpeg')),
    );

    Duration? duration = audioPlayer.duration;
    await audioPlayer.dispose();

    return duration ?? Duration.zero;
  }


}
