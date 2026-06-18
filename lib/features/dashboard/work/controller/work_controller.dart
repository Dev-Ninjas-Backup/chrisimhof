import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:chrisimhof/features/dashboard/work/service/work_service.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';

class WorkController extends GetxController {
  final startHour = 22.obs;
  final startMinute = 0.obs;
  final endHour = 6.obs;
  final endMinute = 0.obs;
  final selectedShiftType = 'Off'.obs;

  // Weekly pattern — defaults to "Off" for all days until API data arrives
  final weeklyPattern = <Map<String, String>>[
    {'day': 'M', 'shift': 'Off'},
    {'day': 'T', 'shift': 'Off'},
    {'day': 'W', 'shift': 'Off'},
    {'day': 'T', 'shift': 'Off'},
    {'day': 'F', 'shift': 'Off'},
    {'day': 'S', 'shift': 'Off'},
    {'day': 'S', 'shift': 'Off'},
  ].obs;

  final defaultRotation = ''.obs;
  final shiftReminders = 'On · 30 min before'.obs;
  final timeZone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromDashboard();
    fetchFromSession();
  }

  void _initializeFromDashboard() {
    try {
      final dashboardController = Get.find<DashboardController>();
      final data = dashboardController.dashboardData.value;
      
      final shift = data.workShift.toLowerCase();
      if (shift.contains('day') || shift.contains('jour')) {
        selectedShiftType.value = 'Day';
      } else if (shift.contains('evening') || shift.contains('après-midi') || shift.contains('apres-midi')) {
        selectedShiftType.value = 'Evening';
      } else if (shift.contains('night') || shift.contains('nuit') || shift.contains('soir')) {
        selectedShiftType.value = 'Night';
      } else {
        selectedShiftType.value = 'Off';
      }

      // Extract start & end times
      final times = data.workShiftCountdown.split(RegExp(r'[\s—\-\+]+'));
      if (times.length >= 2) {
        final startParts = times[0].split(':');
        if (startParts.length == 2) {
          startHour.value = int.tryParse(startParts[0]) ?? startHour.value;
          startMinute.value = int.tryParse(startParts[1]) ?? startMinute.value;
        }
        final endParts = times[1].split(':');
        if (endParts.length == 2) {
          endHour.value = int.tryParse(endParts[0]) ?? endHour.value;
          endMinute.value = int.tryParse(endParts[1]) ?? endMinute.value;
        }
      }
    } catch (e) {
      debugPrint('WorkController: Error initializing from dashboard data: $e');
    }
  }

  Future<void> fetchFromSession() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      if (token.isEmpty) return;

      final locale = Get.locale?.languageCode == 'fr' ? 'fr' : 'en';
      final sessionUri = Uri.parse(Urls.createCalculatorSession).replace(
        queryParameters: {'locale': locale},
      );

      final sessionResponse = await http.get(
        sessionUri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('WorkController session GET status: ${sessionResponse.statusCode}');

      if (sessionResponse.statusCode == 200 || sessionResponse.statusCode == 201) {
        final decoded = jsonDecode(sessionResponse.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        if (data == null) return;

        final liveScores = data['liveScores'] as Map<String, dynamic>?;

        // 1. tabs.work — full tab with weeklyPatternDisplay
        final workTab = liveScores?['tabs']?['work'] as Map<String, dynamic>?;
        if (workTab != null) {
          updateFromLiveScoresTab(workTab);
          return;
        }

        // 2. weeklyPatternDisplay directly on liveScores
        final patternOnLiveScores = liveScores?['weeklyPatternDisplay'] as List?;
        if (patternOnLiveScores != null && patternOnLiveScores.isNotEmpty) {
          weeklyPattern.assignAll(
            patternOnLiveScores.map((item) => {
              'day': item['day'] as String? ?? '',
              'shift': item['shiftCode'] as String? ?? 'Off',
            }).toList(),
          );
          debugPrint('WorkController: loaded weeklyPatternDisplay from liveScores');
          return;
        }

        // 3. workInfo.weeklyPattern
        final workInfo = liveScores?['workInfo'] as Map<String, dynamic>?;
        final patternOnWorkInfo = workInfo?['weeklyPattern'] as List?;
        if (patternOnWorkInfo != null && patternOnWorkInfo.isNotEmpty) {
          weeklyPattern.assignAll(
            patternOnWorkInfo.map((item) => {
              'day': item['day'] as String? ?? '',
              'shift': item['shiftCode'] as String? ?? 'Off',
            }).toList(),
          );
          debugPrint('WorkController: loaded weeklyPattern from workInfo');
          return;
        }

        // 4. weeklyPattern directly on data root
        final patternOnData = data['weeklyPattern'] as List?;
        if (patternOnData != null && patternOnData.isNotEmpty) {
          weeklyPattern.assignAll(
            patternOnData.map((item) => {
              'day': item['day'] as String? ?? '',
              'shift': item['shiftCode'] as String? ?? 'Off',
            }).toList(),
          );
          debugPrint('WorkController: loaded weeklyPattern from data root');
          return;
        }

        // 5. Fallback: populate shift type + times from workInfo
        if (workInfo != null) {
          updateWorkInfoFromSession(workInfo);
        }
      }
    } catch (e) {
      debugPrint('WorkController fetchFromSession error: $e');
    }
  }

  void updateWorkInfoFromSession(Map<String, dynamic> workInfo) {
    try {
      final shiftType = workInfo['shiftType'] as String? ?? 'off';
      if (shiftType.isNotEmpty) {
        selectedShiftType.value =
            shiftType[0].toUpperCase() + shiftType.substring(1);
      }
      if (workInfo['shiftStartTime'] != null) {
        final parts = (workInfo['shiftStartTime'] as String).split(':');
        if (parts.length == 2) {
          startHour.value = int.tryParse(parts[0]) ?? startHour.value;
          startMinute.value = int.tryParse(parts[1]) ?? startMinute.value;
        }
      }
      if (workInfo['shiftEndTime'] != null) {
        final parts = (workInfo['shiftEndTime'] as String).split(':');
        if (parts.length == 2) {
          endHour.value = int.tryParse(parts[0]) ?? endHour.value;
          endMinute.value = int.tryParse(parts[1]) ?? endMinute.value;
        }
      }
    } catch (e) {
      debugPrint('WorkController updateWorkInfoFromSession error: $e');
    }
  }

  void incrementStartHour() => startHour.value = (startHour.value + 1) % 24;
  void decrementStartHour() => startHour.value = (startHour.value - 1 + 24) % 24;
  void incrementStartMinute() => startMinute.value = (startMinute.value + 5) % 60;
  void decrementStartMinute() => startMinute.value = (startMinute.value - 5 + 60) % 60;

  void incrementEndHour() => endHour.value = (endHour.value + 1) % 24;
  void decrementEndHour() => endHour.value = (endHour.value - 1 + 24) % 24;
  void incrementEndMinute() => endMinute.value = (endMinute.value + 5) % 60;
  void decrementEndMinute() => endMinute.value = (endMinute.value - 5 + 60) % 60;

  String get shiftDurationText {
    final startMin = startHour.value * 60 + startMinute.value;
    final endMin = endHour.value * 60 + endMinute.value;
    int diffMin = (endMin - startMin + 1440) % 1440;
    final hours = diffMin / 60.0;
    return hours == hours.toInt() ? '${hours.toInt()}h' : '${hours.toStringAsFixed(1)}h';
  }

  void selectShift(String shift) {
    selectedShiftType.value = shift;
    if (shift == 'Day') {
      startHour.value = 9; startMinute.value = 0; endHour.value = 17; endMinute.value = 0;
    } else if (shift == 'Evening') {
      startHour.value = 14; startMinute.value = 0; endHour.value = 22; endMinute.value = 0;
    } else if (shift == 'Night') {
      startHour.value = 22; startMinute.value = 0; endHour.value = 6; endMinute.value = 0;
    } else if (shift == 'Off') {
      startHour.value = 0; startMinute.value = 0; endHour.value = 0; endMinute.value = 0;
    }
  }

  void toggleDayShift(int index) {
    final currentShift = weeklyPattern[index]['shift'];
    String nextShift = 'Off';
    if (currentShift == 'N') {
      nextShift = 'Off';
    } else if (currentShift == 'Off') {
      nextShift = 'D';
    } else if (currentShift == 'D') {
      nextShift = 'E';
    } else if (currentShift == 'E') {
      nextShift = 'N';
    }
    weeklyPattern[index] = {'day': weeklyPattern[index]['day']!, 'shift': nextShift};
    saveWeeklyPattern();
  }

  void applyRotationPattern(String pattern) {
    defaultRotation.value = pattern;
    saveWorkSettings();
    final Map<String, List<String>> patterns = {
      '3-2-2 night': ['N', 'N', 'N', 'Off', 'Off', 'D', 'D'],
      '2-2-3 schedule': ['D', 'D', 'N', 'N', 'Off', 'Off', 'Off'],
      '4-4 split': ['D', 'D', 'D', 'D', 'Off', 'Off', 'Off'],
      'None (Fixed)': ['D', 'D', 'D', 'D', 'D', 'Off', 'Off'],
    };
    final list = patterns[pattern];
    if (list != null) {
      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      weeklyPattern.assignAll(List.generate(7, (i) => {'day': days[i], 'shift': list[i]}));
      saveWeeklyPattern();
    }
  }

  Future<void> saveWeeklyPattern() async {
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      if (sessionId.isEmpty || token.isEmpty) return;

      final patternCodes = weeklyPattern.map((d) => d['shift']!).toList();

      final response = await http.post(
        Uri.parse(Urls.createWeeklyPattern(sessionId)),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'pattern': patternCodes}),
      );

      debugPrint('Weekly pattern POST status: ${response.statusCode}');
      debugPrint('Weekly pattern POST body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local weeklyPattern from the authoritative server response
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final saved = decoded['data']?['pattern'] as List?;
        if (saved != null) {
          weeklyPattern.assignAll(
            saved.map((item) => {
              'day': item['day'] as String? ?? '',
              'shift': item['shiftCode'] as String? ?? 'Off',
            }).toList(),
          );
        }
      } else {
        debugPrint('Weekly pattern save failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('saveWeeklyPattern error: $e');
    }
  }

  void saveShift() async {
    EasyLoading.show(status: 'Saving work shift...');
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId();
      if (sessionId != null && sessionId.isNotEmpty) {
        final shiftType = selectedShiftType.value.toLowerCase();
        
        final startHStr = startHour.value.toString().padLeft(2, '0');
        final startMStr = startMinute.value.toString().padLeft(2, '0');
        final endHStr = endHour.value.toString().padLeft(2, '0');
        final endMStr = endMinute.value.toString().padLeft(2, '0');

        final shiftStartTime = shiftType == 'off' ? null : '$startHStr:$startMStr';
        final shiftEndTime = shiftType == 'off' ? null : '$endHStr:$endMStr';

        // 1. Post to Work Service
        await WorkService().saveWork(
          sessionId: sessionId,
          shiftType: shiftType,
          shiftStartTime: shiftStartTime,
          shiftEndTime: shiftEndTime,
        );

        // 2. Central session calculations
        await DashboardService().calculateResult(sessionId: sessionId);

        // 3. Sync and refresh dashboard controller
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}

        EasyLoading.showSuccess('Shift saved successfully!');
        Get.back();
      } else {
        EasyLoading.showError('No active session found.');
      }
    } catch (e) {
      debugPrint('Error saving work shift: $e');
      EasyLoading.showError('Failed to save shift.');
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> tabData) {
    try {
      if (tabData['shiftType'] != null) {
        final sType = tabData['shiftType'] as String;
        if (sType.isNotEmpty) {
          selectedShiftType.value = sType[0].toUpperCase() + sType.substring(1);
        }
      }
      if (tabData['shiftStartTime'] != null) {
        final parts = (tabData['shiftStartTime'] as String).split(':');
        if (parts.length == 2) {
          startHour.value = int.tryParse(parts[0]) ?? 22;
          startMinute.value = int.tryParse(parts[1]) ?? 0;
        }
      }
      if (tabData['shiftEndTime'] != null) {
        final parts = (tabData['shiftEndTime'] as String).split(':');
        if (parts.length == 2) {
          endHour.value = int.tryParse(parts[0]) ?? 6;
          endMinute.value = int.tryParse(parts[1]) ?? 0;
        }
      }

      final List? patternList = tabData['weeklyPatternDisplay'] as List?;
      if (patternList != null) {
        weeklyPattern.assignAll(patternList.map((item) {
          return {
            'day': item['day'] as String? ?? '',
            'shift': item['shiftCode'] as String? ?? 'Off',
          };
        }).toList());
      }

      final settings = tabData['settings'] as Map<String, dynamic>?;
      if (settings != null) {
        if (settings['defaultRotation'] != null) {
          defaultRotation.value = settings['defaultRotation'] as String;
        }
        if (settings['shiftReminderDisplay'] != null) {
          shiftReminders.value = settings['shiftReminderDisplay'] as String;
        }
        if (settings['timezoneDisplay'] != null) {
          timeZone.value = settings['timezoneDisplay'] as String;
        }
      }
    } catch (e) {
      debugPrint('WorkController socket update error: $e');
    }
  }

  void updateShiftReminders(String val) {
    shiftReminders.value = val;
    saveWorkSettings();
  }

  void updateTimeZone(String val) {
    timeZone.value = val;
    saveWorkSettings();
  }

  Future<void> saveWorkSettings() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      if (token.isEmpty) return;

      bool reminderEnabled = false;
      int reminderMinutes = 0;
      if (shiftReminders.value.startsWith('On')) {
        reminderEnabled = true;
        if (shiftReminders.value.contains('30 min')) {
          reminderMinutes = 30;
        } else if (shiftReminders.value.contains('1 hour')) {
          reminderMinutes = 60;
        } else if (shiftReminders.value.contains('2 hours')) {
          reminderMinutes = 120;
        }
      }

      String tz = 'Europe/Zurich';
      if (timeZone.value.contains('New York')) tz = 'America/New_York';
      else if (timeZone.value.contains('London')) tz = 'Europe/London';
      else if (timeZone.value.contains('Sydney')) tz = 'Australia/Sydney';

      final body = {
        "defaultRotation": defaultRotation.value,
        "shiftReminderEnabled": reminderEnabled,
        "shiftReminderMinutes": reminderMinutes,
        "timezone": tz,
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

      debugPrint('WorkSettings PATCH status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>?;
        if (data != null) {
          if (data['defaultRotation'] != null) {
            defaultRotation.value = data['defaultRotation'];
          }
          if (data['shiftReminderDisplay'] != null) {
            shiftReminders.value = data['shiftReminderDisplay'];
          }
          if (data['timezoneDisplay'] != null) {
            timeZone.value = data['timezoneDisplay'];
          }
        }
      }
    } catch (e) {
      debugPrint('WorkController saveWorkSettings error: $e');
    }
  }
}
