// import 'package:audiodoc/dto/recording_dto.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/recording_controller.dart';
// import '../models/recording.dart';
// import '../services/database_manager.dart';
//
//
// class HomePageController extends GetxController {
//
//   final RecordingController recordingController = Get.find();
//
//
//
//
//   late DatabaseManager dbManager;
//
//   @override
//   void onInit() {
//     super.onInit();
//     dbManager = DatabaseManager();
//   }
//
//   Future<void> playRecording(RecordingDto recordingDto) async {
//     selectedRecording.value = true;
//     selectedRecord.value = await dbManager.fetchRecordingById(recordingDto.id);
//   }
//
// }
