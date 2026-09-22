class TimeFormatHelper {
  /// Converts a 24-hour time string (e.g. "21:30" or "08:00") into the desired format ("12h" or "24h").
  /// If [format] is "12h", returns e.g. "9:30 PM" or "8:00 AM".
  /// If [format] is "24h" or unparsable, returns the original time string (or normalized 24h).
  static String formatTime(String rawTime, {String format = '24h'}) {
    final trimmed = rawTime.trim();
    if (trimmed.isEmpty) return rawTime;

    if (format != '12h') {
      return trimmed;
    }

    final parts = trimmed.split(':');
    if (parts.length < 2) return rawTime;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return rawTime;

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$hour12:$minuteStr $period';
  }

  /// Converts a DateTime into a formatted time string based on format ("12h" or "24h").
  static String formatDateTime(DateTime dt, {String format = '24h'}) {
    final hour24 = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return formatTime('$hour24:$minute', format: format);
  }

  /// Formats a time range string like "06:00–14:00" or "06:00-14:00".
  static String formatTimeRange(String startTime, String endTime, {String format = '24h'}) {
    if (format == '12h') {
      return '${formatTime(startTime, format: '12h')} – ${formatTime(endTime, format: '12h')}';
    }
    return '$startTime–$endTime';
  }
}
