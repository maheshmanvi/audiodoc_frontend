class AttachmentType {
  static const String typeImage = 'image';

  final String type;
  final String name;
  final String extension;
  final bool supportsLocalPreview;

  AttachmentType({
    required this.type,
    required this.name,
    required this.extension,
    this.supportsLocalPreview = false,
  });

  static AttachmentType jpg = AttachmentType(
    type: typeImage,
    name: 'JPEG',
    extension: 'jpg',
    supportsLocalPreview: true,
  );

  static AttachmentType png = AttachmentType(
    type: typeImage,
    name: 'PNG',
    extension: 'png',
    supportsLocalPreview: true,
  );

  static AttachmentType jpeg = AttachmentType(
    type: typeImage,
    name: 'JPEG',
    extension: 'jpeg',
    supportsLocalPreview: true,
  );

  static AttachmentType pdf = AttachmentType(
    type: 'pdf',
    name: 'PDF',
    extension: 'pdf',
    supportsLocalPreview: true,
  );

  static AttachmentType doc = AttachmentType(
    type: 'doc',
    name: 'DOC',
    extension: 'doc',
  );

  static AttachmentType docx = AttachmentType(
    type: 'doc',
    name: 'DOCX',
    extension: 'docx',
  );


  static List<AttachmentType> imageTypes = [jpg, png, jpeg];
  static List<AttachmentType> documentTypes = [pdf, doc, docx];
  static List<AttachmentType> values = [jpg, png, jpeg, pdf, doc, docx];

  bool get isDoc => type == doc.type || type == docx.type;

  bool get isPDF => type == pdf.type;

  bool get isImage => type == typeImage;

  static AttachmentType fromExtension(String fileExtension) {
    fileExtension = fileExtension.toLowerCase();
    switch (fileExtension) {
      case 'jpg':
        return jpg;
      case 'png':
        return png;
      case 'jpeg':
        return jpeg;
      case 'pdf':
        return pdf;
      case 'doc':
      case 'docx':
        return doc;
      default:
        throw Exception('Unsupported file extension: $fileExtension');
    }
  }
}
