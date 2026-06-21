import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/service/dashboard_service.dart';

class HydrationLog {
  final String id;
  final String time;
  final String type; // 'Cup', 'Glass', 'Bottle', 'Large', etc.
  final int amountMl;

  HydrationLog({
    required this.id,
    required this.time,
    required this.type,
    required this.amountMl,
  });
}

class WeeklyHydration {
  final String label; // 'M', 'T', 'W', etc.
  final double intakeL;
  final double goalL;
  final bool isToday;

  WeeklyHydration({
    required this.label,
    required this.intakeL,
    required this.goalL,
    required this.isToday,
  });

  bool get isGoalMet => intakeL >= goalL;
}

class QuickOption {
  final int amountMl;
  final String label;
  final String typeName;

  const QuickOption({
    required this.amountMl,
    required this.label,
    required this.typeName,
  });
}

class HydrationController extends GetxController {
  final RxDouble dailyGoal = 2.5.obs;
  final RxnInt todayDeficitMl = RxnInt();
  final RxnString hydrationPreviewBody = RxnString();

  // Index of the currently selected day (0 for Monday, 6 for Sunday)
  final RxInt selectedDayIndex = (DateTime.now().weekday - 1).obs;

  // Index of the actual today day (0 for Monday, 6 for Sunday)
  final RxInt todayIndex = (DateTime.now().weekday - 1).obs;

  final RxList<int> weeklyDayTotalsMl = List<int>.filled(7, 0).obs;
  final RxnDouble apiWeeklyAverageL = RxnDouble();

  // 7 lists of logs representing Monday through Sunday — all start empty
  final RxList<RxList<HydrationLog>> weeklyLogs = <RxList<HydrationLog>>[
    <HydrationLog>[].obs, // Monday
    <HydrationLog>[].obs, // Tuesday
    <HydrationLog>[].obs, // Wednesday
    <HydrationLog>[].obs, // Thursday
    <HydrationLog>[].obs, // Friday
    <HydrationLog>[].obs, // Saturday
    <HydrationLog>[].obs, // Sunday / Today
  ].obs;

  // Available quick add options
  final List<QuickOption> quickOptions = const [
    QuickOption(amountMl: 200, label: 'Cup ml', typeName: 'Cup'),
    QuickOption(amountMl: 330, label: 'Glass ml', typeName: 'Glass'),
    QuickOption(amountMl: 500, label: 'Bottle ml', typeName: 'Bottle'),
    QuickOption(amountMl: 750, label: 'Large ml', typeName: 'Large'),
  ];

  @override
  void onInit() {
    super.onInit();
    selectToday();
    loadLogs();
    if (Get.isRegistered<DashboardController>()) {
      final preview = Get.find<DashboardController>().forYouPreviewData.value;
      if (preview != null) updateFromForYouPreview(preview);
    }
  }

  void selectToday() {
    final currentTodayIndex = DateTime.now().weekday - 1;
    todayIndex.value = currentTodayIndex;
    selectedDayIndex.value = currentTodayIndex;
  }

