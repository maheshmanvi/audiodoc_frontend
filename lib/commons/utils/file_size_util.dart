class FileSizeUtil {
  static String humanReadable(int bytes) {
    var units = ['B', 'KB', 'MB'];

    // Ensure we're working with floating-point for division
    var value = bytes.toDouble();
    int unitIndex = 0;

    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    // Formatting value with max 2 decimal places, removing unnecessary trailing zeros
    var formattedValue = value.toStringAsFixed(2);
    if (formattedValue.endsWith('.00')) {
      formattedValue = formattedValue.substring(0, formattedValue.length - 3);
    }
    return '$formattedValue ${units[unitIndex]}';
  }
}
