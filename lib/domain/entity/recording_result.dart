class RecordingResult {
  final String path;
  final Duration duration;
  final DateTime createdAt;
  final String _timeStampBasedName;

  RecordingResult({required this.path, required this.duration, required this.createdAt, required String timestampBasedName}) : _timeStampBasedName = timestampBasedName;

  factory RecordingResult.now({required String path, required Duration duration}) {
    DateTime now = DateTime.now();
    String timeStamp = "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}";
    String name = "REC_$timeStamp";
    return RecordingResult(path: path, duration: duration, createdAt: DateTime.now(), timestampBasedName: name);
  }

  String getRecodingName() {
    return _timeStampBasedName;
  }
}
