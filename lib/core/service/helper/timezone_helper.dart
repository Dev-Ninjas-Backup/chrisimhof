class TimezoneHelper {
  /// Returns the Duration offset for the device's local timezone relative to UTC.
  static Duration getSessionUtcOffset({DateTime? forDate}) {
    final date = forDate ?? DateTime.now();
    return date.timeZoneOffset;
  }

  /// Converts a user-selected local datetime (e.g. 12:31 on the device)
  /// into an ISO-8601 UTC string (e.g. 06:31:00.000Z) based on the device's actual timezone.
  static String formatToSessionUtcIso(DateTime selectedDateTime) {
    return selectedDateTime.toUtc().toIso8601String();
  }

  /// Parses an ISO-8601 UTC timestamp string from the backend into the device's local DateTime.
  static DateTime parseSessionUtcToLocal(String isoString) {
    String str = isoString.trim();
    if (!str.endsWith('Z') &&
        !str.contains('+') &&
        !RegExp(r'-\d{2}:\d{2}$').hasMatch(str)) {
      str = '${str}Z';
    }
    return DateTime.parse(str).toLocal();
  }
}
