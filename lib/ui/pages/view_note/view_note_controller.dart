import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/commons/utils/data_state.dart';
import 'package:audiodoc/commons/utils/post_frame_callback.dart';
import 'package:audiodoc/domain/usecases/note_usecases.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/ui/pages/view_note/note_vm.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_router/go_router.dart';

class ViewNoteController extends GetxController {
  final String id;

  final NoteUseCases _noteUseCases = sl();

  ViewNoteController({required this.id});

  void goBack(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }

  @override
  void onInit() {
    super.onInit();
    fetchNote();
  }

  final initLoadState = DataState.rxInitial<NoteVm>();

  NoteVm get note => initLoadState.value.data!;

  final TextEditingController titleEC = TextEditingController();

  Future<void> fetchNote() async {
    try {
      initLoadState.value = DataState.loading();
      await waitForFrame();

      final response = await _noteUseCases.findById(id);
      if (response.isLeft) throw response.left;

      final noteVm = NoteVm.fromEntity(response.right);
      _populateNoteVm(noteVm);

      initLoadState.value = DataState.success(data: noteVm);
    } catch (e) {
      AppException appException = AppException.fromAnyException(e);
      initLoadState.value = DataState.error(exception: appException);
    }
  }

  void _populateNoteVm(NoteVm noteVm) {
    titleEC.text = noteVm.title;
  }

  String getNoteFullURL(NoteVm note) {
    String url =  _noteUseCases.getBaseUrl(note.recording.relativeUrl);
    logger.d('Note Full URL: $url');
    return url;
  }

}
