import 'dart:html' as html;
import 'dart:typed_data';

import 'package:audiodoc/commons/logging/logger.dart';

class RecordingResult {
  final String path;
  final Duration duration;
  final DateTime createdAt;
  final String _timeStampBasedName;

  RecordingResult({required this.path, required this.duration, required this.createdAt, required String timestampBasedName}) : _timeStampBasedName = timestampBasedName;

  factory RecordingResult.now({required String path, required Duration duration}) {
    DateTime now = DateTime.now();
    String timeStamp = "${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}";
    String name = "REC_$timeStamp";
    return RecordingResult(path: path, duration: duration, createdAt: DateTime.now(), timestampBasedName: name);
  }

  String getRecodingName() {
    return _timeStampBasedName;
  }

  Future<Uint8List> getRecordingBytes() async {
    logger.d('Getting recording bytes: $path');
    final response = await html.HttpRequest.request(path, responseType: "arraybuffer");
    final Uint8List bytes = (response.response as ByteBuffer).asUint8List();
    logger.d('Recording bytes: ${bytes.length}');
    return bytes;
  }


}
