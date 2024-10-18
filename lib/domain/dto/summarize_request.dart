class SummarizeRequest {
  final String transcription;

  SummarizeRequest({
    required this.transcription,
  });

  Map<String, dynamic> toMap() {
    return {
      "transcription": transcription,
    };
  }
}
