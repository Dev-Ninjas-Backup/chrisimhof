class UserWorkRotationModel {
  final String id;
  final int cycleWeeks;
  final String startDate;
  final String timezone;
  final String sourceTemplateKey;
  final Map<String, Map<String, String>> shiftTimes;
  final List<String> pattern;
  final Map<String, String> overrides;

  UserWorkRotationModel({
    required this.id,
    required this.cycleWeeks,
    required this.startDate,
    required this.timezone,
    required this.sourceTemplateKey,
    required this.shiftTimes,
    required this.pattern,
    required this.overrides,
  });

  factory UserWorkRotationModel.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String? ?? '';
    final int cycleWeeks = json['cycleWeeks'] as int? ?? 1;
    final String startDate = json['startDate'] as String? ?? '';
    final String timezone = json['timezone'] as String? ?? '';
    final String sourceTemplateKey = json['sourceTemplateKey'] as String? ?? '';

    // Parse shiftTimesJson
    final shiftTimesMap = <String, Map<String, String>>{
      'Day': {'start': '06:00', 'end': '14:00'},
      'Evening': {'start': '14:00', 'end': '22:00'},
      'Night': {'start': '22:00', 'end': '06:00'},
    };

    final rawShiftTimes = json['shiftTimesJson'] as Map<String, dynamic>?;
    if (rawShiftTimes != null) {
      if (rawShiftTimes.containsKey('day')) {
        final dayMap = rawShiftTimes['day'] as Map<String, dynamic>?;
        if (dayMap != null) {
          shiftTimesMap['Day'] = {
            'start': dayMap['startTime']?.toString() ?? '06:00',
            'end': dayMap['endTime']?.toString() ?? '14:00',
          };
        }
      }
      if (rawShiftTimes.containsKey('evening')) {
        final eveningMap = rawShiftTimes['evening'] as Map<String, dynamic>?;
        if (eveningMap != null) {
          shiftTimesMap['Evening'] = {
            'start': eveningMap['startTime']?.toString() ?? '14:00',
            'end': eveningMap['endTime']?.toString() ?? '22:00',
          };
        }
      }
      if (rawShiftTimes.containsKey('night')) {
        final nightMap = rawShiftTimes['night'] as Map<String, dynamic>?;
        if (nightMap != null) {
          shiftTimesMap['Night'] = {
            'start': nightMap['startTime']?.toString() ?? '22:00',
            'end': nightMap['endTime']?.toString() ?? '06:00',
          };
        }
      }
    }

    // Parse patternJson
    final List<String> patternList = [];
    final rawPattern = json['patternJson'] as List<dynamic>?;
    if (rawPattern != null && rawPattern.isNotEmpty) {
      final sortedItems = List<Map<String, dynamic>>.from(
        rawPattern.whereType<Map<String, dynamic>>(),
      );
      sortedItems.sort((a, b) {
        final wA = a['weekIndex'] as int? ?? 0;
        final dA = a['dayIndex'] as int? ?? 0;
        final wB = b['weekIndex'] as int? ?? 0;
        final dB = b['dayIndex'] as int? ?? 0;
        return (wA * 7 + dA).compareTo(wB * 7 + dB);
      });

      for (final item in sortedItems) {
        final code = (item['shiftCode'] as String? ?? 'off').toLowerCase();
        if (code == 'night') {
          patternList.add('N');
        } else if (code == 'evening') {
          patternList.add('E');
        } else if (code == 'day') {
          patternList.add('D');
        } else {
          patternList.add('Off');
        }
      }
    }

    final targetLength = 7 * cycleWeeks;
    if (patternList.length < targetLength) {
      patternList.addAll(
        List.generate(targetLength - patternList.length, (_) => 'Off'),
      );
    }

    // Parse overridesJson
    final overridesMap = <String, String>{};
    final rawOverrides = json['overridesJson'] as Map<String, dynamic>?;
    if (rawOverrides != null) {
      rawOverrides.forEach((dateKey, val) {
        final code = val.toString().toLowerCase();
        if (code == 'night') {
          overridesMap[dateKey] = 'N';
        } else if (code == 'evening') {
          overridesMap[dateKey] = 'E';
        } else if (code == 'day') {
          overridesMap[dateKey] = 'D';
        } else {
          overridesMap[dateKey] = 'Off';
        }
      });
    }

    return UserWorkRotationModel(
      id: id,
      cycleWeeks: cycleWeeks,
      startDate: startDate,
      timezone: timezone,
      sourceTemplateKey: sourceTemplateKey,
      shiftTimes: shiftTimesMap,
      pattern: patternList,
      overrides: overridesMap,
    );
  }
}
