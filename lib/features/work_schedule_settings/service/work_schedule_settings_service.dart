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
}

