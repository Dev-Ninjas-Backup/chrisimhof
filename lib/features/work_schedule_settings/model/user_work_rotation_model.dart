import 'package:chrisimhof/core/service/helper/shift_display_helper.dart';

class UserWorkRotationModel {
  final String id;
  final String? name;
  final int cycleWeeks;
  final String startDate;
  final String timezone;
  final String sourceTemplateKey;
  final Map<String, Map<String, String>> shiftTimes;
  final List<String> pattern;
  final Map<String, String> overrides;
  final Map<int, String> dayDisplayCodes;

  UserWorkRotationModel({
    required this.id,
    this.name,
    required this.cycleWeeks,
    required this.startDate,
    required this.timezone,
    required this.sourceTemplateKey,
    required this.shiftTimes,
    required this.pattern,
    required this.overrides,
    this.dayDisplayCodes = const {},
  });

  factory UserWorkRotationModel.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String? ?? '';
    final String? name = json['name'] as String?;
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
          } else {
            cleanKey = ShiftDisplayHelper.formatShiftName(key);
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
    final Map<int, String> dayDisplayCodesMap = {};
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

      int dayIdx = 0;
      for (final item in sortedItems) {
        final displayCode = item['displayCode'] as String?;
        if (displayCode != null && displayCode.isNotEmpty) {
          dayDisplayCodesMap[dayIdx] = displayCode;
        }
        dayIdx++;

        final code = (item['shiftCode'] as String? ?? 'off');
        final lower = code.toLowerCase();
        if (lower == 'off') {
          patternList.add('Off');
        } else {
          final matchKey = shiftTimesMap.keys.firstWhere(
            (k) =>
                k.toLowerCase() == lower ||
                k.toLowerCase().replaceAll(RegExp(r'[\s_]+'), '') ==
                    lower.replaceAll(RegExp(r'[\s_]+'), ''),
            orElse: () {
              if (lower == 'day') return 'Day';
              if (lower == 'evening') return 'Evening';
              if (lower == 'night') return 'Night';
              return ShiftDisplayHelper.formatShiftName(code);
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
            (k) =>
                k.toLowerCase() == lower ||
                k.toLowerCase().replaceAll(RegExp(r'[\s_]+'), '') ==
                    lower.replaceAll(RegExp(r'[\s_]+'), ''),
            orElse: () {
              if (lower == 'day' || lower == 'd') return 'Day';
              if (lower == 'evening' || lower == 'e') return 'Evening';
              if (lower == 'night' || lower == 'n') return 'Night';
              return ShiftDisplayHelper.formatShiftName(codeStr);
            },
          );
          overridesMap[dateKey] = matchKey;
        }
      });
    }

    return UserWorkRotationModel(
      id: id,
      name: name,
      cycleWeeks: cycleWeeks,
      startDate: startDate,
      timezone: timezone,
      sourceTemplateKey: sourceTemplateKey,
      shiftTimes: shiftTimesMap,
      pattern: patternList,
      overrides: overridesMap,
      dayDisplayCodes: dayDisplayCodesMap,
    );
  }
}
