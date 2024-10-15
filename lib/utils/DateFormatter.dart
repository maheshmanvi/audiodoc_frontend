import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String isoDateString) {
    final DateTime createdDate = DateTime.parse(isoDateString).toLocal();
    final DateTime now = DateTime.now().toLocal();
    final DateFormat timeFormat = DateFormat('jm');
    final DateFormat shortDateFormat = DateFormat('E, d MMM');
    final DateFormat fullDateFormat = DateFormat('E, d MMM, y');

    String formatTime(DateTime date) {
      return timeFormat.format(date).replaceAll('AM', 'am').replaceAll('PM', 'pm');
    }

    if (createdDate.day == now.day && createdDate.month == now.month && createdDate.year == now.year) {
      return 'Today at ${formatTime(createdDate)}';
    } else if (createdDate.difference(now).inDays == -1) {
      return 'Yesterday at ${formatTime(createdDate)}';
    } else if (createdDate.year == now.year) {
      return '${shortDateFormat.format(createdDate)} at ${formatTime(createdDate)}';
    } else {
      return '${fullDateFormat.format(createdDate)} at ${formatTime(createdDate)}';
    }
  }
}
