import 'package:audiodoc/commons/logging/logger.dart';
import 'package:audiodoc/commons/utils/map_utils.dart';
import 'package:audiodoc/domain/entity/attachment_type.dart';

class Attachment {
  final String name;
  final AttachmentType type;
  final String relativeUrl;
  final int size;

  Attachment({
    required this.name,
    required this.type,
    required this.relativeUrl,
    required this.size,
  });

  static Attachment fromMap(Map<String, dynamic> map) {
    logger.d('Attachment.fromMap: $map');
    String name = map.getString("name");
    AttachmentType type = AttachmentType.fromFileExtension(map.getString("type"));
    String relativeUrl = map.getString("relativeUrl");
    int size = map.getInt("size");
    return Attachment(
      name: name,
      type: type,
      relativeUrl: relativeUrl,
      size: size,
    );
  }
}
