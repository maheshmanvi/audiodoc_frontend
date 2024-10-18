import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/domain/entity/recording_result.dart';
import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordingController extends GetxController {
  final BuildContext context;

  RecordingController({
    required this.context,
  });

  final recorder = AudioRecorder();
  final Rx<RecordState> recordState = Rx<RecordState>(RecordState.stop);
  final Rx<Duration> duration = Rx<Duration>(Duration.zero);
  Rx<Amplitude> amplitude = Rx<Amplitude>(Amplitude(current: 0, max: 0));
  Timer? _timer;

  stt.SpeechToText speech = stt.SpeechToText();

  Rx<String?> sttStatus = Rx<String?>(null);

  final sttResultMap = ValueNotifier(LinkedHashMap<int, RxString>());
  int speechSession = 1;
  final RxString sttResultString = RxString("");


  _updateSttResult(String result) {
    sttResultMap.value[speechSession]?.value = result;

    // log the map
    logger.d("STT Result Map: ${sttResultMap.value}");

    sttResultString.value = sttResultMap.value.map((key, value) => MapEntry(key, value.value)).values.join(" ");

    logger.d("STT Result: $sttResultString");
  }



  bool get isSpeechAvailable => speech.isAvailable;

  @override
  Future<void> onInit() async {
    recorder.onStateChanged().listen((status) {
      logger.d("Recording status: $status");
      recordState.value = status;

      // Stop the timer if recording is stopped
      if (status == RecordState.stop) {
        _stopTimer();
      }
    });

    bool available = await speech.initialize(
      onStatus: (status) => sttStatus.value = status,
      onError: (speechError) {
        AppSnackBar.showErrorToast(context, message: "Failed to initialize speech to text: ${speechError.errorMsg}");
      },
    );

    recorder.onAmplitudeChanged(Duration(seconds: 1)).listen((amplitude) => this.amplitude.value = amplitude);
    super.onInit();
  }

  @override
  void onClose() {
    recorder.dispose();
    _stopTimer();
    super.onClose();
  }

  // List to store audio chunks
  List<Uint8List> _recordedBytes = [];

  // Timer to update the duration
  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      duration.value = duration.value + Duration(seconds: 1);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Start recording and store each audio chunk in _recordedBytes
  Future<void> startRecording({Function(AppException)? onError}) async {
    if (await recorder.hasPermission()) {
      RecordConfig recordConfig = const RecordConfig(encoder: AudioEncoder.wav);
      _recordedBytes.clear();
      await recorder.start(recordConfig, path: "");

      if (isSpeechAvailable) {
        _startSpeechToText();
      }

      // Start updating the duration
      duration.value = Duration.zero; // Reset duration
      _startTimer();
    } else {
      onError?.call(AppException(errorCode: "PERMISSION_DENIED", message: "Permission denied", description: "Permission denied to record audio"));
    }
  }

  Future<RecordingResult?> stopRecording() async {
    String? path = await recorder.stop();
    _stopTimer();

    speech.stop();


    if (path == null) {
      return null;
    }

    RecordingResult? result = RecordingResult.now(path: path, duration: duration.value, sttResult: sttResultString.value);

    // Reset the Values for next recording
    sttResultMap.value.clear();
    sttResultString.value = "";
    logger.d("Recording result: $result");
    duration.value = Duration.zero;
    return result;
  }

  Future<void> pauseRecording() async {
    await recorder.pause();

    // Stop the STT
    speech.stop();

    _stopTimer();
  }

  Future<void> resumeRecording() async {
    await recorder.resume();

    // Start the STT
    if (isSpeechAvailable) {
      _resumeTTS();
    }

    _startTimer();
  }

  bool isRecording() {
    return recordState.value == RecordState.record;
  }

  bool isPaused() {
    return recordState.value == RecordState.pause;
  }

  Future<void> _startSpeechToText() async {
    if(speech.isListening) {
      speech.stop();
    }
    sttResultMap.value.clear();
    speechSession = 1;
    sttResultMap.value[speechSession] = RxString("");
    await speech.listen(
      onResult: (result) {
        _updateSttResult(result.recognizedWords);
      },
      listenFor: Duration(hours: 1),
      localeId: 'en_US',
    );
  }

  Future<void> _resumeTTS() async {
    if(speech.isListening) {
      speech.stop();
    }
    speechSession =  speechSession + 1;
    logger.d("Resuming STT with the new session: $speechSession");
    sttResultMap.value[speechSession] = RxString("");
    await speech.listen(
      onResult: (result) {
        _updateSttResult(result.recognizedWords);
      },
      listenFor: Duration(hours: 1),
      localeId: 'en_US',
    );
  }
}
