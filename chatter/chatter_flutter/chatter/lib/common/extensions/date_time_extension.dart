import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled/localization/languages.dart';

/// Safely parse a date string from backend — never throws.
/// Returns null if the value is null, empty, or unparseable.
DateTime? safeParseDate(dynamic value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty || raw == 'null' || raw == '0000-00-00 00:00:00') return null;
  // Try ISO 8601 first (most common from Laravel)
  try { return DateTime.parse(raw); } catch (_) {}
  // Try common backend formats
  for (final pattern in const [
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd HH:mm',
    'dd MMM, yyyy h:mm a',
    'dd MMM yyyy h:mm a',
    'dd MMMM yyyy h:mm a',
    'MM/dd/yyyy hh:mm a',
    'dd MMM yyyy',
  ]) {
    try { return DateFormat(pattern).parse(raw); } catch (_) {}
  }
  return null;
}

/// Format a backend date value safely. Returns [fallback] if unparseable.
String safeFormatDate(dynamic value, {String fallback = '—'}) {
  final date = safeParseDate(value);
  if (date == null) return fallback;
  return DateFormat('dd MMM yyyy').format(date);
}

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = false}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      var formattedDate = DateFormat('d MMM').format(this);
      return (numericDates) ? '1 week ago' : formattedDate;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : LKeys.yesterday.tr;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hr';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : LKeys.anHourAgo.tr;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : LKeys.aMinuteAgo.tr;
    } else if (difference.inSeconds >= 3) {
      return LKeys.justNow.tr;
    } else {
      return LKeys.justNow.tr;
    }
  }

  String timeAgoShort() {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return '1 w';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 1) {
      return '1 d';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}hr';
    } else if (difference.inHours >= 1) {
      return '1 hr';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min';
    } else if (difference.inMinutes >= 1) {
      return '1 min';
    } else if (difference.inSeconds >= 3) {
      return 'now';
    } else {
      return 'now';
    }
  }

  String formatFullDate() {
    return DateFormat("dd MMM yyyy").format(this);
  }
}
