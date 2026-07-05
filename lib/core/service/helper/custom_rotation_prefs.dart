import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomRotationPrefs {
  static const String _enabledKey = 'custom_rotation_enabled';
  static const String _weeksKey = 'custom_rotation_weeks';
  static const String _startDateKey = 'custom_rotation_start_date';
  static const String _shiftTimesKey = 'custom_shift_times';
  static const String _patternKey = 'custom_rotation_pattern';
  static const String _overridesKey = 'custom_rotation_overrides';

  // Enable/disable custom rotation
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  // Rotation Weeks
  static Future<int> getWeeks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weeksKey) ?? 1;
  }

  static Future<void> setWeeks(int weeks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weeksKey, weeks);
  }

  // Start Date (yyyy-MM-dd)
  static Future<String> getStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_startDateKey) ?? '';
    if (dateStr.isEmpty) {
      // Default to today
      final now = DateTime.now();
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    return dateStr;
  }

  static Future<void> setStartDate(String dateStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_startDateKey, dateStr);
  }

  // Custom Shift Times (Day, Evening, Night)
  // Format: { 'Day': { 'start': '06:00', 'end': '14:00' }, ... }
  static Future<Map<String, Map<String, String>>> getShiftTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_shiftTimesKey) ?? '';
    if (jsonStr.isEmpty) {
      return {
        'Day': {'start': '06:00', 'end': '14:00'},
        'Evening': {'start': '14:00', 'end': '22:00'},
        'Night': {'start': '22:00', 'end': '06:00'},
      };
    }
    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final result = <String, Map<String, String>>{};
      decoded.forEach((key, val) {
        if (val is Map) {
          result[key] = {
            'start': val['start']?.toString() ?? '00:00',
            'end': val['end']?.toString() ?? '00:00',
          };
        }
      });
      return result;
    } catch (e) {
      debugPrint('Error decoding custom shift times: $e');
      return {
        'Day': {'start': '06:00', 'end': '14:00'},
        'Evening': {'start': '14:00', 'end': '22:00'},
        'Night': {'start': '22:00', 'end': '06:00'},
      };
    }
  }

  static Future<void> setShiftTimes(Map<String, Map<String, String>> times) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shiftTimesKey, jsonEncode(times));
  }

  // Rotation Pattern (list of shift codes: 'D', 'E', 'N', 'Off')
  // Length is 7 * weeks
  static Future<List<String>> getPattern(int weeks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_patternKey) ?? '';
    final targetLength = 7 * weeks;
    if (jsonStr.isEmpty) {
      return List.generate(targetLength, (_) => 'Off');
    }
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      final list = decoded.map((e) => e.toString()).toList();
      if (list.length < targetLength) {
        list.addAll(List.generate(targetLength - list.length, (_) => 'Off'));
      } else if (list.length > targetLength) {
        return list.sublist(0, targetLength);
      }
      return list;
    } catch (e) {
      debugPrint('Error decoding custom pattern: $e');
      return List.generate(targetLength, (_) => 'Off');
    }
  }

  static Future<void> setPattern(List<String> pattern) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_patternKey, jsonEncode(pattern));
  }

  // Date Overrides: specific date -> shift code
  static Future<Map<String, String>> getOverrides() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_overridesKey) ?? '';
    if (jsonStr.isEmpty) return {};
    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (e) {
      debugPrint('Error decoding overrides: $e');
      return {};
    }
  }

  static Future<void> setOverrides(Map<String, String> overrides) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_overridesKey, jsonEncode(overrides));
  }

  static Future<void> addOverride(String dateStr, String shiftCode) async {
    final overrides = await getOverrides();
    overrides[dateStr] = shiftCode;
    await setOverrides(overrides);
  }

  static Future<void> removeOverride(String dateStr) async {
    final overrides = await getOverrides();
    overrides.remove(dateStr);
    await setOverrides(overrides);
  }
}