  Future<void> loadLogs() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getHydrationLogs();
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as List;
        for (int i = 0; i < 7 && i < decoded.length; i++) {
          final dayList = decoded[i] as List;
          weeklyLogs[i].assignAll(
            dayList
                .map(
                  (item) => HydrationLog(
                    id: item['id'],
                    time: item['time'],
                    type: item['type'],
                    amountMl: item['amountMl'],
                  ),
                )
                .toList(),
          );
        }
      } else {
        // No saved data — save empty state so future loads start clean
        await saveLogsToPrefs();
      }
    } catch (e) {
      debugPrint('Error loading hydration logs: $e');
    }
  }

  Future<void> saveLogsToPrefs({bool syncWithServer = true}) async {
    try {
      final listToSave = weeklyLogs.map((dayList) {
        return dayList
            .map(
              (log) => {
                'id': log.id,
                'time': log.time,
                'type': log.type,
                'amountMl': log.amountMl,
              },
            )
            .toList();
      }).toList();
      await SharedPreferencesHelper.saveHydrationLogs(jsonEncode(listToSave));

      if (syncWithServer) {
        try {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.fetchDashboardData();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error saving hydration logs: $e');
    }
  }

  // Getters for selected day
  RxList<HydrationLog> get selectedDayLogs =>
      weeklyLogs[selectedDayIndex.value];

  List<HydrationLog> get selectedDayDisplayLogs {
    if (isSelectedDayToday) {
      return selectedDayLogs;
    }

    final totalMl = weeklyDayTotalsMl[selectedDayIndex.value];
    if (totalMl <= 0) {
      return const [];
    }

    return [
      HydrationLog(
        id: 'weekly_total_${selectedDayIndex.value}_$totalMl',
        time: '--:--',
        type: 'Total',
        amountMl: totalMl,
      ),
    ];
  }

  double get selectedDayIntake {
    if (!isSelectedDayToday) {
      return weeklyDayTotalsMl[selectedDayIndex.value] / 1000.0;
    }

    return selectedDayLogs.fold(0, (sum, log) => sum + log.amountMl) / 1000.0;
  }

  int get selectedDayLeftIntakeMl {
    if (selectedDayIndex.value == todayIndex.value &&
        todayDeficitMl.value != null) {
      return todayDeficitMl.value!;
    }

    final left = ((dailyGoal.value * 1000) - (selectedDayIntake * 1000))
        .round();
    return left > 0 ? left : 0;
  }

  bool get isSelectedDayToday => selectedDayIndex.value == todayIndex.value;

  // Dynamic weekly average
  double get weeklyAverage {
    if (apiWeeklyAverageL.value != null) {
      return apiWeeklyAverageL.value!;
    }

    double total = 0.0;
    for (int i = 0; i < 7; i++) {
      if (i == todayIndex.value && weeklyDayTotalsMl[i] == 0) {
        total +=
            weeklyLogs[i].fold(0, (sum, log) => sum + log.amountMl) / 1000.0;
      } else {
        total += weeklyDayTotalsMl[i] / 1000.0;
      }
    }
    return total / 7.0;
  }

  // Compute the weekly summary array dynamically
  final List<String> weekLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  List<WeeklyHydration> get computedWeeklySummary {
    return List.generate(7, (index) {
      final intake = index == todayIndex.value && weeklyDayTotalsMl[index] == 0
          ? weeklyLogs[index].fold(0, (sum, log) => sum + log.amountMl) / 1000.0
          : weeklyDayTotalsMl[index] / 1000.0;
      return WeeklyHydration(
        label: weekLabels[index],
        intakeL: intake,
        goalL: dailyGoal.value,
        isToday: index == todayIndex.value,
      );
    });
  }

  // Set the selected day index
  void selectDay(int index) {
    if (index >= 0 && index < 7) {
      selectedDayIndex.value = index;
    }
  }

  // Log water intake for the selected day
  void addIntake(int amountMl, String type) async {
    if (!isSelectedDayToday) {
      EasyLoading.showToast('You can log hydration only for today.');
      return;
    }

    EasyLoading.show(status: 'Logging water...');
    try {
      final now = DateTime.now();
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        if (sessionId.isNotEmpty) {
          await DashboardService().patchQuickAddLog(
            sessionId: sessionId,
            newWaterLogs: [
              {'timestamp': timeStr, 'volumeMl': amountMl},
            ],
          );
        }
      } catch (e) {
        debugPrint('Hydration API quickAdd error: $e');
      }

      final newLog = HydrationLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: timeStr,
        type: type,
        amountMl: amountMl,
      );

      weeklyLogs[todayIndex.value].insert(0, newLog);
      weeklyDayTotalsMl[todayIndex.value] = weeklyLogs[todayIndex.value].fold(
        0,
        (sum, log) => sum + log.amountMl,
      );
      weeklyDayTotalsMl.refresh();
      weeklyLogs.refresh(); // Triggers reactive update in Obx
      await saveLogsToPrefs();
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Remove water intake from the selected day
  void deleteLog(String id) async {
    if (!isSelectedDayToday) {
      EasyLoading.showToast('You can edit hydration only for today.');
      return;
    }

    weeklyLogs[selectedDayIndex.value].removeWhere((log) => log.id == id);
    weeklyDayTotalsMl[todayIndex.value] = weeklyLogs[todayIndex.value].fold(
      0,
      (sum, log) => sum + log.amountMl,
    );
    weeklyDayTotalsMl.refresh();
    weeklyLogs.refresh(); // Triggers reactive update in Obx
    await saveLogsToPrefs();
  }

  void updateFromLiveScoresTab(Map<String, dynamic> hydrationTab) {
    try {
      var activeDayIndex = DateTime.now().weekday - 1;
      if (hydrationTab['weekly'] != null &&
          hydrationTab['weekly']['days'] is List) {
        final daysList = hydrationTab['weekly']['days'] as List;
        for (int i = 0; i < 7 && i < daysList.length; i++) {
          final dayData = daysList[i] as Map<String, dynamic>;
          if (dayData['isToday'] == true) {
            activeDayIndex = i;
            break;
          }
        }
      }
      todayIndex.value = activeDayIndex;

      if (hydrationTab['logs'] is List) {
        final logsList = hydrationTab['logs'] as List;
        final mappedLogs = logsList.map((item) {
          final timeStr = item['timestamp'] as String? ?? '00:00';
          final volume = (item['volumeMl'] as num?)?.toInt() ?? 0;
          final typeStr = item['label'] as String? ?? 'Glass';
          return HydrationLog(
            id: '${timeStr}_$volume',
            time: timeStr,
            type: typeStr,
            amountMl: volume,
          );
        }).toList();

        // Update active day's logs
        weeklyLogs[activeDayIndex].assignAll(mappedLogs);
      }

      // Update weekly logs for other days from the weekly.days totals
      if (hydrationTab['weekly'] != null &&
          hydrationTab['weekly']['days'] is List) {
        final avgL = hydrationTab['weekly']['avgL'] as num?;
        if (avgL != null) {
          apiWeeklyAverageL.value = avgL.toDouble();
        }

        final daysList = hydrationTab['weekly']['days'] as List;
        for (int i = 0; i < 7 && i < daysList.length; i++) {
          final dayData = daysList[i] as Map<String, dynamic>;
          final totalMl = (dayData['totalMl'] as num?)?.toInt() ?? 0;
          weeklyDayTotalsMl[i] = totalMl;

          if (i != todayIndex.value) {
            weeklyLogs[i].clear();
          }
        }
      }

      weeklyDayTotalsMl.refresh();
      weeklyLogs.refresh();
      saveLogsToPrefs(syncWithServer: false);
    } catch (e) {
      debugPrint(
        'HydrationController: Error updating from live scores tab: $e',
      );
    }
  }

  void updateFromForYouPreview(List<dynamic> forYouPreview) {
    try {
      final hydrationEntry =
          forYouPreview.firstWhereOrNull(
                (item) =>
                    (item as Map<String, dynamic>)['category'] == 'hydration',
              )
              as Map<String, dynamic>?;

      if (hydrationEntry == null) return;

      hydrationPreviewBody.value = hydrationEntry['body'] as String?;
      final bodyParams = hydrationEntry['bodyParams'] as Map<String, dynamic>?;
      final goalL = (bodyParams?['goalL'] as num?)?.toDouble();
      final deficitMl = (bodyParams?['deficitMl'] as num?)?.toInt();

      if (goalL != null && goalL > 0) {
        dailyGoal.value = goalL;
      }
      if (deficitMl != null) {
        todayDeficitMl.value = deficitMl > 0 ? deficitMl : 0;
      }
    } catch (e) {
      debugPrint('HydrationController forYouPreview parse error: $e');
    }
  }
}
