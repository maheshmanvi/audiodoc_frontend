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
    // initializeCues();
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
        cues: cues,
      );

      // Send the UpdateCuesRequest to the use case to update the cues
      final response = await _noteUseCases.updateCues(updateCuesRequest);
      if (response.isLeft) throw response.left;

      // If the cues are updated, update the cue text in the note object
      note.recording.cues = cues;

      // Verify updated cues
      if (note.recording.cues == null) {
        throw Exception("note.recording.cues is null after update");
      }

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

// -----------------------------------------------------------------------------

  /* // Add new cue
  void addCue(int index, Cue newCue) {
    cues.insert(index, newCue);
    _updateSequence(index);
    updateCuesList();
    refreshCues();
  }

  // Delete a cue
  void removeCue(int index) {
    print("object");
    cues.removeAt(index);
    _updateSequence(index);
    updateCuesList();
    refreshCues();
  }

  void updateCue(int cueId, Cue updatedCue) {
    // Find and update the cue in the list by its ID or sequence
    final index = cues.indexWhere((cue) => cue.sequence == cueId);
    if (index != -1) {
      cues[index] = updatedCue;
      update(); // Notify listeners
    }
  }

  // Update sequence numbers
  void _updateSequence(int startIndex) {
    for (int i = startIndex; i < cues.length; i++) {
      cues[i].updateSequence(i + 1);
    }
  }

  // Update note's cue string
  void updateCuesList() {
    final cuesString = cues.map((cue) => cue.toString()).join("\n");
    print("updateCuesList: cuesString = $cuesString");
    print("updateCuesList: cues = ${note.recording.cues}");
    note.recording.cues = cuesString;
    update();
  }*/


  Color getSpeakerColor(String speaker) {
    switch (speaker) {
      case 'Speaker 1':
        return Colors.blue;
      case 'Speaker 2':
        return Colors.green;
      case 'Speaker 3':
        return Colors.red;
      case 'Speaker 4':
        return Colors.purple;
      case 'Speaker 5':
        return Colors.orange;
      case 'Speaker 6':
        return Colors.cyan;
      case 'Speaker 7':
        return Colors.teal;
      case 'Speaker 8':
        return Colors.brown;
      case 'Speaker 9':
        return Colors.indigo;
      case 'Speaker 10':
        return Colors.amber;
      default:
        return Colors.black;
    }
  }

  Color getBackgroundColor(String speaker) {
    switch (speaker) {
      case 'Speaker 1':
        return Colors.blue.shade50;
      case 'Speaker 2':
        return Colors.green.shade50;
      case 'Speaker 3':
        return Colors.red.shade50;
      case 'Speaker 4':
        return Colors.purple.shade50;
      case 'Speaker 5':
        return Colors.orange.shade50;
      case 'Speaker 6':
        return Colors.cyan.shade50;
      case 'Speaker 7':
        return Colors.teal.shade50;
      case 'Speaker 8':
        return Colors.brown.shade50;
      case 'Speaker 9':
        return Colors.indigo.shade50;
      case 'Speaker 10':
        return Colors.amber.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  String extractSpeaker(String text) {
    final speakerRegEx = RegExp(r'Speaker (\d+):\s*');
    final match = speakerRegEx.firstMatch(text);
    if (match != null) {
      return 'Speaker ${match.group(1)}';
    }
    return 'Unknown Speaker';
  }


  String formatDurationWithoutMilliSeconds(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  String formatDurationWithMilliSeconds(Duration duration) {
    return "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}.${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}";
  }


  var cues = <Cue>[].obs;
  final RxMap<int, String> speakerMap = <int, String>{}.obs;
  final RxInt numberOfSpeakers = 0.obs;

  void initializeCues() {
    cues.value = note.recording.getCues();
    speakerMap.clear();
    for (var cue in cues) {
      if (!speakerMap.containsKey(cue.speakerNumber)) {
        speakerMap[cue.speakerNumber] = cue.speakerName;
      }
    }
    numberOfSpeakers.value = speakerMap.length;
    print("initializeCues: ${note.title}\nspeakerMap:");
    speakerMap.forEach((speakerNumber, speakerName) {
      print("$speakerNumber: $speakerName");
    });
    print("numberOfSpeakers: $numberOfSpeakers");
  }

  void refreshCues() {
    final audioPlayerViewController = Get.find<AudioPlayerViewController>();
    if (note.recording.cues != null) {
      final newCues = note.recording.getCues();

      print("New cues fetched: ${newCues.toString()}");

      audioPlayerViewController.cues.clear();
      audioPlayerViewController.cues.addAll(newCues);
      AppSnackBar.showSuccessToast(context, message: 'Cues refreshed successfully');
    } else {
      AppSnackBar.showToast(context, message: 'No cues available to refresh');
    }
  }

  var editingCueId = Rx<int?>(null);

  void editCue(int sequence) {
    editingCueId.value = sequence;
    print("Editing Cue ID: ${editingCueId.value}");
  }

  void removeCue(int index) {

    // Validating the index
    if (index < 0 || index >= cues.length) {
      print("Invalid index: $index");
      return;
    }

    print("Removing cue: Index $index");
    print("Current cues: ${cues.toString()}");
    print("The cue length before is = ${cues.length}");

    cues.removeAt(index);

    print("The cue length after is = ${cues.length}");

    // Update the sequence numbers for remaining cues
    for (int i = 0; i < cues.length; i++) {
      cues[i].updateSequence(i + 1); // Sequences are 1-based
    }

    // Convert updated cues to string
    final updatedCuesString = _convertCuesToString(cues);
    print("Updated Cues String: $updatedCuesString");

    // Call the updateCues method to save in the database
    updateCues(updatedCuesString).then((_) {
      // Successfully updated in database, update UI
      print("Removed cue successfully at the index $index");
      print("Cues before refresh: ${cues.toString()}");
      refreshCues();
    }).catchError((error) {
      // Handle error (show error message)
      // AppSnackBar.showErrorToast(context, message: 'Failed to update cues, ${error.toString()}');
    });

  }

  void updateCue(int cueId, Cue updatedCue) {
    // dwdwd
  }

  // Helper method to convert cue list to string format
  String _convertCuesToString(List<Cue> cues) {
    final cueStrings = cues.map((cue) {
      final start = _durationToString(cue.start);
      final end = _durationToString(cue.end);
      return '${cue.sequence}\n${_convertTimeFormat(start)} --> ${_convertTimeFormat(end)}\n${cue.text}\n';
    }).join('\n');

    return cueStrings;
  }

  // Converts a Duration to a string in "HH:MM:SS" format
  String _durationToString(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$milliseconds';
  }

  // Convert dot (.) to comma (,) for time format used in the database
  String _convertTimeFormat(String time) {
    return time.replaceAll('.', ',');
  }

}
