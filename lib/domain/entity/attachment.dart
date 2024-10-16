import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/attachment_type.dart';

class Attachment {
  final String name;
  final AttachmentType type;
  final String relativeUrl;

  Attachment({
    required this.name,
    required this.type,
    required this.relativeUrl,
  });

  static Attachment fromMap(Map<String, dynamic> map) {
    String name = map.getString("name");
    AttachmentType type = AttachmentType.fromFileExtension(map.getString("type"));
    String relativeUrl = map.getString("relativeUrl");
    return Attachment(
      name: name,
      type: type,
      relativeUrl: relativeUrl,
    );
  }
}
