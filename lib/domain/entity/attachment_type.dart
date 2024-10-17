class AttachmentType {
  static const String typeImage = 'image';
  static const String typeDocument = 'document';

  final String type;
  final String name;
  final String extension;
  final bool inAppPreview;

  const AttachmentType({
    required this.type,
    required this.name,
    required this.extension,
    this.inAppPreview = false,
  });

  // Direct initialization of static final properties with the const constructor
  static const AttachmentType image = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'jpg',
    inAppPreview: true,
  );

  static const AttachmentType png = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'png',
    inAppPreview: true,
  );

  static const AttachmentType jpeg = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'jpeg',
    inAppPreview: true,
  );

  static const AttachmentType pdf = AttachmentType(
    type: typeDocument,
    name: 'PDF',
    extension: 'pdf',
    inAppPreview: true,
  );

  static const AttachmentType doc = AttachmentType(
    type: typeDocument,
    name: 'Document',
    extension: 'doc',
  );

  static const AttachmentType docx = AttachmentType(
    type: typeDocument,
    name: 'Document',
    extension: 'docx',
  );

  bool get isDocx => this == docx;
  bool get isDoc => this == doc;

  static List<AttachmentType> get values => [
        image,
        png,
        jpeg,
        pdf,
        doc,
        docx,
      ];

  bool get isImage => type == typeImage;

  bool get isDocument => type == typeDocument;

  static Map<String, AttachmentType> get map => {
        'jpg': image,
        'png': png,
        'jpeg': jpeg,
        'pdf': pdf,
        'doc': doc,
        'docx': docx,
      };

  bool get isPDF => this == pdf;

  static AttachmentType fromFileExtension(String extension) {
    final type = map[extension];
    if (type == null) {
      throw Exception("AttachmentType: Unsupported file extension: $extension");
    }
    return type;
  }

  static AttachmentType fromFileName(String name) {
    final extension = name.split('.').last;
    return fromFileExtension(extension);
  }
}
