import 'dart:typed_data';

import 'package:audiodoc/domain/entity/attachment_type.dart';
import 'package:file_picker/src/platform_file.dart';

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

  static LAttachment? fromPlatformFile(PlatformFile file) {
    final bytes = file.bytes;
    if (bytes == null) {
      return null;
    }

    return LAttachment(
      fileName: file.name,
      type: AttachmentType.fromFileName(file.name),
      bytes: bytes,
      size: bytes.length,
    );
  }
}
