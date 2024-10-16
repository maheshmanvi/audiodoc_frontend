import 'package:audiodoc/commons/utils/map_utils.dart';

class Recording {
  final String name;
  final String relativeUrl;

  Recording({
    required this.name,
    required this.relativeUrl,
  });

  static Recording fromMap(Map<String, dynamic> map) {
    String name = map.getString("name");
    String relativeUrl = map.getString("relativeUrl");
    return Recording(
      name: name,
      relativeUrl: relativeUrl,
    );
  }
}
