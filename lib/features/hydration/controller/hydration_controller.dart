import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';

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

  // 7 lists of logs representing Monday through Sunday
  final RxList<RxList<HydrationLog>> weeklyLogs = <RxList<HydrationLog>>[
    // Monday (2.3 L)
    <HydrationLog>[
      HydrationLog(id: 'm1', time: '17:30', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'm2', time: '13:15', type: 'Large', amountMl: 750),
      HydrationLog(id: 'm3', time: '10:00', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'm4', time: '08:20', type: 'Glass', amountMl: 330),
      HydrationLog(id: 'm5', time: '07:05', type: 'Cup', amountMl: 220),
    ].obs,
    // Tuesday (2.0 L)
    <HydrationLog>[
      HydrationLog(id: 't1', time: '16:00', type: 'Large', amountMl: 750),
      HydrationLog(id: 't2', time: '12:30', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 't3', time: '09:15', type: 'Glass', amountMl: 330),
      HydrationLog(id: 't4', time: '07:45', type: 'Cup', amountMl: 420),
    ].obs,
    // Wednesday (2.5 L)
    <HydrationLog>[
      HydrationLog(id: 'w1', time: '18:10', type: 'Large', amountMl: 750),
      HydrationLog(id: 'w2', time: '14:20', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'w3', time: '11:05', type: 'Large', amountMl: 750),
      HydrationLog(id: 'w4', time: '07:30', type: 'Bottle', amountMl: 500),
    ].obs,
    // Thursday (1.9 L)
    <HydrationLog>[
      HydrationLog(id: 'th1', time: '15:50', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'th2', time: '11:40', type: 'Large', amountMl: 750),
      HydrationLog(id: 'th3', time: '08:15', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'th4', time: '07:00', type: 'Cup', amountMl: 150),
    ].obs,
    // Friday (2.4 L)
    <HydrationLog>[
      HydrationLog(id: 'f1', time: '19:00', type: 'Large', amountMl: 750),
      HydrationLog(id: 'f2', time: '15:30', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 'f3', time: '11:15', type: 'Large', amountMl: 750),
      HydrationLog(id: 'f4', time: '08:45', type: 'Cup', amountMl: 400),
    ].obs,
    // Saturday (2.0 L)
    <HydrationLog>[
      HydrationLog(id: 's1', time: '16:40', type: 'Large', amountMl: 750),
      HydrationLog(id: 's2', time: '12:20', type: 'Bottle', amountMl: 500),
      HydrationLog(id: 's3', time: '09:05', type: 'Glass', amountMl: 330),
      HydrationLog(id: 's4', time: '07:10', type: 'Bottle', amountMl: 420),
    ].obs,
    // Sunday / Today (1.6 L initial)
    <HydrationLog>[
      HydrationLog(id: '1', time: '15:42', type: 'Bottle', amountMl: 500),
      HydrationLog(id: '2', time: '12:10', type: 'Glass', amountMl: 330),
      HydrationLog(id: '3', time: '09:30', type: 'Cup', amountMl: 200),
      HydrationLog(id: '4', time: '07:15', type: 'Bottle', amountMl: 570),
    ].obs,
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
        await saveLogsToPrefs();
      }
    } catch (e) {
      debugPrint('Error loading hydration logs: $e');
    }
  }

  Future<void> saveLogsToPrefs() async {
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
      
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.fetchDashboardData();
      } catch (_) {}
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
        isToday: index == 6,
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
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    final newLog = HydrationLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      time: timeStr,
      type: type,
      amountMl: amountMl,
    );

    weeklyLogs[selectedDayIndex.value].insert(0, newLog);
    weeklyLogs.refresh(); // Triggers reactive update in Obx
    await saveLogsToPrefs();
  }

  // Remove water intake from the selected day
  void deleteLog(String id) async {
    weeklyLogs[selectedDayIndex.value].removeWhere((log) => log.id == id);
    weeklyLogs.refresh(); // Triggers reactive update in Obx
    await saveLogsToPrefs();
  }
}