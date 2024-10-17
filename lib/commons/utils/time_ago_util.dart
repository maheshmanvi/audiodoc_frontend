import 'package:intl/intl.dart';

class TimeAgoUtil {
  // Method to format DateTime into a human-readable "time ago" format
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      // More than a day ago
      if (difference.inDays == 1) {
        return 'Yesterday ${DateFormat.jm().format(dateTime)}';
      }
      return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
    } else if (difference.inHours >= 1) {
      // More than an hour ago but less than a day
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      // More than a minute ago but less than an hour
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      // Less than a minute ago
      return 'Just now';
    }
  }

  static String defaultDateFormat(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}
