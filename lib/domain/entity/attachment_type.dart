class AttachmentType {
  static const String typeImage = 'image';
  static const String typeDocument = 'document';

  final String type;
  final String name;
  final String extension;
  final bool inAppPreview;

  AttachmentType({
    required this.type,
    required this.name,
    required this.extension,
    this.inAppPreview = false,
  });

  static AttachmentType image = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'jpg',
    inAppPreview: true,
  );

  static AttachmentType png = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'png',
    inAppPreview: true,
  );

  static AttachmentType jpeg = AttachmentType(
    type: typeImage,
    name: 'Image',
    extension: 'jpeg',
    inAppPreview: true,
  );

  static AttachmentType pdf = AttachmentType(
    type: typeDocument,
    name: 'PDF',
    extension: 'pdf',
    inAppPreview: true,
  );

  static AttachmentType doc = AttachmentType(
    type: typeDocument,
    name: 'Document',
    extension: 'doc',
  );

  static AttachmentType docx = AttachmentType(
    type: typeDocument,
    name: 'Document',
    extension: 'docx',
  );

  List<AttachmentType> images = [
    AttachmentType.image,
    AttachmentType.png,
    AttachmentType.jpeg,
  ];

  List<AttachmentType> documents = [
    AttachmentType.pdf,
    AttachmentType.doc,
    AttachmentType.docx,
  ];

  static List<AttachmentType> values = [
    AttachmentType.image,
    AttachmentType.png,
    AttachmentType.jpeg,
    AttachmentType.pdf,
    AttachmentType.doc,
    AttachmentType.docx,
  ];

  bool get isImage => type == typeImage;

  bool get isDocument => type == typeDocument;

  static Map<String, AttachmentType> get map => {
        'image': image,
        'png': png,
        'jpeg': jpeg,
        'pdf': pdf,
        'doc': doc,
        'docx': docx,
      };

  static AttachmentType fromFileExtension(String string) {
    AttachmentType? type = map[string];
    if (type == null) {
      throw Exception("AttachmentType: Unsupported file extension: $string");
    }
    return type;
  }
}
