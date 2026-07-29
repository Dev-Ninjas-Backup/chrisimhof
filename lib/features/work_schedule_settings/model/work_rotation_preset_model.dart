class WorkRotationPresetModel {
  final String key;
  final String label;
  final String description;
  final int cycleWeeks;
  final Map<String, Map<String, String>> shiftTimes;
  final List<String> pattern;

  WorkRotationPresetModel({
    required this.key,
    required this.label,
    required this.description,
    required this.cycleWeeks,
    required this.shiftTimes,
    required this.pattern,
  });

  factory WorkRotationPresetModel.fromJson(Map<String, dynamic> json) {
    final String key = json['key'] as String? ?? '';
    final String label = json['label'] as String? ?? '';
    final String description = json['description'] as String? ?? '';
    final int cycleWeeks = json['cycleWeeks'] as int? ?? 1;

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
      // Sort items by weekIndex * 7 + dayIndex
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

    // Fill pattern up to 7 * cycleWeeks if short
    final targetLength = 7 * cycleWeeks;
    if (patternList.length < targetLength) {
      patternList.addAll(
        List.generate(targetLength - patternList.length, (_) => 'Off'),
      );
    }

    return WorkRotationPresetModel(
      key: key,
      label: label,
      description: description,
      cycleWeeks: cycleWeeks,
      shiftTimes: shiftTimesMap,
      pattern: patternList,
    );
  }
}
