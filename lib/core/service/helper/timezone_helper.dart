class TimezoneHelper {
  /// Returns the Duration offset for the backend session timezone (Europe/Zurich) relative to UTC.
  /// Returns UTC+2 (CEST) during summer (last Sunday in March to last Sunday in October)
  /// and UTC+1 (CET) during winter.
  static Duration getSessionUtcOffset({DateTime? forDate}) {
    final date = forDate ?? DateTime.now();
    return _isEuropeanDst(date) ? const Duration(hours: 2) : const Duration(hours: 1);
  }

  static bool _isEuropeanDst(DateTime dt) {
    if (dt.month < 3 || dt.month > 10) return false;
    if (dt.month > 3 && dt.month < 10) return true;

    if (dt.month == 3) {
      final lastSunday = 31 - ((DateTime(dt.year, 3, 31).weekday) % 7);
      return dt.day >= lastSunday;
    } else {
      final lastSunday = 31 - ((DateTime(dt.year, 10, 31).weekday) % 7);
      return dt.day < lastSunday;
    }
  }

  /// Converts a user-selected civil datetime (e.g. 13:30)
  /// into an ISO-8601 UTC string (e.g. 11:30:00.000Z) that the Europe/Zurich backend converts back to 13:30.
  static String formatToSessionUtcIso(DateTime selectedDateTime) {
    final offset = getSessionUtcOffset(forDate: selectedDateTime);
    final wallClockUtc = DateTime.utc(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      selectedDateTime.hour,
      selectedDateTime.minute,
      selectedDateTime.second,
    );
    final sessionUtc = wallClockUtc.subtract(offset);
    return sessionUtc.toIso8601String();
  }

  /// Parses a UTC timestamp string from the backend into the Europe/Zurich session's local DateTime
  static DateTime parseSessionUtcToLocal(String isoString) {
    final parsedUtc = DateTime.parse(isoString).toUtc();
    final offset = getSessionUtcOffset(forDate: parsedUtc);
    return DateTime(
      parsedUtc.year,
      parsedUtc.month,
      parsedUtc.day,
      parsedUtc.hour,
      parsedUtc.minute,
      parsedUtc.second,
    ).add(offset);
  }
}
