import 'package:intl/intl.dart';

class DateFormatter {
  static String registerApiFormate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime parseRegisterApiDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static DateTime parseDateShort(String dateString) {
    return DateFormat('dd MMM yyyy').parse(dateString);
  }

  // Format: Tuesday, July 1, 2025
  static String formatDateLong(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  // Format: 01/07/2025
  static String formatSlash(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Format: 01-07-2025
  static String formatDash(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Format: 1 Jul 2025, 08:30 AM
  static String formatWithTime(DateTime date) {
    return DateFormat('d MMM yyyy, hh:mm a').format(date);
  }

  // Format: 08:30 AM
  static String formatTimeOnly(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  // Format: ISO 8601 (2025-07-01T08:30:00)
  static String formatToIso(DateTime date) {
    return date.toIso8601String();
  }

  // Parse string to DateTime safely
  static DateTime? tryParse(String dateStr, {String pattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(pattern).parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Ordinal suffix for day: 1 → st, 2 → nd, 3 → rd, 4 → th, 21 → st, etc.
  static String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Format: 2nd February, 2026
  static String formatDateWithOrdinal(DateTime date) {
    final day = date.day;
    final monthYear = DateFormat('MMMM, yyyy').format(date);
    return '${day}${_ordinalSuffix(day)} $monthYear';
  }

  /// Format race date and time from UTC string (e.g. ISO): "2nd February, 2026, 2:35 PM"
  static String formatRaceDateTime(String dateTimeUtc) {
    try {
      final dt = DateTime.parse(dateTimeUtc).toLocal();
      final datePart = formatDateWithOrdinal(dt);
      final timePart = formatTimeOnly(dt);
      return '$datePart, $timePart';
    } catch (e) {
      return dateTimeUtc;
    }
  }
}
