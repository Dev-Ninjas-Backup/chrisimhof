import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WorkSettingsService {
  /// Silently update work schedule timezone settings using device's current location timezone.
  static Future<void> syncTimezoneSilently() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      if (token.trim().isEmpty) {
        debugPrint('[WorkSettings] Silent timezone sync skipped: No access token');
        return;
      }

      String deviceTimezone = 'Europe/Zurich';
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        final String localTz = tzInfo.identifier;
        if (localTz.isNotEmpty) {
          deviceTimezone = localTz;
        }
      } catch (e) {
        debugPrint('[WorkSettings] Error getting local timezone via plugin: $e');
      }

      debugPrint('[WorkSettings] Silently sending PATCH to ${Urls.createWorkSettings} with timezone: $deviceTimezone');

      final body = {
        "timezone": deviceTimezone,
      };

      final response = await http.patch(
        Uri.parse(Urls.createWorkSettings),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('[WorkSettings] PATCH status: ${response.statusCode}');
      debugPrint('[WorkSettings] PATCH response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final data = decoded['data'] as Map<String, dynamic>?;

        if (data != null) {
          final String? tz = data['timezone'] as String?;
          final String? tzDisplay = data['timezoneDisplay'] as String?;

          if (tz != null && tz.isNotEmpty) {
            await SharedPreferencesHelper.saveTimezone(tz);
          }
          if (tzDisplay != null && tzDisplay.isNotEmpty) {
            await SharedPreferencesHelper.saveTimezoneDisplay(tzDisplay);
          }

          if (Get.isRegistered<WorkController>()) {
            final workCtrl = Get.find<WorkController>();
            if (tzDisplay != null && tzDisplay.isNotEmpty) {
              workCtrl.timeZone.value = tzDisplay;
            } else if (tz != null && tz.isNotEmpty) {
              workCtrl.timeZone.value = tz;
            }
          }
          debugPrint('[WorkSettings] Timezone synchronized successfully! Timezone: $tz, Display: $tzDisplay');
        }
      } else {
        debugPrint('[WorkSettings] Failed to update work settings timezone: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[WorkSettings] Silent timezone sync exception: $e');
    }
  }
}
