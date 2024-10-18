class TranscriptionRequest {
  final String audioURL;

  TranscriptionRequest({
    required this.audioURL,
  });

  Map<String, dynamic> toMap() {
    return {
      "audioURL": audioURL,
    };
  }
}
