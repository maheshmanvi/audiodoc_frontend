import 'package:audiodoc/commons/utils/map_utils.dart';

class TranscriptionResponse {
  final String transcription;

  TranscriptionResponse({
    required this.transcription,
  });

  factory TranscriptionResponse.fromMap(Map<String, dynamic> map) {
    return TranscriptionResponse(
      transcription: map.getString("transcription"),
    );
  }
}
