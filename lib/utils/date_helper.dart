import 'package:intl/intl.dart';

/// Date utility functions for DiaryX
class DateHelper {
  /// Private constructor to prevent instantiation
  DateHelper._();

  // Date formatters
  static final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _displayDateFormatter = DateFormat('MMM dd, yyyy');
  static final DateFormat _displayTimeFormatter = DateFormat('h:mm a');
  static final DateFormat _displayDateTimeFormatter = DateFormat(
    'MMM dd, yyyy • h:mm a',
  );

  /// Format date as YYYY-MM-DD
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format time as HH:MM
  static String formatTime(DateTime date) {
    return _timeFormatter.format(date);
  }

  /// Format date and time as YYYY-MM-DD HH:MM
  static String formatDateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Format date for display (e.g., "Jan 15, 2024")
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormatter.format(date);
  }

  /// Format time for display (e.g., "2:30 PM")
  static String formatDisplayTime(DateTime date) {
    return _displayTimeFormatter.format(date);
  }

  /// Format date and time for display (e.g., "Jan 15, 2024 • 2:30 PM")
  static String formatDisplayDateTime(DateTime date) {
    return _displayDateTimeFormatter.format(date);
  }

  /// Get relative time string (e.g., "2 hours ago", "Yesterday")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }
}
