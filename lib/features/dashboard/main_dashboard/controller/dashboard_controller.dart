import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/model/dashboard_model.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final _dashboardService = DashboardService();
  final _profileService = ProfileService();

  final Rx<DashboardModel> dashboardData = DashboardModel(
    date: DateTime.now(),
    userName: 'User',
    optimalBedtime: '22:30',
    timeUntilBedtime: 'in 2h 12m',
    rhythmScore: 0,
    waterLiters: 0.0,
    caffeineMg: 0,
    mealsLogged: 0,
    mealsTarget: 3,
    sportMinutes: 0,
    sleepProgress: 0.0,
    hydrationProgress: 0.0,
    caffeineProgress: 0.0,
    recoveryProgress: 0.64,
    workShift: 'Off Today',
    workShiftCountdown: 'No shifts scheduled',
    workProgress: 0.0,
    lastSleepDuration: '—',
    sleepDebtText: 'debt 0h 0m / 7d',
    lastSleepWeekBars: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    isSleepLogged: false,
    isSleepPrep: false,
  ).obs;

  Timer? _updateTimer;

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

  Future<void> fetchDashboardData() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) return;

      // 1. Fetch User Name from Profile
      String userName = 'User';
      try {
        final profileResp = await _profileService.getProfile(accessToken: token);
        userName = profileResp.data?.firstName ?? profileResp.data?.fullName ?? 'User';
      } catch (e) {
        debugPrint('Dashboard: profile fetch error: $e');
      }

      // 2. Fetch Dashboard calculations from API
      Map<String, dynamic>? apiData;
      try {
        apiData = await _dashboardService.getDashboard();
      } catch (e) {
        debugPrint('Dashboard: API fetch error: $e');
      }

      // 3. Read Local logs/caches
      // --- Hydration ---
      double localWaterLiters = 0.0;
      double localHydrationProgress = 0.0;
      try {
        final hydrationJson = await SharedPreferencesHelper.getHydrationLogs();
        if (hydrationJson != null) {
          final decoded = jsonDecode(hydrationJson) as List;
          if (decoded.length > 6) {
            final todayList = decoded[6] as List;
            final totalMl = todayList.fold<int>(0, (sum, log) => sum + ((log['amountMl'] as num?)?.toInt() ?? 0));
            localWaterLiters = totalMl / 1000.0;
            localHydrationProgress = (localWaterLiters / 2.5).clamp(0.0, 1.0);
          }
        }
      } catch (e) {
        debugPrint('Dashboard: error calculating local hydration: $e');
      }

      // --- Caffeine ---
      int localCaffeineMg = 0;
      double localCaffeineProgress = 0.0;
      try {
        final caffeineJson = await SharedPreferencesHelper.getCaffeineLogs();
        if (caffeineJson != null) {
          final decoded = jsonDecode(caffeineJson) as List;
          final now = DateTime.now();
          double activeCaffeine = 0.0;
          int totalTodayIntake = 0;
          for (var entry in decoded) {
            final timestamp = DateTime.parse(entry['timestamp']);
            final amountMg = (entry['amountMg'] as num).toInt();
            if (timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day) {
              totalTodayIntake += amountMg;
              if (now.isAfter(timestamp)) {
                final hoursPassed = now.difference(timestamp).inMinutes / 60.0;
                activeCaffeine += amountMg * math.pow(0.5, hoursPassed / 5.0);
              } else {
                activeCaffeine += amountMg;
              }
            }
          }
          localCaffeineMg = activeCaffeine.round();
          localCaffeineProgress = (totalTodayIntake / 400.0).clamp(0.0, 1.0);
        }
      } catch (e) {
        debugPrint('Dashboard: error calculating local caffeine: $e');
      }

      // --- Nutrition ---
      int localMealsLogged = 0;
      int localMealsTarget = 3;
      try {
        final nutritionJson = await SharedPreferencesHelper.getMeals();
        if (nutritionJson != null) {
          final data = jsonDecode(nutritionJson) as Map<String, dynamic>;
          localMealsTarget = data['dailyTarget'] ?? 3;
          final meals = data['meals'] as List? ?? [];
          localMealsLogged = meals.where((m) => m['isLogged'] == true).length;
        }
      } catch (e) {
        debugPrint('Dashboard: error calculating local meals: $e');
      }

      // --- Sports ---
      int localSportMinutes = 0;
      double localRecoveryProgress = 0.64;
      try {
        final sportsMetrics = await SharedPreferencesHelper.getSportsTodayMetrics();
        if (sportsMetrics['hasTodaySession'] == true) {
          localSportMinutes = sportsMetrics['duration'] ?? 0;
        }
        localRecoveryProgress = ((sportsMetrics['recoveryScore'] ?? 64) / 100.0).clamp(0.0, 1.0);
      } catch (e) {
        debugPrint('Dashboard: error calculating local sports: $e');
      }

      // 4. Map values
      final current = dashboardData.value;

      final rhythmScore = apiData?['globalRhythmScore'] as int? ?? 0;
      
      String optimalBedtime = '22:30';
      if (apiData?['optimalBedtime'] != null) {
        if (apiData!['optimalBedtime'] is Map) {
          optimalBedtime = apiData['optimalBedtime']['time'] as String? ?? '22:30';
        } else if (apiData['optimalBedtime'] is String) {
          optimalBedtime = apiData['optimalBedtime'] as String;
        }
      }

      // Parse cards
      final cards = apiData?['cards'] as Map<String, dynamic>?;
      final sleepCard = cards?['sleep'] as Map<String, dynamic>? ?? apiData?['lastSleepInfo'] as Map<String, dynamic>?;
      final workCard = cards?['work'] as Map<String, dynamic>? ?? cards?['workFit'] as Map<String, dynamic>? ?? apiData?['workInfo'] as Map<String, dynamic>?;

      // Sleep details
      final isSleepLogged = sleepCard != null;
      final lastSleepDuration = sleepCard?['lastSleepDuration'] as String? ?? sleepCard?['subtitle'] as String? ?? sleepCard?['display'] as String? ?? '—';
      final sleepDebtText = sleepCard?['sleepDebtText'] as String? ?? 'debt 0h 0m / 7d';
      
      // Parse weeklyTrend
      List<double> lastSleepWeekBars = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      if (sleepCard != null && sleepCard['weeklyTrend'] is List) {
        final list = sleepCard['weeklyTrend'] as List;
        lastSleepWeekBars = list.map<double>((v) => (v as num).toDouble()).toList();
      }

      // Sleep progress
      double sleepProgress = 0.0;
      if (isSleepLogged) {
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
      final workShift = workCard?['workShift'] as String? ?? workCard?['subtitle'] as String? ?? 'Off Today';
      final workShiftCountdown = workCard?['workShiftCountdown'] as String? ?? 'No shifts scheduled';
      final workProgress = (workCard?['workProgress'] as num?)?.toDouble() ?? 0.0;

      dashboardData.value = DashboardModel(
        date: DateTime.now(),
        userName: userName,
        optimalBedtime: optimalBedtime,
        timeUntilBedtime: current.timeUntilBedtime,
        rhythmScore: rhythmScore,
        waterLiters: localWaterLiters,
        caffeineMg: localCaffeineMg,
        mealsLogged: localMealsLogged,
        mealsTarget: localMealsTarget,
        sportMinutes: localSportMinutes,
        sleepProgress: sleepProgress,
        hydrationProgress: localHydrationProgress,
        caffeineProgress: localCaffeineProgress,
        recoveryProgress: localRecoveryProgress,
        workShift: workShift,
        workShiftCountdown: workShiftCountdown,
        workProgress: workProgress == 0.0 ? 0.35 : workProgress,
        lastSleepDuration: lastSleepDuration,
        sleepDebtText: sleepDebtText,
        lastSleepWeekBars: lastSleepWeekBars,
        isSleepLogged: isSleepLogged,
        isSleepPrep: current.isSleepPrep,
      );

      updateSleepPrepStatus();
    } catch (e) {
      debugPrint('Dashboard: error in fetchDashboardData: $e');
    }
  }

  void updateSleepPrepStatus() {
    final current = dashboardData.value;
    try {
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

        final bool isMissed = diff < 0 && !current.isSleepLogged;

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
    EasyLoading.show(status: 'Ending day...');
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId();
      if (sessionId != null && sessionId.isNotEmpty) {
        await _dashboardService.resetSession(sessionId: sessionId);
      }
      
      // Clear local caches for caffeine, hydration, nutrition, and sports
      await SharedPreferencesHelper.saveCaffeineLogs('[]');
      
      // For hydration: reset today's logs (or reset all to empty lists)
      final emptyHydration = List.generate(7, (_) => []).toList();
      await SharedPreferencesHelper.saveHydrationLogs(jsonEncode(emptyHydration));

      // For nutrition: reset meals to empty or planned defaults
      final emptyMeals = {
        'dailyTarget': 5,
        'meals': [
          {'name': 'Meal 1', 'time': '07:30', 'type': 'Light', 'isLogged': false, 'isPlanned': true},
          {'name': 'Meal 2', 'time': '12:00', 'type': 'Medium', 'isLogged': false, 'isPlanned': true},
          {'name': 'Snack', 'time': '15:30', 'type': 'Light', 'isLogged': false, 'isPlanned': true},
          {'name': 'Pre-shift meal', 'time': '19:00', 'type': 'Medium', 'isLogged': false, 'isPlanned': true},
          {'name': 'Night meal', 'time': '02:00', 'type': 'Light', 'isLogged': false, 'isPlanned': true},
        ]
      };
      await SharedPreferencesHelper.saveMeals(jsonEncode(emptyMeals));

      // For sports: reset today metrics
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

      // Clear cached dashboard calculations by re-fetching
      await fetchDashboardData();
      EasyLoading.showSuccess('Day ended successfully!');
    } catch (e) {
      debugPrint('Error ending day: $e');
      EasyLoading.showError('Failed to end day.');
    }
  }

  Future<void> updateFromLiveScores(Map<String, dynamic> apiData) async {
    try {
      // 1. Read Local logs/caches (hydration, caffeine, nutrition, sports)
      double localWaterLiters = 0.0;
      double localHydrationProgress = 0.0;
      try {
        final hydrationJson = await SharedPreferencesHelper.getHydrationLogs();
        if (hydrationJson != null) {
          final decoded = jsonDecode(hydrationJson) as List;
          if (decoded.length > 6) {
            final todayList = decoded[6] as List;
            final totalMl = todayList.fold<int>(0, (sum, log) => sum + ((log['amountMl'] as num?)?.toInt() ?? 0));
            localWaterLiters = totalMl / 1000.0;
            localHydrationProgress = (localWaterLiters / 2.5).clamp(0.0, 1.0);
          }
        }
      } catch (e) {
        debugPrint('Dashboard socket update: error local hydration: $e');
      }

      int localCaffeineMg = 0;
      double localCaffeineProgress = 0.0;
      try {
        final caffeineJson = await SharedPreferencesHelper.getCaffeineLogs();
        if (caffeineJson != null) {
          final decoded = jsonDecode(caffeineJson) as List;
          final now = DateTime.now();
          double activeCaffeine = 0.0;
          int totalTodayIntake = 0;
          for (var entry in decoded) {
            final timestamp = DateTime.parse(entry['timestamp']);
            final amountMg = (entry['amountMg'] as num).toInt();
            if (timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day) {
              totalTodayIntake += amountMg;
              if (now.isAfter(timestamp)) {
                final hoursPassed = now.difference(timestamp).inMinutes / 60.0;
                activeCaffeine += amountMg * math.pow(0.5, hoursPassed / 5.0);
              } else {
                activeCaffeine += amountMg;
              }
            }
          }
          localCaffeineMg = activeCaffeine.round();
          localCaffeineProgress = (totalTodayIntake / 400.0).clamp(0.0, 1.0);
        }
      } catch (e) {
        debugPrint('Dashboard socket update: error local caffeine: $e');
      }

      int localMealsLogged = 0;
      int localMealsTarget = 3;
      try {
        final nutritionJson = await SharedPreferencesHelper.getMeals();
        if (nutritionJson != null) {
          final data = jsonDecode(nutritionJson) as Map<String, dynamic>;
          localMealsTarget = data['dailyTarget'] ?? 3;
          final meals = data['meals'] as List? ?? [];
          localMealsLogged = meals.where((m) => m['isLogged'] == true).length;
        }
      } catch (e) {
        debugPrint('Dashboard socket update: error local meals: $e');
      }

      int localSportMinutes = 0;
      double localRecoveryProgress = 0.64;
      try {
        final sportsMetrics = await SharedPreferencesHelper.getSportsTodayMetrics();
        if (sportsMetrics['hasTodaySession'] == true) {
          localSportMinutes = sportsMetrics['duration'] ?? 0;
        }
        localRecoveryProgress = ((sportsMetrics['recoveryScore'] ?? 64) / 100.0).clamp(0.0, 1.0);
      } catch (e) {
        debugPrint('Dashboard socket update: error local sports: $e');
      }

      // 2. Map server values
      final current = dashboardData.value;
      final rhythmScore = apiData['globalRhythmScore'] as int? ?? 0;
      
      String optimalBedtime = '22:30';
      if (apiData['optimalBedtime'] != null) {
        if (apiData['optimalBedtime'] is Map) {
          optimalBedtime = apiData['optimalBedtime']['time'] as String? ?? '22:30';
        } else if (apiData['optimalBedtime'] is String) {
          optimalBedtime = apiData['optimalBedtime'] as String;
        }
      }

      final cards = apiData['cards'] as Map<String, dynamic>?;
      final sleepCard = cards?['sleep'] as Map<String, dynamic>? ?? apiData['lastSleepInfo'] as Map<String, dynamic>?;
      final workCard = cards?['work'] as Map<String, dynamic>? ?? cards?['workFit'] as Map<String, dynamic>? ?? apiData['workInfo'] as Map<String, dynamic>?;

      final isSleepLogged = sleepCard != null;
      final lastSleepDuration = sleepCard?['lastSleepDuration'] as String? ?? sleepCard?['subtitle'] as String? ?? sleepCard?['display'] as String? ?? '—';
      final sleepDebtText = sleepCard?['sleepDebtText'] as String? ?? 'debt 0h 0m / 7d';

      List<double> lastSleepWeekBars = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      if (sleepCard != null && sleepCard['weeklyTrend'] is List) {
        final list = sleepCard['weeklyTrend'] as List;
        lastSleepWeekBars = list.map<double>((v) => (v as num).toDouble()).toList();
      }

      double sleepProgress = 0.0;
      if (isSleepLogged) {
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

      final workShift = workCard?['workShift'] as String? ?? workCard?['subtitle'] as String? ?? 'Off Today';
      final workShiftCountdown = workCard?['workShiftCountdown'] as String? ?? 'No shifts scheduled';
      final workProgress = (workCard?['workProgress'] as num?)?.toDouble() ?? 0.0;

      dashboardData.value = DashboardModel(
        date: DateTime.now(),
        userName: current.userName,
        optimalBedtime: optimalBedtime,
        timeUntilBedtime: current.timeUntilBedtime,
        rhythmScore: rhythmScore,
        waterLiters: localWaterLiters,
        caffeineMg: localCaffeineMg,
        mealsLogged: localMealsLogged,
        mealsTarget: localMealsTarget,
        sportMinutes: localSportMinutes,
        sleepProgress: sleepProgress,
        hydrationProgress: localHydrationProgress,
        caffeineProgress: localCaffeineProgress,
        recoveryProgress: localRecoveryProgress,
        workShift: workShift,
        workShiftCountdown: workShiftCountdown,
        workProgress: workProgress == 0.0 ? 0.35 : workProgress,
        lastSleepDuration: lastSleepDuration,
        sleepDebtText: sleepDebtText,
        lastSleepWeekBars: lastSleepWeekBars,
        isSleepLogged: isSleepLogged,
        isSleepPrep: current.isSleepPrep,
      );

      updateSleepPrepStatus();
    } catch (e) {
      debugPrint('Dashboard: error in updateFromLiveScores: $e');
    }
  }

  void updateFromDashboardEvent(Map<String, dynamic> data) {
    updateFromLiveScores(data);
  }
}
