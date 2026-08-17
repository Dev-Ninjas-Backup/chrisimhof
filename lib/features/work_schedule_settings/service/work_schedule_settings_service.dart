import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/user_work_rotation_model.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_calendar_model.dart';
import 'package:chrisimhof/features/work_schedule_settings/model/work_rotation_preset_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WorkScheduleSettingsService {
  // GET /api/v1/calculator/work-rotation/presets
  Future<List<WorkRotationPresetModel>> fetchRotationPresets() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Fetching rotation presets from API...');

      final response = await http.get(
        Uri.parse(Urls.workRotationPreset),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Rotation presets GET status: ${response.statusCode}');
      debugPrint('Rotation presets GET body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        final presetsList = data?['presets'] as List<dynamic>?;

        if (presetsList != null) {
          return presetsList
              .whereType<Map<String, dynamic>>()
              .map((json) => WorkRotationPresetModel.fromJson(json))
              .toList();
        }
      } else {
        debugPrint('Failed to load presets: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('WorkScheduleSettingsService.fetchRotationPresets error: $e');
    }
    return [];
  }

  // GET /api/v1/calculator/work-rotation
  Future<UserWorkRotationModel?> fetchMyWorkRotation() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Fetching my work rotation from API...');

      final response = await http.get(
        Uri.parse(Urls.myWorkRotation),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('My work rotation GET status: ${response.statusCode}');
      debugPrint('My work rotation GET body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;

        if (data == null) {
          debugPrint('User work rotation data is null (toggle should be OFF)');
          return null;
        }

        return UserWorkRotationModel.fromJson(data);
      } else {
        debugPrint('Failed to fetch my work rotation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('WorkScheduleSettingsService.fetchMyWorkRotation error: $e');
    }
    return null;
  }

  // GET /api/v1/calculator/work-rotation/calendar?from=$from&days=$days
  Future<WorkRotationCalendarModel?> fetchWorkRotationCalendar({
    String? from,
    int days = 7,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final now = DateTime.now();
      final fromDateStr = from ??
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final uri = Uri.parse(Urls.workRotationCalendar(fromDateStr, days));
      debugPrint('Fetching work rotation calendar from $uri');

      final response = await http.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Work rotation calendar GET status: ${response.statusCode}');
      debugPrint('Work rotation calendar GET body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;

        if (data != null) {
          return WorkRotationCalendarModel.fromJson(data);
        }
      } else {
        debugPrint(
          'Failed to fetch work rotation calendar: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint(
        'WorkScheduleSettingsService.fetchWorkRotationCalendar error: $e',
      );
    }
    return null;
  }

  // DELETE /api/v1/calculator/work-rotation
  Future<bool> deleteWorkRotation() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Deleting work rotation from API...');

      final response = await http.delete(
        Uri.parse(Urls.deleteWorkRotation),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Delete work rotation status: ${response.statusCode}');
      debugPrint('Delete work rotation body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['success'] == true;
      } else {
        debugPrint('Failed to delete work rotation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('WorkScheduleSettingsService.deleteWorkRotation error: $e');
    }
    return false;
  }

  String _toApiKey(String key) {
    final lower = key.toLowerCase();
    if (lower == 'day' || lower == 'd') return 'day';
    if (lower == 'evening' || lower == 'e') return 'evening';
    if (lower == 'night' || lower == 'n') return 'night';
    if (lower == 'off') return 'off';
    return lower.replaceAll(RegExp(r'[\s\-]+'), '_').replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  // PUT /api/v1/calculator/work-rotation
  Future<bool> saveWorkRotation({
    required int cycleWeeks,
    required String startDate,
    required Map<String, Map<String, String>> shiftTimes,
    required List<String> pattern,
    String? sourceTemplateKey,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Saving work rotation via API (PUT)...');

      final shiftTimesJson = <String, Map<String, String>>{};
      shiftTimes.forEach((key, val) {
        final apiKey = _toApiKey(key);
        shiftTimesJson[apiKey] = {
          'startTime': val['start'] ?? '00:00',
          'endTime': val['end'] ?? '00:00',
        };
      });

      final patternJson = <Map<String, dynamic>>[];
      for (int w = 0; w < cycleWeeks; w++) {
        for (int d = 0; d < 7; d++) {
          final index = w * 7 + d;
          String shiftCodeStr = 'off';
          if (index < pattern.length) {
            final p = pattern[index];
            shiftCodeStr = _toApiKey(p);
          }
          patternJson.add({
            'weekIndex': w,
            'dayIndex': d,
            'shiftCode': shiftCodeStr,
          });
        }
      }

      final Map<String, dynamic> bodyMap = {
        'cycleWeeks': cycleWeeks,
        'startDate': startDate,
        'shiftTimesJson': shiftTimesJson,
        'patternJson': patternJson,
      };

      if (shiftTimes.containsKey('Day')) {
        bodyMap['dayShift'] = {
          'startTime': shiftTimes['Day']?['start'] ?? '06:00',
          'endTime': shiftTimes['Day']?['end'] ?? '14:00',
        };
      }
      if (shiftTimes.containsKey('Evening')) {
        bodyMap['eveningShift'] = {
          'startTime': shiftTimes['Evening']?['start'] ?? '14:00',
          'endTime': shiftTimes['Evening']?['end'] ?? '22:00',
        };
      }
      if (shiftTimes.containsKey('Night')) {
        bodyMap['nightShift'] = {
          'startTime': shiftTimes['Night']?['start'] ?? '22:00',
          'endTime': shiftTimes['Night']?['end'] ?? '06:00',
        };
      }

      if (sourceTemplateKey != null && sourceTemplateKey.trim().isNotEmpty) {
        bodyMap['sourceTemplateKey'] = sourceTemplateKey;
      }

      debugPrint('Save work rotation request body: ${jsonEncode(bodyMap)}');

      final response = await http.put(
        Uri.parse(Urls.myWorkRotation),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      debugPrint('Save work rotation PUT status: ${response.statusCode}');
      debugPrint('Save work rotation PUT body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['success'] == true;
      } else {
        debugPrint('Failed to save work rotation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('WorkScheduleSettingsService.saveWorkRotation error: $e');
    }
    return false;
  }

  // POST /api/v1/calculator/work-rotation/overrides
  Future<bool> saveWorkRotationOverride({
    required String date,
    required String shiftType,
    String? shiftStartTime,
    String? shiftEndTime,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Saving work rotation override via API (POST)...');

      final Map<String, dynamic> bodyMap = {
        'date': date,
        'shiftType': _toApiKey(shiftType),
      };

      if (shiftType.toLowerCase() != 'off') {
        if (shiftStartTime != null && shiftStartTime.isNotEmpty) {
          bodyMap['shiftStartTime'] = shiftStartTime;
        }
        if (shiftEndTime != null && shiftEndTime.isNotEmpty) {
          bodyMap['shiftEndTime'] = shiftEndTime;
        }
      }

      debugPrint('Save work rotation override request body: ${jsonEncode(bodyMap)}');

      final response = await http.post(
        Uri.parse(Urls.overrideWorkRotation),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      debugPrint('Save work rotation override status: ${response.statusCode}');
      debugPrint('Save work rotation override body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['success'] == true;
      } else {
        debugPrint(
          'Failed to save work rotation override: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint(
        'WorkScheduleSettingsService.saveWorkRotationOverride error: $e',
      );
    }
    return false;
  }

  // DELETE /api/v1/calculator/work-rotation/overrides/{date}
  Future<bool> deleteWorkRotationOverride(String date) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      debugPrint('Deleting work rotation override for $date via API (DELETE)...');

      final response = await http.delete(
        Uri.parse(Urls.deleteOverrideWorkRotation(date)),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Delete work rotation override status: ${response.statusCode}');
      debugPrint('Delete work rotation override body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded['success'] == true;
      } else {
        debugPrint(
          'Failed to delete work rotation override: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint(
        'WorkScheduleSettingsService.deleteWorkRotationOverride error: $e',
      );
    }
    return false;
  }
}


