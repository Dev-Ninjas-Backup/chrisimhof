import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:get/get.dart';

class SportSession {
  final String title;
  final String subtitle;
  final String iconPath;

  SportSession({
    required this.title,
    required this.subtitle,
    required this.iconPath,
  });
}

class SportsController extends GetxController {
  // Today's Session metrics — neutral defaults; real data loads from SharedPrefs
  final RxBool hasTodaySession = false.obs;
  final RxInt todayDuration = 0.obs;
  final RxString todayZone = ''.obs;
  final RxString todaySport = 'Rest day'.obs;
  final RxString todayDistance = ''.obs;
  final RxString todayStartTime = ''.obs;
  final RxString todayEndTime = ''.obs;
  final RxString todayEffort = ''.obs;
  final RxString todayType = ''.obs;

  // Exact API display fields for the session card
  final RxString todayDisplayDuration = ''.obs;
  final RxString todayHeartRateZoneLabel = ''.obs;
  final RxString todayTimeRange = ''.obs;
  final RxString todayDisplayIntensity = ''.obs;
  final RxString todayDisplayType = ''.obs;

  // Recovery Impact metrics
  final RxInt recoveryScore = 100.obs;
  final RxString recoveryText = 'Log your activity to see recovery impact.'.obs;

  /// From cards.sport.readinessNote — e.g. "Consider a lighter session or mobility work today."
  final RxnString readinessNote = RxnString();

