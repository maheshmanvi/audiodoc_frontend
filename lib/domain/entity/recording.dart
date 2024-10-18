import 'package:audiodoc/commons/utils/map_utils.dart';

class Recording {
  final String name;
  final String relativeUrl;
  final String? transcription;
  final String? summary;

  Recording({
    required this.name,
    required this.relativeUrl,
    this.transcription,
    this.summary,
  });

  static Recording fromMap(Map<String, dynamic> map) {
    String name = map.getString("name");
    String relativeUrl = map.getString("relativeUrl");
    String? transcription = map.getStringNullable("transcription");
    String? summary = map.getStringNullable("summary");
    return Recording(
      name: name,
      relativeUrl: relativeUrl,
      transcription: transcription,
      summary: summary,
    );
  }
}
