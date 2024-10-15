import 'dart:math' as Math;

class FileSizeUtil {
  static String toHumanReadable(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (bytes == 0) ? 0 : (Math.log(bytes) / Math.log(1024)).floor();
    double size = bytes / Math.pow(1024, i);
    String sizeStr = size.toStringAsFixed(size.truncateToDouble() == size ? 0 : 1);
    return "$sizeStr ${suffixes[i]}";
  }
}
