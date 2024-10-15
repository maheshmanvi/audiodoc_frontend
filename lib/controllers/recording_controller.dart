import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../dto/recording_dto.dart';
import '../models/recording.dart';
import '../services/database_manager.dart';

class RecordingController extends GetxController {

  RxList<RecordingDto> recordings = <RecordingDto>[].obs;
  Rx<Recording?> selectedRecording = Rx<Recording?>(null);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final List<io.File> selectedFiles = [];

  MediaRecorder? _mediaRecorder;
  List<Blob> _recordedChunks = [];
  Blob? recordedBlob;
  var isRecording = false.obs;
  var isPaused = false.obs;

  var isPlaying = false.obs;
  var audioUrl = ''.obs;
  var isAudioLoaded  = false.obs;
  var currentPosition = 0.0.obs;
  var totalDuration = 1.0.obs;

  late final AudioPlayer player;
  late DatabaseManager dbManager;

  var fileName = ''.obs;
  var isSaving = false.obs;
  var isSaved = false.obs;
  var saveSuccess = false.obs;
  var saveFailed = false.obs;

  late TextEditingController fileNameController;


  var audioSelectedForPlaying = false.obs;



  @override
  void onInit() {
    super.onInit();
    player = AudioPlayer();
    dbManager = DatabaseManager();
    fetchAllRecordings();
    fileNameController = TextEditingController(text: fileName.value);
  }

  @override
  void onClose() {
    fileNameController.dispose();
    super.onClose();
  }

  @override
  void dispose(){
    super.dispose();
    player.dispose();
  }


  // Start recording audio
  Future<void> startRecording() async {
    try {
      final stream = await window.navigator.mediaDevices!.getUserMedia({'audio': true});
      _mediaRecorder = MediaRecorder(stream);

      _mediaRecorder!.addEventListener('dataavailable', (event) {
        if (event is BlobEvent && event.data!.size > 0) {
          _recordedChunks.add(event.data!);
        }
      });

      isRecording.value = true;
      isPaused.value = false;
      _mediaRecorder!.start();
    } catch (e) {
      errorMessage.value = "Error starting recording: $e";
      log(errorMessage.value);
    }
  }

  // Pause recording
  Future<void> pauseRecording() async {
    if (_mediaRecorder != null && isRecording.value && !isPaused.value) {
      _mediaRecorder!.pause();
      isPaused.value = true;
    }
  }

  // Resume recording
  Future<void> resumeRecording() async {
    if (_mediaRecorder != null && isRecording.value && isPaused.value) {
      _mediaRecorder!.resume();
      isPaused.value = false;
    }
  }

  // Stop recording
  Future<void> stopRecording() async {
    if (_mediaRecorder != null && isRecording.value) {
      fileName.value = generateFileName();
      fileNameController.text = fileName.value;
      _mediaRecorder!.stop();
      isRecording.value = false;

      _mediaRecorder!.addEventListener('stop', (event) {
        recordedBlob = Blob(_recordedChunks);
        _recordedChunks.clear();
        audioUrl.value = Url.createObjectUrlFromBlob(recordedBlob!);
        // downloadRecording();
      });
    }
  }

  // Save recording
  Future<void> saveRecording() async {
    try {
      isSaving.value = true; // Start saving
      final reader = FileReader();
      reader.readAsArrayBuffer(recordedBlob!);

      reader.onLoadEnd.listen((e) async {
        Uint8List audioData = reader.result as Uint8List;

        // Convert audio data to base64 string
        String audioBase64 = base64Encode(audioData);

        bool success = await dbManager.saveRecording(fileName.value, audioBase64);

        if (success) {
          saveSuccess.value = true;
          Get.snackbar('Success', 'Audio saved successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          fetchAllRecordings();
        } else {
          saveSuccess.value = false;
          Get.snackbar('Error', 'Failed to save audio!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      });

    } catch (e) {
      saveSuccess.value = false;
      errorMessage.value = "Error saving recording: $e";
      log(errorMessage.value);
      Get.snackbar('Error', 'Failed to save audio!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }



  // Download the recorded audio file
  void downloadRecording() {
    final url = Url.createObjectUrlFromBlob(recordedBlob!);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "${fileName}.wav")
      ..click();
    Url.revokeObjectUrl(url);
  }

  // Fetch all recordings
  Future<void> fetchAllRecordings() async {
    isLoading.value = true;
    try {
      recordings.value = await dbManager.fetchAllRecordings();
    } catch (e) {
      errorMessage.value = "Error fetching recordings: $e";
      log(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch a recording by its ID
  Future<Recording?> fetchRecordingById(String id) async {
    return await dbManager.fetchRecordingById(id);
  }



  //----------------------------------------------------------------------------

  // Load the audio to the player
  Future<void> loadAudio() async {
    try {
      if (audioUrl.value.isNotEmpty) {
        await player.setUrl(audioUrl.value);
      }
    } catch (e) {
      errorMessage.value = "Error loading audio: $e";
      log(errorMessage.value);
    }
  }

  // Play audio
  Future<void> playAudio() async {
    try {
      if (!isPlaying.value) {
        await player.play();
        isPlaying.value = true;
      }
    } catch (e) {
      errorMessage.value = "Error playing audio: $e";
      log(errorMessage.value);
    }
  }

  // Pause audio
  Future<void> pauseAudio() async {
    try {
      await player.pause();
      isPlaying.value = false;
    } catch (e) {
      errorMessage.value = "Error pausing audio: $e";
      log(errorMessage.value);
    }
  }

  // Stop audio
  Future<void> stopAudio() async {
    try {
      await player.stop();
      isPlaying.value = false;
      player.seek(Duration.zero);
    } catch (e) {
      errorMessage.value = "Error stopping audio: $e";
      log(errorMessage.value);
    }
  }

  String generateFileName() {
    DateTime now = DateTime.now().toLocal();
    String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return "Recording $formattedDate";
  }

  // Seek audio
  void seekAudio(double seconds) {
    try {
      player.seek(Duration(seconds: seconds.toInt()));
    } catch (e) {
      errorMessage.value = "Error seeking audio: $e";
      log(errorMessage.value);
    }
  }

  void playRecording(RecordingDto recording) {}

}
