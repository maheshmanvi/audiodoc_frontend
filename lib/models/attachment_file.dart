import 'package:audiodoc/models/attachment_type.dart';
import 'package:file_picker/file_picker.dart';

class AttachmentFile {
  final PlatformFile file;
  final String name;
  final AttachmentType type;
  final int size;

  AttachmentFile({
    required this.file,
    required this.name,
    required this.type,
    required this.size,
  });

  // fromPlatformFile
  static AttachmentFile? fromPlatformFile(PlatformFile file) {
    String fileName = file.name;
    String? fileExtension = file.extension?.toLowerCase();
    if (fileExtension == null) {
      throw Exception('File extension is required');
    }
    AttachmentType attachmentType = AttachmentType.fromExtension(fileExtension);
    return AttachmentFile(
      file: file,
      name: fileName,
      type: attachmentType,
      size: file.size,
    );
  }
}
