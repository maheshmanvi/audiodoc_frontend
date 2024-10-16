import 'package:audiodoc/domain/entity/recording_result.dart';
import 'package:audiodoc/ui/pages/_notes/recording_controller.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class NewNotesController extends GetxController {
  final player = AudioPlayer();

  RecordingController recordingController = Get.find<RecordingController>();
  Rx<RecordingResult?> recordingResult = Rx<RecordingResult?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    if (player.playing) {
      player.stop();
    }
    super.onClose();
  }

  void goBack(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }

  void saveRecording(BuildContext context) {
    context.goNamed(AppRoutes.nameNotesHome);
  }

  Future<void> startRecording() async {
    recordingResult.value = null;
    await recordingController.startRecording();
  }

  Future<RecordingResult?> stopRecording() async {
    RecordingResult? url = await recordingController.stopRecording();
    recordingResult.value = url;
    return url;
  }

  Future<void> pauseRecording() async {
    await recordingController.pauseRecording();
  }

  Future<void> resumeRecording() async {
    await recordingController.resumeRecording();
  }
}
