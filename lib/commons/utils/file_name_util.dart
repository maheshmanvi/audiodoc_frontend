class FileNameUtil {
  static String? getExtension(String fileName) {
    return fileName.split('.').last;
  }
}
