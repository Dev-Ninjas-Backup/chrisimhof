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
  final RxDouble dailyGoal = 2.5.obs; // 2.5 L target

  // Index of the currently selected day (0 for Monday, 6 for Sunday/Today)
  final RxInt selectedDayIndex = 6.obs;

  // Index of the actual today day (0 for Monday, 6 for Sunday)
  final RxInt todayIndex = 6.obs;

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
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getHydrationLogs();
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as List;
        for (int i = 0; i < 7 && i < decoded.length; i++) {
          final dayList = decoded[i] as List;
          weeklyLogs[i].assignAll(dayList.map((item) => HydrationLog(
            id: item['id'],
            time: item['time'],
            type: item['type'],
            amountMl: item['amountMl'],
          )).toList());
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
        return dayList.map((log) => {
          'id': log.id,
          'time': log.time,
          'type': log.type,
          'amountMl': log.amountMl,
        }).toList();
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
  RxList<HydrationLog> get selectedDayLogs => weeklyLogs[selectedDayIndex.value];

  double get selectedDayIntake => selectedDayLogs.fold(0, (sum, log) => sum + log.amountMl) / 1000.0;

  int get selectedDayLeftIntakeMl {
    final left = ((dailyGoal.value * 1000) - (selectedDayIntake * 1000)).round();
    return left > 0 ? left : 0;
  }

  // Dynamic weekly average
  double get weeklyAverage {
    double total = 0.0;
    for (int i = 0; i < 7; i++) {
      total += weeklyLogs[i].fold(0, (sum, log) => sum + log.amountMl) / 1000.0;
    }
    return total / 7.0;
  }

  // Compute the weekly summary array dynamically
  final List<String> weekLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  List<WeeklyHydration> get computedWeeklySummary {
    return List.generate(7, (index) {
      final intake = weeklyLogs[index].fold(0, (sum, log) => sum + log.amountMl) / 1000.0;
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
    EasyLoading.show(status: 'Logging water...');
    try {
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      try {
        final sessionId = await SharedPreferencesHelper.getSessionId() ?? '';
        if (sessionId.isNotEmpty) {
          await DashboardService().patchQuickAddLog(
            sessionId: sessionId,
            newWaterLogs: [
              {
                'timestamp': timeStr,
                'volumeMl': amountMl,
              }
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

      weeklyLogs[selectedDayIndex.value].insert(0, newLog);
      weeklyLogs.refresh(); // Triggers reactive update in Obx
      await saveLogsToPrefs();
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Remove water intake from the selected day
  void deleteLog(String id) async {
    weeklyLogs[selectedDayIndex.value].removeWhere((log) => log.id == id);
    weeklyLogs.refresh(); // Triggers reactive update in Obx
    await saveLogsToPrefs();
  }

  void updateFromLiveScoresTab(Map<String, dynamic> hydrationTab) {
    try {
      int activeDayIndex = 6;
      if (hydrationTab['weekly'] != null && hydrationTab['weekly']['days'] is List) {
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

      // Only set selectedDayIndex to the active day if it hasn't been set before or is default
      if (selectedDayIndex.value == 6 && activeDayIndex != 6) {
        selectedDayIndex.value = activeDayIndex;
      }

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
      if (hydrationTab['weekly'] != null && hydrationTab['weekly']['days'] is List) {
        final daysList = hydrationTab['weekly']['days'] as List;
        for (int i = 0; i < 7 && i < daysList.length; i++) {
          final dayData = daysList[i] as Map<String, dynamic>;
          final totalMl = (dayData['totalMl'] as num?)?.toInt() ?? 0;
          
          if (i != activeDayIndex) {
            if (totalMl > 0) {
              weeklyLogs[i].assignAll([
                HydrationLog(
                  id: 'dummy_${i}_$totalMl',
                  time: '12:00',
                  type: 'Intake',
                  amountMl: totalMl,
                )
              ]);
            } else {
              weeklyLogs[i].clear();
            }
          }
        }
      }

      weeklyLogs.refresh();
      saveLogsToPrefs(syncWithServer: false);
    } catch (e) {
      debugPrint('HydrationController: Error updating from live scores tab: $e');
    }
  }
}