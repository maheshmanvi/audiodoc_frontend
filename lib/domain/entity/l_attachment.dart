import 'dart:typed_data';

import 'package:audiodoc/domain/entity/attachment_type.dart';

class LAttachment {
  final String fileName;
  final AttachmentType type;
  final Uint8List bytes;
  final int size;

  LAttachment({
    required this.fileName,
    required this.type,
    required this.bytes,
    required this.size,
  });
}
