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
    final shiftTimesMap = <String, Map<String, String>>{};

    final rawShiftTimes = json['shiftTimesJson'] as Map<String, dynamic>?;
    if (rawShiftTimes != null) {
      rawShiftTimes.forEach((key, val) {
        if (val is Map<String, dynamic>) {
          String cleanKey = key;
          final lower = key.toLowerCase();
          if (lower == 'day') {
            cleanKey = 'Day';
          } else if (lower == 'evening') {
            cleanKey = 'Evening';
          } else if (lower == 'night') {
            cleanKey = 'Night';
          }
          shiftTimesMap[cleanKey] = {
            'start': val['startTime']?.toString() ?? '00:00',
            'end': val['endTime']?.toString() ?? '00:00',
          };
        }
      });
    }

    if (shiftTimesMap.isEmpty) {
      shiftTimesMap.addAll({
        'Day': {'start': '06:00', 'end': '14:00'},
        'Evening': {'start': '14:00', 'end': '22:00'},
        'Night': {'start': '22:00', 'end': '06:00'},
      });
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
        final code = (item['shiftCode'] as String? ?? 'off');
        final lower = code.toLowerCase();
        if (lower == 'off') {
          patternList.add('Off');
        } else {
          final matchKey = shiftTimesMap.keys.firstWhere(
            (k) => k.toLowerCase() == lower,
            orElse: () {
              if (lower == 'day') return 'Day';
              if (lower == 'evening') return 'Evening';
              if (lower == 'night') return 'Night';
              return code;
            },
          );
          patternList.add(matchKey);
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