  // This Week sessions list
  final RxList<SportSession> sessionsList = <SportSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSportsData().then((_) {
      // Seed from DashboardController cache if it already loaded
      if (Get.isRegistered<DashboardController>()) {
        final db = Get.find<DashboardController>();
        final cached = db.sportCardData.value;
        if (cached != null) updateFromSportCard(cached);
      }
    });
  }

  Future<void> loadSportsData() async {
    try {
      final todayMetrics =
          await SharedPreferencesHelper.getSportsTodayMetrics();
      hasTodaySession.value = todayMetrics['hasTodaySession'] ?? false;
      todayDuration.value = todayMetrics['duration'] ?? 0;
      todayZone.value = todayMetrics['zone'] ?? '';
      todaySport.value = todayMetrics['sport'] ?? 'Rest day';
      todayDistance.value = todayMetrics['distance'] ?? '';
      todayStartTime.value = todayMetrics['startTime'] ?? '';
      todayEndTime.value = todayMetrics['endTime'] ?? '';
      todayEffort.value = todayMetrics['effort'] ?? '';
      todayType.value = todayMetrics['type'] ?? '';

      // Fallback: populate the display fields from the old metrics so it doesn't render blank on restart
      todayDisplayDuration.value = '${todayDuration.value} min';
      todayHeartRateZoneLabel.value = todayZone.value;
      if (todayStartTime.value.isNotEmpty && todayEndTime.value.isNotEmpty) {
        todayTimeRange.value = '${todayStartTime.value} → ${todayEndTime.value}';
      } else {
        todayTimeRange.value = '';
      }
      todayDisplayIntensity.value = todayEffort.value;
      todayDisplayType.value = todayType.value.isNotEmpty ? todayType.value : todaySport.value;

      recoveryScore.value = todayMetrics['recoveryScore'] ?? 100;
      _updateRecoveryText();

      final jsonStr = await SharedPreferencesHelper.getSportsSessions();
      if (jsonStr != null) {
        final List decoded = jsonDecode(jsonStr);
        sessionsList.assignAll(
          decoded
              .map(
                (s) => SportSession(
                  title: s['title'] ?? '',
                  subtitle: s['subtitle'] ?? '',
                  iconPath: s['iconPath'] ?? '',
                ),
              )
              .toList(),
        );
      }
      // No mock sessions — sessionsList stays empty if nothing saved
    } catch (e) {
      debugPrint('Error loading sports data: $e');
    }
  }

  Future<void> saveSportsData({bool syncWithServer = true}) async {
    try {
      await SharedPreferencesHelper.saveSportsTodayMetrics(
        hasTodaySession: hasTodaySession.value,
        duration: todayDuration.value,
        zone: todayZone.value,
        sport: todaySport.value,
        distance: todayDistance.value,
        startTime: todayStartTime.value,
        endTime: todayEndTime.value,
        effort: todayEffort.value,
        type: todayType.value,
        recoveryScore: recoveryScore.value,
      );

      final listToSave = sessionsList
          .map(
            (s) => {
              'title': s.title,
              'subtitle': s.subtitle,
              'iconPath': s.iconPath,
            },
          )
          .toList();
      await SharedPreferencesHelper.saveSportsSessions(jsonEncode(listToSave));

      if (syncWithServer) {
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error saving sports data: $e');
    }
  }

  // No mock session initializer — real data only comes from SharedPrefs or user input

  void addSession({
    required String activity,
    required int duration,
    required String zone,
    required String startTime,
    required String endTime,
    required String effort,
    required String type,
    String? distance,
  }) async {
    final bool isRest = activity == 'Rest day';

    // Save previous state for rollback if API fails
    final oldSessionsList = List<SportSession>.from(sessionsList);
    final oldHasTodaySession = hasTodaySession.value;
    final oldTodaySport = todaySport.value;
    final oldTodayDuration = todayDuration.value;
    final oldTodayZone = todayZone.value;
    final oldTodayStartTime = todayStartTime.value;
    final oldTodayEndTime = todayEndTime.value;
    final oldTodayEffort = todayEffort.value;
    final oldTodayType = todayType.value;
    final oldTodayDistance = todayDistance.value;
    final oldRecoveryScore = recoveryScore.value;

    // Optimistic Update
    String timeStr = '${duration}m';
    if (activity == 'Rest day') {
      timeStr = '—';
    } else if (zone.isNotEmpty) {
      timeStr += ' · $zone';
    }

    final newSession = SportSession(
      title: activity,
      subtitle: activity == 'Rest day' ? 'Today · —' : 'Today · $timeStr',
      iconPath: _getIconPathForActivity(activity),
    );

    // Update old "Today" to "Yesterday"
    for (int i = 0; i < sessionsList.length; i++) {
      final s = sessionsList[i];
      if (s.subtitle.startsWith('Today')) {
        sessionsList[i] = SportSession(
          title: s.title,
          subtitle: s.subtitle.replaceFirst('Today', 'Yesterday'),
          iconPath: s.iconPath,
        );
      } else if (s.subtitle.startsWith('Yesterday')) {
        sessionsList[i] = SportSession(
          title: s.title,
          subtitle: s.subtitle.replaceFirst('Yesterday', 'Earlier'),
          iconPath: s.iconPath,
        );
      }
    }

    sessionsList.insert(0, newSession);

    if (activity == 'Rest day') {
      hasTodaySession.value = false;
      recoveryScore.value = (recoveryScore.value + 15).clamp(0, 100);
      _updateRecoveryText();
    } else {
      hasTodaySession.value = true;
      todaySport.value = activity;
      todayDuration.value = duration;
      todayZone.value = zone;
      todayStartTime.value = startTime;
      todayEndTime.value = endTime;
      todayEffort.value = effort;
      todayType.value = type;
      if (distance != null && distance.isNotEmpty) {
        todayDistance.value = distance;
      } else {
        todayDistance.value = '';
      }

      int impact = 10;
      if (zone == 'Z5') {
        impact = 25;
      } else if (zone == 'Z4') {
        impact = 18;
      } else if (zone == 'Z3') {
        impact = 12;
      } else if (zone == 'Z2') {
        impact = 8;
      } else if (zone == 'Z1') {
        impact = 4;
      }

      recoveryScore.value = (recoveryScore.value - impact).clamp(0, 100);
      _updateRecoveryText();
    }

    if (!isRest) {
      EasyLoading.show(status: 'Saving session...');
    }

    bool apiSuccess = isRest; // Rest day doesn't call API
    if (!isRest) {
      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        if (sessionId.isNotEmpty) {
          double? distVal;
          if (distance != null && distance.isNotEmpty) {
            distVal = double.tryParse(distance);
          }

          String intensity = 'medium';
          final z = zone.toUpperCase();
          if (z == 'Z1' || z == 'Z2') {
            intensity = 'low';
          } else if (z == 'Z3') {
            intensity = 'medium';
          } else if (z == 'Z4' || z == 'Z5') {
            intensity = 'high';
          }

          String sportType = type.toLowerCase().trim();
          if (sportType != 'cardio' &&
              sportType != 'strength' &&
              sportType != 'mobility' &&
              sportType != 'mixed' &&
              sportType != 'other') {
            final actLower = activity.toLowerCase();
            if (actLower.contains('run') || actLower.contains('cycling') || actLower.contains('swimming')) {
              sportType = 'cardio';
            } else if (actLower.contains('strength')) {
              sportType = 'strength';
            } else if (actLower.contains('walking')) {
              sportType = 'mobility';
            } else {
              sportType = 'other';
            }
          }

          // Midpoints derived from zone ranges: Z1:95-114, Z2:114-133, Z3:133-152, Z4:152-171, Z5:171-190
          int heartRate = 142; // default to Z3 midpoint
          if (z == 'Z1') {
            heartRate = 104; // avg of 95-114
          } else if (z == 'Z2') {
            heartRate = 123; // avg of 114-133
          } else if (z == 'Z3') {
            heartRate = 142; // avg of 133-152
          } else if (z == 'Z4') {
            heartRate = 161; // avg of 152-171
          } else if (z == 'Z5') {
            heartRate = 180; // avg of 171-190
          }

          await DashboardService().patchQuickAddLog(
            sessionId: sessionId,
            newSportSessions: [
              {
                'timestampStart': startTime,
                'durationMinutes': duration,
                'intensity': intensity,
                'sportType': sportType,
                'distanceKm': distVal,
                'heartRateAvgBpm': heartRate,
              },
            ],
          );
          apiSuccess = true;
        }
      } catch (e) {
        debugPrint('Sports API quickAdd error: $e');
      } finally {
        EasyLoading.dismiss();
      }
    }

    if (!apiSuccess) {
      // Revert if API failed
      sessionsList.assignAll(oldSessionsList);
      hasTodaySession.value = oldHasTodaySession;
      todaySport.value = oldTodaySport;
      todayDuration.value = oldTodayDuration;
      todayZone.value = oldTodayZone;
      todayStartTime.value = oldTodayStartTime;
      todayEndTime.value = oldTodayEndTime;
      todayEffort.value = oldTodayEffort;
      todayType.value = oldTodayType;
      todayDistance.value = oldTodayDistance;
      recoveryScore.value = oldRecoveryScore;
      _updateRecoveryText();
    } else {
      await saveSportsData();
    }
  }

  void _updateRecoveryText() {
    final score = recoveryScore.value;
    if (score >= 80) {
      recoveryText.value =
          'Recovery is excellent — ready for high-intensity training.';
    } else if (score >= 50) {
      recoveryText.value =
          'Recovery is moderate — skip intense training tomorrow.';
    } else {
      recoveryText.value =
          'Recovery is low — prioritize rest and light stretching today.';
    }
  }

  String _getIconPathForActivity(String activity) {
    switch (activity.toLowerCase()) {
      case 'mobility':
        return IconPath.running;
      case 'strength':
        return IconPath.strength;
      case 'cardio':
        return IconPath.yoga;
      case 'mixed':
        return IconPath.yoga;
      case 'rest day':
      default:
        return IconPath.restDay;
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> sportTab) {
    try {
      final sessions = sportTab['sessions'] as List? ?? [];
      final mappedSessions = sessions.map((s) {
        final title = s['displayType'] ?? s['sportType'] ?? 'Workout';
        final duration = s['displayDuration'] ?? '${s['durationMinutes']} min';
        final zone = s['zoneLabel'] as String? ?? '';
        final subtitle =
            'Today · $duration${zone.isNotEmpty ? ' · $zone' : ''}';
        return SportSession(
          title: title,
          subtitle: subtitle,
          iconPath: _getIconPathForActivity(title),
        );
      }).toList();

      sessionsList.assignAll(mappedSessions);

      final todaySession = sportTab['todaySession'] as Map<String, dynamic>?;
      if (todaySession != null) {
        hasTodaySession.value = true;
        todayDuration.value =
            (todaySession['durationMinutes'] as num?)?.toInt() ?? 0;
        todayZone.value = todaySession['zoneLabel'] as String? ?? '';
        todaySport.value =
            todaySession['displayType'] ??
            todaySession['sportType'] ??
            'Workout';
        todayDistance.value =
            todaySession['distanceDisplay'] ??
            (todaySession['distanceKm']?.toString() ?? '');
        todayStartTime.value = todaySession['timestampStart'] as String? ?? '';
        todayEndTime.value = todaySession['timestampEnd'] as String? ?? '';
        todayEffort.value = todaySession['displayIntensity'] as String? ?? '';
        todayType.value = todaySession['sportType'] as String? ?? '';
        
        // Populate the exact display fields
        todayDisplayDuration.value = todaySession['displayDuration'] as String? ?? '${todaySession['durationMinutes'] ?? 0} min';
        todayHeartRateZoneLabel.value = todaySession['heartRateZoneLabel'] as String? ?? todaySession['zoneLabel'] as String? ?? '';
        todayTimeRange.value = todaySession['timeRange'] as String? ?? '$todayStartTime → $todayEndTime';
        todayDisplayIntensity.value = todaySession['displayIntensity'] as String? ?? '';
        todayDisplayType.value = todaySession['displayType'] as String? ?? '';
      } else {
        hasTodaySession.value = false;
        todaySport.value = 'Rest day';
      }

      if (sportTab['recoveryScore'] != null) {
        recoveryScore.value = (sportTab['recoveryScore'] as num).toInt();
        _updateRecoveryText();
      } else if (sportTab['recoveryLoadScore'] != null) {
        recoveryScore.value = (sportTab['recoveryLoadScore'] as num).toInt();
        _updateRecoveryText();
      }

      saveSportsData(syncWithServer: false);
    } catch (e) {
      debugPrint('SportsController: Error updating from live scores tab: $e');
    }
  }

  /// Called with cards.sport from the live scores payload.
  /// Provides recoveryScore/recoveryLoadScore and readinessNote.
  void updateFromSportCard(Map<String, dynamic> sportCard) {
    try {
      if (sportCard['recoveryScore'] != null) {
        recoveryScore.value = (sportCard['recoveryScore'] as num).toInt();
        _updateRecoveryText();
      } else if (sportCard['recoveryLoadScore'] != null) {
        recoveryScore.value = (sportCard['recoveryLoadScore'] as num).toInt();
        _updateRecoveryText();
      }
      final note = sportCard['readinessNote'] as String?;
      if (note != null && note.isNotEmpty) {
        readinessNote.value = note;
      }
      saveSportsData(syncWithServer: false);
    } catch (e) {
      debugPrint('SportsController: Error updating from sport card: $e');
    }
  }
}
