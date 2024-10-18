import 'package:audiodoc/commons/utils/map_utils.dart';

class SummarizeResponse {

  final String summary;

  SummarizeResponse({
    required this.summary,
  });

  factory SummarizeResponse.fromMap(Map<String, dynamic> map) {
    String summary = map.getString("summary");
    return SummarizeResponse(
      summary: summary,
    );
  }

}
