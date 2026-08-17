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
        String codeStr = '';
        if (val is Map<String, dynamic>) {
          codeStr = val['shiftCode']?.toString() ?? '';
        } else if (val != null) {
          codeStr = val.toString();
        }
        final lower = codeStr.toLowerCase();
        if (lower == 'off') {
          overridesMap[dateKey] = 'Off';
        } else {
          final matchKey = shiftTimesMap.keys.firstWhere(
            (k) => k.toLowerCase() == lower,
            orElse: () {
              if (lower == 'day' || lower == 'd') return 'Day';
              if (lower == 'evening' || lower == 'e') return 'Evening';
              if (lower == 'night' || lower == 'n') return 'Night';
              return codeStr;
            },
          );
          overridesMap[dateKey] = matchKey;
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
