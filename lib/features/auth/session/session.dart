import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';

class SessionService {
  /// Hits the session API and stores the retrieved sessionId in SharedPreferences.
  Future<String?> fetchAndStoreSessionId() async {
    try {
      final uri = Uri.parse(Urls.createCalculatorSession).replace(
        queryParameters: {
          'locale': Get.locale?.languageCode == 'fr' ? 'fr' : 'en',
        },
      );

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final storedSessionId = await SharedPreferencesHelper.getSessionId();

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("Session API response status code: ${response.statusCode}");
      debugPrint("Session API response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(responseData['data'] as Map);
          final newSessionId = dataMap['sessionId'] as String?;
          final statusStr = dataMap['status'] as String?;
          final waitingForMainWake = dataMap['waitingForMainWake'] == true;
          final startedAtStr =
              (dataMap['startedAt'] ?? dataMap['createdAt']) as String?;
          final expiresAtStr = dataMap['expiresAt'] as String?;

          if (newSessionId != null && newSessionId.isNotEmpty) {
            final bool sessionChanged = storedSessionId != null &&
                storedSessionId.isNotEmpty &&
                storedSessionId != newSessionId;
            final bool isPendingWake =
                waitingForMainWake || statusStr == 'PENDING_WAKE';

            if (sessionChanged || isPendingWake) {
              debugPrint(
                '[Session] Session rollover or PENDING_WAKE detected (old=$storedSessionId, new=$newSessionId, status=$statusStr). Resetting local tracking data.',
              );
              if (Get.isRegistered<DashboardController>()) {
                await Get.find<DashboardController>().resetTrackingData(
                  newSessionId: newSessionId,
                );
              } else {
                await _clearLocalTrackingPrefs();
              }
            }

            await SharedPreferencesHelper.saveSessionId(newSessionId);
            if (startedAtStr != null && startedAtStr.isNotEmpty) {
              await SharedPreferencesHelper.saveSessionStartedAtIso(
                startedAtStr,
              );
            } else if (sessionChanged || isPendingWake) {
              await SharedPreferencesHelper.saveSessionStartedAt(
                DateTime.now(),
              );
            }
            if (expiresAtStr != null && expiresAtStr.isNotEmpty) {
              await SharedPreferencesHelper.saveSessionExpiresAtIso(
                expiresAtStr,
              );
            }

            debugPrint("Successfully saved sessionId to SharedPreferences: $newSessionId");
            return newSessionId;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching and storing session ID: $e");
      return null;
    }
  }

  Future<void> _clearLocalTrackingPrefs() async {
    await SharedPreferencesHelper.saveCaffeineLogs('[]');
    final emptyHydration = List.generate(7, (_) => []).toList();
    await SharedPreferencesHelper.saveHydrationLogs(jsonEncode(emptyHydration));
    await SharedPreferencesHelper.saveMeals(
      jsonEncode({'dailyTarget': 3, 'meals': []}),
    );
    await SharedPreferencesHelper.saveSportsTodayMetrics(
      hasTodaySession: false,
      duration: 0,
      zone: '',
      sport: 'Rest day',
      distance: '',
      startTime: '',
      endTime: '',
      effort: '',
      type: '',
      recoveryScore: 100,
    );
    await SharedPreferencesHelper.saveSportsSessions('[]');
  }
}
