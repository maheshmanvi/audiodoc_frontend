import 'package:flutter/material.dart';

class FileTypeIcon {
  final IconData iconData;
  final Color color;
  final Color bgColor;

  FileTypeIcon({
    required this.iconData,
    required this.color,
    required this.bgColor,
  });

  static FileTypeIcon fromExtension(String extension) {
    extension = extension.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return FileTypeIcon(
          iconData: Icons.image,
          color: Colors.amber,
          bgColor: Colors.white,
        );
      case 'pdf':
        return FileTypeIcon(
          iconData: Icons.picture_as_pdf,
          color: Colors.red,
          bgColor: Colors.white,
        );
      case 'doc':
      case 'docx':
        return FileTypeIcon(
          iconData: Icons.description,
          color: Colors.blue,
          bgColor: Colors.white,
        );
      default:
        return FileTypeIcon(
          iconData: Icons.insert_drive_file,
          color: Colors.grey,
          bgColor: Colors.white,
        );
    }
  }
}
