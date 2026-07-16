import 'dart:async';
import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/auth/session/session.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/model/dashboard_model.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';

class DashboardController extends GetxController {
  final _dashboardService = DashboardService();
  final _profileService = ProfileService();

  final Rxn<Map<String, dynamic>> sleepTabData = Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> nutritionTabData =
      Rxn<Map<String, dynamic>>();

  final Rxn<List<dynamic>> forYouPreviewData = Rxn<List<dynamic>>();

  /// Cached cards.sport data for late-registering SportsController.
  final Rxn<Map<String, dynamic>> sportCardData = Rxn<Map<String, dynamic>>();
  
  /// Cached cards.caffeine data for late-registering CaffeineController.
  final Rxn<Map<String, dynamic>> caffeineCardData = Rxn<Map<String, dynamic>>();

  final Rx<DashboardModel> dashboardData = DashboardModel(
    date: DateTime.now(),
    userName: 'User',
    optimalBedtime: '--:--',
    timeUntilBedtime: '--:--',
    rhythmScore: 0,
    waterLiters: 0.0,
    caffeineMg: 0,
    mealsLogged: 0,
    mealsTarget: 0,
    sportMinutes: 0,
    waterDisplay: '--L',
    caffeineDisplay: '--mg',
    mealsDisplay: '--/--',
    sportDisplay: '--',
    sleepProgress: 0.0,
    hydrationProgress: 0.0,
    caffeineProgress: 0.0,
    recoveryProgress: 0.0,
    workShift: 'Off Today'.tr,
    workShiftCountdown: 'No shifts scheduled'.tr,
    workProgress: 0.0,
    lastSleepDuration: '—',
    sleepDebtText: '',
    lastSleepWeekBars: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    isSleepLogged: false,
    isSleepPrep: false,
    hoursUntilBed: 0.0,
  ).obs;

