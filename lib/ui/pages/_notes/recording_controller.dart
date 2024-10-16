import 'dart:async';
import 'dart:typed_data';

import 'package:audiodoc/commons/exception/app_exception.dart';
import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/domain/entity/recording_result.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';

class RecordingController extends GetxController {
  final recorder = AudioRecorder();
  final Rx<RecordState> recordState = Rx<RecordState>(RecordState.stop);
  final Rx<Duration> duration = Rx<Duration>(Duration.zero);
  Rx<Amplitude> amplitude = Rx<Amplitude>(Amplitude(current: 0, max: 0));
  Timer? _timer;

  @override
  void onInit() {
    recorder.onStateChanged().listen((status) {
      logger.d("Recording status: $status");
      recordState.value = status;

      // Stop the timer if recording is stopped
      if (status == RecordState.stop) {
        _stopTimer();
      }
    });
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

    // reset the duration
    duration.value = Duration.zero;

    if (path == null) {
      return null;
    }
    RecordingResult? result = RecordingResult.now(path: path, duration: duration.value);
    return result;
  }

  Future<void> pauseRecording() async {
    await recorder.pause();
    _stopTimer();
  }

  Future<void> resumeRecording() async {
    await recorder.resume();
    _startTimer();
  }

  bool isRecording() {
    return recordState.value == RecordState.record;
  }

  bool isPaused() {
    return recordState.value == RecordState.pause;
  }
}
