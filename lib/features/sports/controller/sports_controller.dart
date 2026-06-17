import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
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
  // Today's Session metrics
  final RxBool hasTodaySession = true.obs;
  final RxInt todayDuration = 45.obs;
  final RxString todayZone = 'Z3'.obs;
  final RxString todaySport = 'Running'.obs;
  final RxString todayDistance = '6.8 km'.obs;
  final RxString todayStartTime = '12:40'.obs;
  final RxString todayEndTime = '13:25'.obs;
  final RxString todayEffort = 'Medium'.obs;
  final RxString todayType = 'Cardio'.obs;

  // Recovery Impact metrics
  final RxInt recoveryScore = 64.obs;
  final RxString recoveryText = 'Recovery is moderate — skip intense training tomorrow.'.obs;

  // This Week sessions list
  final RxList<SportSession> sessionsList = <SportSession>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSportsData();
  }

  Future<void> loadSportsData() async {
    try {
      final todayMetrics = await SharedPreferencesHelper.getSportsTodayMetrics();
      hasTodaySession.value = todayMetrics['hasTodaySession'] ?? true;
      todayDuration.value = todayMetrics['duration'] ?? 45;
      todayZone.value = todayMetrics['zone'] ?? 'Z3';
      todaySport.value = todayMetrics['sport'] ?? 'Running';
      todayDistance.value = todayMetrics['distance'] ?? '6.8 km';
      todayStartTime.value = todayMetrics['startTime'] ?? '12:40';
      todayEndTime.value = todayMetrics['endTime'] ?? '13:25';
      todayEffort.value = todayMetrics['effort'] ?? 'Medium';
      todayType.value = todayMetrics['type'] ?? 'Cardio';
      recoveryScore.value = todayMetrics['recoveryScore'] ?? 64;
      _updateRecoveryText();

      final jsonStr = await SharedPreferencesHelper.getSportsSessions();
      if (jsonStr != null) {
        final List decoded = jsonDecode(jsonStr);
        sessionsList.assignAll(decoded.map((s) => SportSession(
          title: s['title'] ?? '',
          subtitle: s['subtitle'] ?? '',
          iconPath: s['iconPath'] ?? '',
        )).toList());
      } else {
        _initializeMockSessions();
      }
    } catch (e) {
      debugPrint('Error loading sports data: $e');
      _initializeMockSessions();
    }
  }

  Future<void> saveSportsData() async {
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

      final listToSave = sessionsList.map((s) => {
        'title': s.title,
        'subtitle': s.subtitle,
        'iconPath': s.iconPath,
      }).toList();
      await SharedPreferencesHelper.saveSportsSessions(jsonEncode(listToSave));

      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.fetchDashboardData();
      } catch (_) {}
    } catch (e) {
      debugPrint('Error saving sports data: $e');
    }
  }

  void _initializeMockSessions() async {
    sessionsList.assignAll([
      SportSession(
        title: 'Running',
        subtitle: 'Today · 45m · Z3',
        iconPath: IconPath.running,
      ),
      SportSession(
        title: 'Strength',
        subtitle: 'Yesterday · 60m · Z2',
        iconPath: IconPath.strength,
      ),
      SportSession(
        title: 'Yoga',
        subtitle: 'Sat · 30m · Z1',
        iconPath: IconPath.yoga,
      ),
      SportSession(
        title: 'Rest day',
        subtitle: 'Fri · —',
        iconPath: IconPath.restDay,
      ),
    ]);
    await saveSportsData();
  }

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

    await saveSportsData();
  }

  void _updateRecoveryText() {
    final score = recoveryScore.value;
    if (score >= 80) {
      recoveryText.value = 'Recovery is excellent — ready for high-intensity training.';
    } else if (score >= 50) {
      recoveryText.value = 'Recovery is moderate — skip intense training tomorrow.';
    } else {
      recoveryText.value = 'Recovery is low — prioritize rest and light stretching today.';
    }
  }

  String _getIconPathForActivity(String activity) {
    switch (activity.toLowerCase()) {
      case 'running':
        return IconPath.running;
      case 'strength':
        return IconPath.strength;
      case 'yoga':
        return IconPath.yoga;
      case 'rest day':
      default:
        return IconPath.restDay;
    }
  }
}