  Timer? _updateTimer;
  bool _isEndingDay = false;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => updateSleepPrepStatus(),
    );
  }

  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }

  Map<String, dynamic> normalizeDashboardPayload(Map<String, dynamic> payload) {
    Map<String, dynamic> data = payload;
    if (payload.containsKey('data') &&
        payload['data'] is Map<String, dynamic>) {
      data = payload['data'] as Map<String, dynamic>;
    }

    final Map<String, dynamic> flat = {};

    // 1. Copy everything from the root level of data
    data.forEach((key, value) {
      if (key != 'liveScores' && key != 'calculation' && key != 'data') {
        flat[key] = value;
      }
    });

    // 2. If there's a nested liveScores, merge its contents
    if (data.containsKey('liveScores') &&
        data['liveScores'] is Map<String, dynamic>) {
      final liveScores = data['liveScores'] as Map<String, dynamic>;
      liveScores.forEach((key, value) {
        flat[key] = value;
      });
    }

    // 3. If there's a nested calculation, merge its contents
    if (data.containsKey('calculation') &&
        data['calculation'] is Map<String, dynamic>) {
      final calculation = data['calculation'] as Map<String, dynamic>;
      calculation.forEach((key, value) {
        flat[key] = value;
      });
    }

    // 4. Copy from payload root if wrapped
    if (payload != data) {
      payload.forEach((key, value) {
        if (key != 'data' && !flat.containsKey(key)) {
          flat[key] = value;
        }
      });
    }

    return flat;
  }

  void _updateDashboardModelFromPayload(
    Map<String, dynamic> rawData, {
    String? userName,
  }) {
    final apiData = normalizeDashboardPayload(rawData);
    final current = dashboardData.value;
    final nameToUse = userName ?? current.userName;

    final rhythmScore = apiData['globalRhythmScore'] as int? ?? 0;

    String optimalBedtime = '--:--';
    double hoursUntilBed = 0.0;
    if (apiData['optimalBedtime'] != null) {
      if (apiData['optimalBedtime'] is Map) {
        final timeVal = apiData['optimalBedtime']['time'] as String? ?? '';
        final sleepAsap = apiData['optimalBedtime']['sleepAsap'] as bool? ?? false;
        hoursUntilBed = (apiData['optimalBedtime']['hoursUntilBed'] as num?)?.toDouble() ?? 0.0;
        if (timeVal.isEmpty && sleepAsap) {
          optimalBedtime = 'ASAP';
        } else {
          optimalBedtime = timeVal.isNotEmpty ? timeVal : '--:--';
        }
      } else if (apiData['optimalBedtime'] is String) {
        optimalBedtime = apiData['optimalBedtime'] as String;
      }
    }

    // Parse cards
    final cards = apiData['cards'] as Map<String, dynamic>?;
    final sleepCard =
        cards?['sleep'] as Map<String, dynamic>? ??
        apiData['lastSleepInfo'] as Map<String, dynamic>?;

    // Sleep details
    final isSleepLogged = sleepCard != null;
    final lastSleepDuration =
        sleepCard?['subtitle'] as String? ??
        sleepCard?['lastSleepDuration'] as String? ??
        sleepCard?['display'] as String? ??
        '—';
    final sleepDebtMin = (sleepCard?['sleepDebtMin'] as num?)?.toInt();
    final sleepDebtText = sleepDebtMin != null
        ? _formatSleepDebtText(sleepDebtMin)
        : sleepCard?['sleepDebtText'] as String? ?? '--';

    List<double> lastSleepWeekBars = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    if (sleepCard != null && sleepCard['weeklyTrend'] is List) {
      final list = sleepCard['weeklyTrend'] as List;
      lastSleepWeekBars = list
          .map<double>((v) => (v as num).toDouble())
          .toList();
    }

    double sleepProgress = 0.0;
    if (cards?['sleep']?['score'] != null) {
      sleepProgress = ((cards!['sleep']!['score'] as num).toDouble() / 100.0)
          .clamp(0.0, 1.0);
    } else if (isSleepLogged) {
      try {
        final regex = RegExp(r'(\d+)h\s*(\d+)m');
        final match = regex.firstMatch(lastSleepDuration);
        if (match != null) {
          final h = int.parse(match.group(1)!);
          final m = int.parse(match.group(2)!);
          final totalMinutes = h * 60 + m;
          sleepProgress = (totalMinutes / 480.0).clamp(0.0, 1.0);
        }
      } catch (_) {}
    }

    // Work details
    final workInfo = apiData['workInfo'] as Map<String, dynamic>?;
    final workFitCard = cards?['workFit'] as Map<String, dynamic>?;

    String workShift = 'Off Today'.tr;
    String workShiftCountdown = 'No shifts scheduled'.tr;
    double workProgress = 0.0;

    if (workInfo != null && workInfo['shiftType'] != 'off') {
      final shiftType = workInfo['shiftType'] as String? ?? 'Work';
      final capShiftType = shiftType.isNotEmpty
          ? shiftType[0].toUpperCase() + shiftType.substring(1)
          : 'Work';
      final start = workInfo['shiftStart'] as String? ?? '';
      final end = workInfo['shiftEnd'] as String? ?? '';

      workShift = '$capShiftType shift';
      if (start.isNotEmpty && end.isNotEmpty) {
        workShiftCountdown = '$start — $end';
      } else {
        workShiftCountdown =
            workFitCard?['subtitle'] as String? ?? 'Active shift';
      }

      // Calculate progress dynamically based on time window
      try {
        if (start.isNotEmpty && end.isNotEmpty) {
          final now = DateTime.now();
          final startParts = start.split(':');
          final endParts = end.split(':');
          if (startParts.length == 2 && endParts.length == 2) {
            final startHour = int.parse(startParts[0]);
            final startMin = int.parse(startParts[1]);
            final endHour = int.parse(endParts[0]);
            final endMin = int.parse(endParts[1]);

            final startTime = DateTime(
              now.year,
              now.month,
              now.day,
              startHour,
              startMin,
            );
            var endTime = DateTime(
              now.year,
              now.month,
              now.day,
              endHour,
              endMin,
            );
            if (endTime.isBefore(startTime)) {
              endTime = endTime.add(const Duration(days: 1));
            }

            if (now.isAfter(startTime) && now.isBefore(endTime)) {
              final totalMinutes = endTime.difference(startTime).inMinutes;
              final elapsedMinutes = now.difference(startTime).inMinutes;
              workProgress = (elapsedMinutes / totalMinutes).clamp(0.0, 1.0);
            } else if (now.isAfter(endTime)) {
              workProgress = 1.0;
            } else {
              workProgress = 0.0;
            }
          }
        }
      } catch (_) {}
    } else {
      workShift = workFitCard?['subtitle'] as String? ?? 'Off Today'.tr;
      workShiftCountdown = 'No shifts scheduled'.tr;
      workProgress = 0.0;
    }

    double hydrationProgress = 0.0;
    if (cards?['hydration']?['score'] != null) {
      hydrationProgress =
          ((cards!['hydration']!['score'] as num).toDouble() / 100.0).clamp(
            0.0,
            1.0,
          );
    }

    double caffeineProgress = 0.0;
    if (cards?['caffeine']?['score'] != null) {
      caffeineProgress =
          ((cards!['caffeine']!['score'] as num).toDouble() / 100.0).clamp(
            0.0,
            1.0,
          );
    }

    double recoveryProgress = 0.0;
    if (cards?['sport']?['recoveryLoadScore'] != null) {
      recoveryProgress =
          ((cards!['sport']!['recoveryLoadScore'] as num).toDouble() / 100.0)
              .clamp(0.0, 1.0);
    } else if (cards?['recovery']?['recoveryLoadScore'] != null) {
      recoveryProgress =
          ((cards!['recovery']!['recoveryLoadScore'] as num).toDouble() / 100.0)
              .clamp(0.0, 1.0);
    } else if (cards?['sport']?['score'] != null) {
      recoveryProgress = ((cards!['sport']!['score'] as num).toDouble() / 100.0)
          .clamp(0.0, 1.0);
    } else if (cards?['recovery']?['score'] != null) {
      recoveryProgress =
          ((cards!['recovery']!['score'] as num).toDouble() / 100.0).clamp(
            0.0,
            1.0,
          );
    }

    // Parse quickAddSummary
    final quickAdd = apiData['quickAddSummary'] as Map<String, dynamic>?;
    final derived = apiData['derived'] as Map<String, dynamic>?;

    double waterLiters = 0.0;
    if (quickAdd?['water']?['totalMl'] != null) {
      waterLiters = (quickAdd!['water']!['totalMl'] as num).toDouble() / 1000.0;
    } else if (derived?['hydrationTotalTodayMl'] != null) {
      waterLiters =
          (derived!['hydrationTotalTodayMl'] as num).toDouble() / 1000.0;
    }

    int caffeineMg = 0;
    if (quickAdd?['caffeine']?['totalMg'] != null) {
      caffeineMg = (quickAdd!['caffeine']!['totalMg'] as num).toInt();
    } else if (derived?['activeCaffeineMg'] != null) {
      caffeineMg = (derived!['activeCaffeineMg'] as num).round();
    }

    int mealsLogged = 0;
    int mealsTarget = 3;
    if (quickAdd?['meals'] != null) {
      mealsLogged = (quickAdd!['meals']!['count'] as num?)?.toInt() ?? 0;
      mealsTarget = (quickAdd['meals']!['dailyTarget'] as num?)?.toInt() ?? 3;
    } else if (derived?['mealCountToday'] != null) {
      mealsLogged = (derived!['mealCountToday'] as num).toInt();
    }

    int sportMinutes = 0;
    if (quickAdd?['sport']?['totalMinutes'] != null) {
      sportMinutes = (quickAdd!['sport']!['totalMinutes'] as num).toInt();
    } else if (derived?['sportLoadToday'] != null) {
      sportMinutes = (derived!['sportLoadToday'] as num).toInt();
    }

    final waterDisplay =
        quickAdd?['water']?['displayL'] as String? ??
        (cards?['hydration']?['subtitle'] as String?) ??
        '${waterLiters.toStringAsFixed(1)}L';

    final caffeineDisplay =
        quickAdd?['caffeine']?['displayMg'] as String? ??
        (cards?['caffeine']?['subtitle'] as String?) ??
        '${caffeineMg}mg';

    final mealsDisplay =
        quickAdd?['meals']?['display'] as String? ??
        (cards?['nutrition']?['subtitle'] as String?) ??
        '$mealsLogged/$mealsTarget';

    final sportDisplay =
        quickAdd?['sport']?['display'] as String? ??
        (cards?['sport']?['subtitle'] as String?) ??
        (sportMinutes > 0 ? '${sportMinutes}m' : 'Rest');

    dashboardData.value = DashboardModel(
      date: DateTime.now(),
      userName: nameToUse,
      optimalBedtime: optimalBedtime,
      timeUntilBedtime: current.timeUntilBedtime,
      rhythmScore: rhythmScore,
      waterLiters: waterLiters,
      caffeineMg: caffeineMg,
      mealsLogged: mealsLogged,
      mealsTarget: mealsTarget,
      sportMinutes: sportMinutes,
      waterDisplay: waterDisplay,
      caffeineDisplay: caffeineDisplay,
      mealsDisplay: mealsDisplay,
      sportDisplay: sportDisplay,
      sleepProgress: sleepProgress,
      hydrationProgress: hydrationProgress,
      caffeineProgress: caffeineProgress,
      recoveryProgress: recoveryProgress,
      workShift: workShift,
      workShiftCountdown: workShiftCountdown,
      workProgress: workProgress == 0.0
          ? (workInfo != null && workInfo['shiftType'] != 'off' ? 0.35 : 0.0)
          : workProgress,
      lastSleepDuration: lastSleepDuration,
      sleepDebtText: sleepDebtText,
      lastSleepWeekBars: lastSleepWeekBars,
      isSleepLogged: isSleepLogged,
      isSleepPrep: current.isSleepPrep,
      hoursUntilBed: hoursUntilBed,
    );

    if (apiData['tabs']?['sleep'] != null) {
      sleepTabData.value = Map<String, dynamic>.from(apiData['tabs']['sleep']);
      if (Get.isRegistered<SleepController>()) {
        Get.find<SleepController>().updateFromLiveScoresTab(
          sleepTabData.value!,
        );
      }
    }

    // Cache forYouPreview for late-registering controllers
    if (apiData['forYouPreview'] is List) {
      forYouPreviewData.value = apiData['forYouPreview'] as List<dynamic>;
    } else {
      forYouPreviewData.value = null;
    }

    // Forward forYouPreview sleep entry to SleepController
    if (Get.isRegistered<SleepController>()) {
      Get.find<SleepController>().updateFromForYouPreview(
        forYouPreviewData.value ?? [],
      );
    }
    if (apiData['tabs']?['hydration'] != null) {
      if (Get.isRegistered<HydrationController>()) {
        Get.find<HydrationController>().updateFromLiveScoresTab(
          apiData['tabs']['hydration'],
        );
      }
    }
    if (Get.isRegistered<HydrationController>()) {
      Get.find<HydrationController>().updateFromForYouPreview(
        forYouPreviewData.value ?? [],
      );
    }
    if (apiData['tabs']?['caffeine'] != null) {
      if (Get.isRegistered<CaffeineController>()) {
        Get.find<CaffeineController>().updateFromLiveScoresTab(
          apiData['tabs']['caffeine'],
        );
      }
    }

    // Forward forYouPreview caffeine entry to CaffeineController
    if (Get.isRegistered<CaffeineController>()) {
      Get.find<CaffeineController>().updateFromForYouPreview(
        forYouPreviewData.value ?? [],
      );
    }
    if (apiData['tabs']?['nutrition'] != null) {
      nutritionTabData.value = Map<String, dynamic>.from(
        apiData['tabs']['nutrition'],
      );
      if (Get.isRegistered<NutritionController>()) {
        Get.find<NutritionController>().updateFromLiveScoresTab(
          nutritionTabData.value!,
        );
      }
    }
    if (apiData['tabs']?['sport'] != null) {
      if (Get.isRegistered<SportsController>()) {
        Get.find<SportsController>().updateFromLiveScoresTab(
          apiData['tabs']['sport'],
        );
      }
    }

    // Forward cards.sport (recoveryLoadScore + readinessNote) to SportsController
    final sportCard = cards?['sport'] as Map<String, dynamic>?;
    if (sportCard != null) {
      sportCardData.value = sportCard;
      if (Get.isRegistered<SportsController>()) {
        Get.find<SportsController>().updateFromSportCard(sportCard);
      }
    }
    // Forward cards.caffeine (activeMg, cutoffTime, halfLifeLabel, etc) to CaffeineController
    final caffeineCard = cards?['caffeine'] as Map<String, dynamic>?;
    if (caffeineCard != null) {
      caffeineCardData.value = caffeineCard;
      if (Get.isRegistered<CaffeineController>()) {
        Get.find<CaffeineController>().updateFromCaffeineCard(caffeineCard);
      }
    }
    if (apiData['tabs']?['work'] != null) {
      if (Get.isRegistered<WorkController>()) {
        Get.find<WorkController>().updateFromLiveScoresTab(
          Map<String, dynamic>.from(apiData['tabs']['work']),
        );
      }
    }
    // Also forward top-level workInfo so WorkController can init shift data
    if (apiData['workInfo'] != null && Get.isRegistered<WorkController>()) {
      Get.find<WorkController>().updateWorkInfoFromSession(
        Map<String, dynamic>.from(apiData['workInfo'] as Map<String, dynamic>),
      );
    }

    updateSleepPrepStatus();
  }

  final RxBool isLoading = false.obs;
  final RxBool hasLoadedOnce = false.obs;

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      // 1. Fetch User Name from Profile
      String userName = 'User';
      try {
        final profileResp = await _profileService.getProfile(
          accessToken: token,
        );
        userName =
            profileResp.data?.firstName ?? profileResp.data?.fullName ?? 'User';
      } catch (e) {
        debugPrint('Dashboard: profile fetch error: $e');
      }

      // 2. Fetch Session Data (for detailed logs history tabs)
      Map<String, dynamic>? sessionData;
      try {
        final sessionUri = Uri.parse(Urls.createCalculatorSession).replace(
          queryParameters: {
            'locale': Get.locale?.languageCode == 'fr' ? 'fr' : 'en',
          },
        );
        final response = await http.get(
          sessionUri,
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        debugPrint('Session GET status: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          if (decoded['success'] == true && decoded['data'] != null) {
            final dataMap = decoded['data'] as Map<String, dynamic>;
            final sessionId = dataMap['sessionId'] as String?;
            if (sessionId != null && sessionId.isNotEmpty) {
              await SharedPreferencesHelper.saveSessionId(sessionId);
            }
            sessionData = decoded;
          }
        }
      } catch (e) {
        debugPrint('Dashboard: session GET error: $e');
      }

      // 3. Fetch scores from Live Score API or fall back to Dashboard calculations
      Map<String, dynamic>? liveScoresDataMap;
      Map<String, dynamic>? dashboardDataMap;

      final storedSessionId = await SharedPreferencesHelper.getSessionId();
      if (storedSessionId != null && storedSessionId.isNotEmpty) {
        try {
          final locale = Get.locale?.languageCode == 'fr' ? 'fr' : 'en';
          final liveScoresUri = Uri.parse(
            Urls.liveScore(storedSessionId, locale),
          );
          final response = await http.get(
            liveScoresUri,
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          debugPrint('Live Scores GET status: ${response.statusCode}');
          if (response.statusCode == 200 || response.statusCode == 201) {
            liveScoresDataMap =
                jsonDecode(response.body) as Map<String, dynamic>;
          }
        } catch (e) {
          debugPrint('Dashboard: Live Scores fetch error: $e');
        }
      }

      if (liveScoresDataMap == null) {
        try {
          dashboardDataMap = await _dashboardService.getDashboard();
        } catch (e) {
          debugPrint('Dashboard: API fetch error: $e');
        }
      }

      // Merge data: liveScoresDataMap takes precedence, followed by dashboardDataMap, merging logs history from sessionData
      final Map<String, dynamic> mergedData = {};
      if (sessionData != null) {
        mergedData.addAll(normalizeDashboardPayload(sessionData));
      }
      if (dashboardDataMap != null) {
        mergedData.addAll(normalizeDashboardPayload(dashboardDataMap));
      }
      if (liveScoresDataMap != null) {
        mergedData.addAll(normalizeDashboardPayload(liveScoresDataMap));
      }

      if (mergedData.isNotEmpty) {
        _updateDashboardModelFromPayload(mergedData, userName: userName);
        hasLoadedOnce.value = true;
        
        // Distribute the initial payload to all other controllers (Sleep, Hydration, Recommendations, etc)
        // so they don't sit empty waiting for the first socket push.
        RealtimeSocketService().handleLiveScores(mergedData, useLocalCaches: false);
      }
    } catch (e) {
      debugPrint('Dashboard: error in fetchDashboardData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSleepPrepStatus() {
    final current = dashboardData.value;
    if (current.optimalBedtime == 'ASAP' || current.optimalBedtime.toLowerCase().contains('asap')) {
      dashboardData.value = current.copyWith(
        isSleepPrep: true,
        timeUntilBedtime: 'Sleep ASAP',
        minutesToBedtime: 0,
        isMissedBedtime: true,
      );
      return;
    }

    try {
      if (current.hoursUntilBed > 0.0) {
        final bedtimeDateTime = current.date.add(
          Duration(minutes: (current.hoursUntilBed * 60).round()),
        );

        final now = DateTime.now();
        final diff = bedtimeDateTime.difference(now).inMinutes;
        final bool isMissed = diff < 0;

        final bedHour = bedtimeDateTime.hour;
        final bedMin = bedtimeDateTime.minute;
        final targetMinutes = bedHour * 60 + bedMin;

        final currentMinutes = now.hour * 60 + now.minute;

        // Sleep prep starts 2 hours before bedtime, ends at 6:00 AM next morning
        final startPrepMinutes = (targetMinutes - 120 + 1440) % 1440;
        const endPrepMinutes = 6 * 60;

        bool isPrep = false;
        if (startPrepMinutes < endPrepMinutes) {
          isPrep =
              currentMinutes >= startPrepMinutes &&
              currentMinutes < endPrepMinutes;
        } else {
          isPrep =
              currentMinutes >= startPrepMinutes ||
              currentMinutes < endPrepMinutes;
        }

        String timeUntil;
        if (diff > 0) {
          timeUntil = 'in ${diff ~/ 60}h ${diff % 60}m';
        } else if (diff == 0) {
          timeUntil = 'bedtime now';
        } else {
          timeUntil =
              '${-diff ~/ 60 > 0 ? "${-diff ~/ 60}h " : ""}${(-diff) % 60}m past bedtime';
        }

        dashboardData.value = current.copyWith(
          isSleepPrep: isPrep,
          timeUntilBedtime: timeUntil,
          minutesToBedtime: diff,
          isMissedBedtime: isMissed,
        );
        return;
      }

      // Fallback: local time-only calculation
      final parts = current.optimalBedtime.split(':');
      if (parts.length == 2) {
        final bedHour = int.parse(parts[0]);
        final bedMin = int.parse(parts[1]);
        final targetMinutes = bedHour * 60 + bedMin;

        final now = DateTime.now();
        final currentMinutes = now.hour * 60 + now.minute;

        // Sleep prep starts 2 hours before bedtime, ends at 6:00 AM next morning
        final startPrepMinutes = (targetMinutes - 120 + 1440) % 1440;
        const endPrepMinutes = 6 * 60;

        bool isPrep = false;
        if (startPrepMinutes < endPrepMinutes) {
          isPrep =
              currentMinutes >= startPrepMinutes &&
              currentMinutes < endPrepMinutes;
        } else {
          isPrep =
              currentMinutes >= startPrepMinutes ||
              currentMinutes < endPrepMinutes;
        }

        int diff = targetMinutes - currentMinutes;
        if (diff < -120) {
          diff += 1440;
        } else if (diff > 1320) {
          diff -= 1440;
        }

        final bool isMissed = diff < 0;

        String timeUntil;
        if (diff > 0) {
          timeUntil = 'in ${diff ~/ 60}h ${diff % 60}m';
        } else if (diff == 0) {
          timeUntil = 'bedtime now';
        } else {
          timeUntil =
              '${-diff ~/ 60 > 0 ? "${-diff ~/ 60}h " : ""}${(-diff) % 60}m past bedtime';
        }

        dashboardData.value = current.copyWith(
          isSleepPrep: isPrep,
          timeUntilBedtime: timeUntil,
          minutesToBedtime: diff,
          isMissedBedtime: isMissed,
        );
      }
    } catch (_) {}
  }

  void toggleSleepPrep() {
    final current = dashboardData.value;
    dashboardData.value = current.copyWith(isSleepPrep: !current.isSleepPrep);
    EasyLoading.showToast(
      dashboardData.value.isSleepPrep
          ? 'Sleep Prep Mode Enabled'
          : 'Sleep Prep Mode Disabled',
    );
  }

  void logSleep() {
    Get.toNamed(AppRoutes.sleepScreen);
  }

  void addWater() {
    Get.toNamed(AppRoutes.hydrationScreen);
  }

  void addCaffeine() {
    Get.toNamed(AppRoutes.caffeineScreen);
  }

  void addMeal() {
    Get.toNamed(AppRoutes.nutritionScreen);
  }

  void addSport() {
    Get.toNamed(AppRoutes.sportsScreen);
  }

  void endMyDay() async {
    if (_isEndingDay) return;
    _isEndingDay = true;
    EasyLoading.show(status: 'Ending day...');

    // Clear recommendations preview cache and active controllers immediately
    forYouPreviewData.value = null;
    if (Get.isRegistered<RecommendationController>()) {
      Get.find<RecommendationController>().forYouPreview.clear();
    }
    if (Get.isRegistered<SleepController>()) {
      final sleepCtrl = Get.find<SleepController>();
      sleepCtrl.forYouSleepBody.value = null;
      sleepCtrl.forYouSleepBedtime.value = null;
    }
    if (Get.isRegistered<HydrationController>()) {
      Get.find<HydrationController>().hydrationPreviewBody.value = null;
    }
    if (Get.isRegistered<CaffeineController>()) {
      final caffeineCtrl = Get.find<CaffeineController>();
      caffeineCtrl.forYouCaffeineBody.value = null;
      caffeineCtrl.forYouCaffeineCutoff.value = null;
    }

    String? newSessionId;
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
      if (sessionId.isNotEmpty) {
        final accessToken =
            await SharedPreferencesHelper.getAccessToken() ?? '';
        final response = await http.post(
          Uri.parse(Urls.endSession(sessionId)),
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        debugPrint('End Session POST Status: ${response.statusCode}');
        debugPrint('End Session POST Body: ${response.body}');

        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final calculation =
              jsonData['data']?['calculation'] as Map<String, dynamic>?;
          if (calculation != null) {
            // Update scores across the app based on the response
            RealtimeSocketService().handleLiveScores(
              calculation,
              useLocalCaches: false,
            );
          }
          newSessionId = jsonData['data']?['newSession']?['sessionId'] as String?;
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to end session');
        }
      }

      // Remove old session ID to ensure no fallback state
      await SharedPreferencesHelper.removeSessionId();

      // Save new session ID from end session response if available
      if (newSessionId != null && newSessionId.isNotEmpty) {
        await SharedPreferencesHelper.saveSessionId(newSessionId);
        debugPrint('endMyDay: saved new sessionId from response = $newSessionId');
      } else {
        // Fallback: Create a brand-new session
        newSessionId = await SessionService().fetchAndStoreSessionId();
        debugPrint('endMyDay: new sessionId fetched as fallback = $newSessionId');
      }

      // Clear all local caches
      await SharedPreferencesHelper.saveCaffeineLogs('[]');

      final emptyHydration = List.generate(7, (_) => []).toList();
      await SharedPreferencesHelper.saveHydrationLogs(
        jsonEncode(emptyHydration),
      );

      // Nutrition: truly empty — no hardcoded meals
      await SharedPreferencesHelper.saveMeals(
        jsonEncode({'dailyTarget': 3, 'meals': []}),
      );

      // Sports: reset today metrics to neutral
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
        recoveryScore: 0,
      );
      await SharedPreferencesHelper.saveSportsSessions('[]');

      // Also refresh recommendations so ForYouSection reflects the new session
      if (Get.isRegistered<RecommendationController>()) {
        final locale = Get.locale?.languageCode == 'fr' ? 'fr' : 'en';
        Get.find<RecommendationController>().getRecommendations(
          sessionId: newSessionId ?? '',
          locale: locale,
        );
      }

      if (newSessionId != null && newSessionId.isNotEmpty) {
        await RealtimeSocketService().connectSocket();
        await fetchDashboardData();
        if (Get.isRegistered<WorkController>()) {
          await Get.find<WorkController>().fetchWorkSettings();
        }
      }

      EasyLoading.showSuccess('Day ended successfully!');
    } catch (e) {
      debugPrint('Error ending day: $e');
      EasyLoading.showError('Failed to end day.');
    } finally {
      _isEndingDay = false;
    }
  }

  Future<void> updateFromLiveScores(
    Map<String, dynamic> apiData, {
    bool useLocalCaches = true,
  }) async {
    _updateDashboardModelFromPayload(apiData);
  }

  void updateFromDashboardEvent(Map<String, dynamic> data) {
    updateFromLiveScores(data);
  }

  String _formatSleepDebtText(int minutes) {
    final normalizedMinutes = minutes < 0 ? 0 : minutes;
    final hours = normalizedMinutes ~/ 60;
    final mins = normalizedMinutes % 60;
    return 'debt ${hours}h ${mins}m';
  }
}
