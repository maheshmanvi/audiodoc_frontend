import 'package:audiodoc/commons/utils/map_utils.dart';

class Recording {
  final String name;
  final String relativeUrl;
  final String? transcription;
  final String? summary;
  final String? cues;

  Recording({
    required this.name,
    required this.relativeUrl,
    this.transcription,
    this.summary,
    this.cues,
  });

  static Recording fromMap(Map<String, dynamic> map) {
    String name = map.getString("name");
    String relativeUrl = map.getString("relativeUrl");
    String? transcription = map.getStringNullable("transcription");
    String? summary = map.getStringNullable("summary");
    String? cues = map.getStringNullable("cues");
    return Recording(
      name: name,
      relativeUrl: relativeUrl,
      transcription: transcription,
      summary: summary,
      cues: cues
    );
  }
}
