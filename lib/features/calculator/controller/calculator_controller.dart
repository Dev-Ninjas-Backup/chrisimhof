import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_preset_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_intake_model.dart';
import 'package:chrisimhof/features/calculator/models/hydration_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sport_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/activity_type_enum.dart';
import 'package:chrisimhof/features/calculator/service/calculator_service.dart';
import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CalculatorController extends GetxController {
  final tabs = ['Sleep', 'Work', 'Nutrition', 'Hydration', 'Caffeine', 'Sport'];

  final selectedTabIndex = 0.obs;

  // Session Management
  final CalculatorService _calculatorService = CalculatorService();
  final Rx<CalculatorSession?> calculatorSession = Rx(null);
  final RxBool isSessionLoading = true.obs;
  final RxString sessionError = ''.obs;

  // Sleep submission
  final RxBool isSleepSubmitting = false.obs;
  final RxString sleepSubmitError = ''.obs;

  // Work submission
  final RxBool isWorkSubmitting = false.obs;
  final RxString workSubmitError = ''.obs;

  // Nutrition submission
  final RxBool isNutritionSubmitting = false.obs;
  final RxString nutritionSubmitError = ''.obs;

  // Hydration submission
  final RxBool isHydrationSubmitting = false.obs;
  final RxString hydrationSubmitError = ''.obs;

  // Sport submission
  final RxBool isSportSubmitting = false.obs;
  final RxString sportSubmitError = ''.obs;

  // Sleep Tab Controllers
  late TimeController wakeUpController;
  late TimeController desiredSleepStartController;
  late TimeController desiredSleepEndController;
  late TimeController preferredTimeController;
  late TextEditingController durationController;
  late RangeSliderController sleepLastNightController;
  late RangeSliderController sleepGoalController;
  final RxString fatigueLevel = 'Low'.tr.obs;

  // Nap management
  final RxList<Map<String, dynamic>> naps = <Map<String, dynamic>>[].obs;
  late TextEditingController currentNapDurationController;
  // whether user wants to take naps
  final RxBool wantsNap = false.obs;

  // Work Tab Controllers
  late TimeController workBeginsController;
  late TimeController workCompleteController;
  late TextEditingController daysWorkedController;
  final RxString selectedShiftType = 'STANDARD'.obs;

  // Hydration Tab Controllers
  late RangeSliderController hydrationConsumedController;
  late RangeSliderController hydrationDailyGoalController;

  // Nutrition Tab Controllers
  late RangeSliderController desiredNumberOfMealsController;
  late TimeController firstMealTimeController;
  late TimeController lastMealTimeController;
  final RxString hasMealTodaySelection = 'No'.obs;

  // Sport Tab Controllers
  late TextEditingController sportDurationController;
  final RxString selectedActivityType = ''.obs;
  // training intent for sport: NO_TRAINING, WILL_TRAIN, ALREADY_TRAINED
  final RxString trainingIntent = 'NO_TRAINING'.obs;
  final RxDouble sportIntensity = 0.0.obs;
  // Sport activities list (from session / latest results)
  final RxList<Map<String, dynamic>> sportActivities =
      <Map<String, dynamic>>[].obs;

  // Caffeine Tab Controllers
  final RxDouble caffeine24hValue = 0.0.obs;
  final RxDouble caffeinMaxValue = 400.0.obs;
  final RxDouble caffeineLastEightHoursValue = 0.0.obs;
  late TimeController caffeineIntakeTimeController;
  late TextEditingController caffeineDrinkNameController;
  late TextEditingController caffeineDrinkTypeController;
  late TextEditingController caffeineAmountController;
  final RxList<Map<String, dynamic>> caffeineHistory =
      <Map<String, dynamic>>[].obs;

  // Caffeine Presets
  final RxList<CaffeinePreset> caffeinePresets = <CaffeinePreset>[].obs;
  final RxBool isCaffeinePresetsLoading = true.obs;
  final RxString caffeinePresetsError = ''.obs;

  // Caffeine Intake Submission
  final RxBool isCaffeineSubmitting = false.obs;
  final RxString caffeineSubmitError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSleepControllers();
    _initializeWorkControllers();
    _initializeNutritionControllers();
    _initializeSportControllers();
    _initializeCaffeineControllers();
    _loadCaffeineHistory();
    _fetchCaffeinePresets();
    _fetchCalculatorSession();
  }

  Future<void> _fetchCalculatorSession() async {
    try {
      isSessionLoading.value = true;
      sessionError.value = '';

      final response = await _calculatorService.getCalculatorSession();

      calculatorSession.value = response.data;

      // Apply any prefilled data from the session (sleep/work/nutrition/hydration/caffeine/sport)
      final applied = _applySessionPrefill(response.data);

      // If any section wasn't present in session, attempt to fetch latest-result once and apply missing parts
      const allSections = {
        'sleep',
        'work',
        'nutrition',
        'hydration',
        'caffeine',
        'sport',
      };

      if (!applied.containsAll(allSections)) {
        try {
          final latest = await _calculatorService.getLatestResultRaw();
          _applyLatestResultPrefill(latest, applied);
        } catch (_) {
          // ignore fallback errors
        }
      }
    } catch (e) {
      sessionError.value = e.toString();
    } finally {
      isSessionLoading.value = false;
    }
  }

  /// Applies session data into controllers and returns a set of sections that were applied.
  Set<String> _applySessionPrefill(CalculatorSession? session) {
    final applied = <String>{};

    if (session == null) return applied;

    final dynamic d = session.data;
    if (d == null || d is! Map) return applied;

    try {
      // Sleep
      final sleep = d['sleep'];
      if (sleep != null && sleep is Map<String, dynamic>) {
        var _sleepApplied = false;
        if (sleep['wakeUpTime'] != null) {
          final parts = (sleep['wakeUpTime'] as String).split(':');
          if (parts.length == 2) {
            wakeUpController.hour.value =
                int.tryParse(parts[0]) ?? wakeUpController.hour.value;
            wakeUpController.minute.value =
                int.tryParse(parts[1]) ?? wakeUpController.minute.value;
            wakeUpController.period.value = wakeUpController.hour.value >= 12
                ? 'PM'
                : 'AM';
          }
        }

        if (sleep['sleepHours'] != null) {
          final val = (sleep['sleepHours'] as num).toDouble();
          sleepLastNightController.updateValue(val);
        }

        if (sleep['desiredSleepHours'] != null) {
          final val = (sleep['desiredSleepHours'] as num).toDouble();
          sleepGoalController.updateValue(val);
        }

        if (sleep['fatigueLevel'] != null) {
          final fl = sleep['fatigueLevel'].toString().toLowerCase();
          if (fl == 'low') {
            fatigueLevel.value = 'Low'.tr;
          } else if (fl == 'average' || fl == 'medium') {
            fatigueLevel.value = 'Average'.tr;
          } else if (fl == 'high') {
            fatigueLevel.value = 'High'.tr;
          } else {
            fatigueLevel.value = sleep['fatigueLevel'].toString();
          }
        }

        if (sleep['desiredSleepStart'] != null) {
          final parts = (sleep['desiredSleepStart'] as String).split(':');
          if (parts.length == 2) {
            desiredSleepStartController.hour.value =
                int.tryParse(parts[0]) ??
                desiredSleepStartController.hour.value;
            desiredSleepStartController.minute.value =
                int.tryParse(parts[1]) ??
                desiredSleepStartController.minute.value;
            desiredSleepStartController.period.value =
                desiredSleepStartController.hour.value >= 12 ? 'PM' : 'AM';
          }
        }

        if (sleep['desiredWakeTime'] != null) {
          final parts = (sleep['desiredWakeTime'] as String).split(':');
          if (parts.length == 2) {
            desiredSleepEndController.hour.value =
                int.tryParse(parts[0]) ?? desiredSleepEndController.hour.value;
            desiredSleepEndController.minute.value =
                int.tryParse(parts[1]) ??
                desiredSleepEndController.minute.value;
            desiredSleepEndController.period.value =
                desiredSleepEndController.hour.value >= 12 ? 'PM' : 'AM';
          }
        }

        if (sleep['naps'] != null && sleep['naps'] is List) {
          final list = <Map<String, dynamic>>[];
          for (final n in (sleep['naps'] as List)) {
            if (n is Map<String, dynamic>) {
              final order = n['order'] ?? (list.length + 1);
              final start = n['startTime'] ?? n['start'] ?? '';
              final duration =
                  n['durationMin'] ?? n['duration'] ?? n['minutes'] ?? 0;
              list.add({
                'napNumber': order,
                'preferredTime': start,
                'duration': duration.toString(),
              });
            }
          }

          if (list.isNotEmpty) {
            wantsNap.value = true;
            naps.assignAll(list);
            _sleepApplied = true;
          }
        }
        // mark sleep applied only if at least one field was set
        if (_sleepApplied ||
            sleep['wakeUpTime'] != null ||
            sleep['sleepHours'] != null ||
            sleep['desiredSleepHours'] != null ||
            sleep['fatigueLevel'] != null ||
            sleep['desiredSleepStart'] != null ||
            sleep['desiredWakeTime'] != null) {
          applied.add('sleep');
        }
      }

      // Work
      final work = d['work'];
      if (work != null && work is Map<String, dynamic>) {
        var appliedWork = false;
        if (work['shiftStart'] != null) {
          final parts = (work['shiftStart'] as String).split(':');
          if (parts.length == 2) {
            workBeginsController.hour.value =
                int.tryParse(parts[0]) ?? workBeginsController.hour.value;
            workBeginsController.minute.value =
                int.tryParse(parts[1]) ?? workBeginsController.minute.value;
            workBeginsController.period.value =
                workBeginsController.hour.value >= 12 ? 'PM' : 'AM';
            appliedWork = true;
          }
        }

        if (work['shiftEnd'] != null) {
          final parts = (work['shiftEnd'] as String).split(':');
          if (parts.length == 2) {
            workCompleteController.hour.value =
                int.tryParse(parts[0]) ?? workCompleteController.hour.value;
            workCompleteController.minute.value =
                int.tryParse(parts[1]) ?? workCompleteController.minute.value;
            workCompleteController.period.value =
                workCompleteController.hour.value >= 12 ? 'PM' : 'AM';
            appliedWork = true;
          }
        }

        if (work['shiftType'] != null) {
          selectedShiftType.value = work['shiftType'].toString();
          appliedWork = true;
        }

        if (work['daysWorked'] != null) {
          daysWorkedController.text = work['daysWorked'].toString();
          appliedWork = true;
        }

        if (appliedWork) applied.add('work');
      }

      // Nutrition
      final nutrition = d['nutrition'];
      if (nutrition != null && nutrition is Map<String, dynamic>) {
        var appliedNutrition = false;
        if (nutrition['firstMealTime'] != null) {
          final parts = (nutrition['firstMealTime'] as String).split(':');
          if (parts.length == 2) {
            firstMealTimeController.hour.value =
                int.tryParse(parts[0]) ?? firstMealTimeController.hour.value;
            firstMealTimeController.minute.value =
                int.tryParse(parts[1]) ?? firstMealTimeController.minute.value;
            firstMealTimeController.period.value =
                firstMealTimeController.hour.value >= 12 ? 'PM' : 'AM';
            appliedNutrition = true;
          }
        }

        if (nutrition['lastMealTime'] != null) {
          final parts = (nutrition['lastMealTime'] as String).split(':');
          if (parts.length == 2) {
            lastMealTimeController.hour.value =
                int.tryParse(parts[0]) ?? lastMealTimeController.hour.value;
            lastMealTimeController.minute.value =
                int.tryParse(parts[1]) ?? lastMealTimeController.minute.value;
            lastMealTimeController.period.value =
                lastMealTimeController.hour.value >= 12 ? 'PM' : 'AM';
            appliedNutrition = true;
          }
        }

        if (nutrition['desiredMealCount'] != null) {
          desiredNumberOfMealsController.updateValue(
            (nutrition['desiredMealCount'] as num).toDouble(),
          );
          appliedNutrition = true;
        }

        if (nutrition['hadMealToday'] != null) {
          hasMealTodaySelection.value = (nutrition['hadMealToday'] as bool)
              ? 'Yes'
              : 'No';
          appliedNutrition = true;
        }

        if (appliedNutrition) applied.add('nutrition');
      }

      // Hydration
      final hydration = d['hydration'];
      if (hydration != null && hydration is Map<String, dynamic>) {
        var appliedHydration = false;
        if (hydration['waterConsumedL'] != null) {
          hydrationConsumedController.updateValue(
            (hydration['waterConsumedL'] as num).toDouble(),
          );
          appliedHydration = true;
        }
        if (hydration['waterGoalL'] != null) {
          hydrationDailyGoalController.updateValue(
            (hydration['waterGoalL'] as num).toDouble(),
          );
          appliedHydration = true;
        }
        if (appliedHydration) applied.add('hydration');
      }

      // Caffeine
      final caffeine = d['caffeine'];
      if (caffeine != null && caffeine is Map<String, dynamic>) {
        var appliedCaffeine = false;
        final List<Map<String, String>> entries = [];
        double total = 0;
        if (caffeine['caffeineIntakes'] != null &&
            caffeine['caffeineIntakes'] is List) {
          for (final item in (caffeine['caffeineIntakes'] as List)) {
            if (item is Map<String, dynamic>) {
              final int amount = (item['amountMg'] is num)
                  ? (item['amountMg'] as num).toInt()
                  : int.tryParse(item['amountMg']?.toString() ?? '') ?? 0;
              final String name =
                  '${item['drinkName'] ?? ''} (${item['drinkType'] ?? ''})';
              final String time = item['consumedAt'] ?? '';
              entries.add({'name': name, 'dose': '${amount}mg', 'time': time});
              total += amount;
            }
          }
        }

        if (entries.isNotEmpty) {
          caffeineHistory.assignAll(
            entries
                .map(
                  (e) => {
                    'name': e['name']!,
                    'dose': e['dose']!,
                    'time': e['time']!,
                  },
                )
                .toList(),
          );
          caffeine24hValue.value = total;
          caffeineLastEightHoursValue.value =
              total; // best-effort: server didn't provide windowed totals
          appliedCaffeine = true;
        }

        if (appliedCaffeine) applied.add('caffeine');
      }

      // Sport
      final sport = d['sport'];
      if (sport != null && sport is Map<String, dynamic>) {
        var appliedSport = false;

        // Support new shape: sport.activities (list)
        if (sport['activities'] != null && sport['activities'] is List) {
          final list = <Map<String, dynamic>>[];
          for (final a in (sport['activities'] as List)) {
            if (a is Map<String, dynamic>) {
              final type = a['activityType'] ?? a['activity'] ?? '';
              final intensity = a['intensity'] ?? '';
              final duration = a['durationMin'] ?? a['duration'] ?? 0;
              final performedAt = a['performedAt'] ?? '';
              list.add({
                'activityType': type.toString(),
                'intensity': intensity.toString(),
                'durationMin': duration,
                'performedAt': performedAt.toString(),
              });
            }
          }

          if (list.isNotEmpty) {
            sportActivities.assignAll(list);
            appliedSport = true;
          }
        }

        // Backwards compatible single-field mapping
        if (sport['activityType'] != null) {
          try {
            selectedActivityType.value = ActivityType.fromApiValue(
              sport['activityType'].toString(),
            ).displayName;
          } catch (_) {
            selectedActivityType.value = sport['activityType'].toString();
          }
          appliedSport = true;
        }

        if (sport['activityDuration'] != null) {
          sportDurationController.text = sport['activityDuration'].toString();
          appliedSport = true;
        }

        if (sport['activityIntensity'] != null) {
          final ai = sport['activityIntensity'].toString().toLowerCase();
          if (ai == 'light') {
            sportIntensity.value = 0.0;
          } else if (ai == 'moderate') {
            sportIntensity.value = 1.0;
          } else if (ai == 'high') {
            sportIntensity.value = 2.0;
          }
          appliedSport = true;
        }
        if (sport['trainingIntent'] != null) {
          try {
            trainingIntent.value = sport['trainingIntent'].toString();
            appliedSport = true;
          } catch (_) {}
        }

        if (appliedSport) applied.add('sport');
      }
    } catch (e) {
      // ignore prefill errors — do not block session loading
    }

    return applied;
  }

  void _applyLatestResultPrefill(
    Map<String, dynamic> latest,
    Set<String> appliedSections,
  ) {
    try {
      // Support responses wrapped in { data: { ... } }
      final Map<String, dynamic> root = (latest['data'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(latest['data'] as Map)
          : latest;

      // Sleep: apply wake/sleep hours, desired times and fatigue if missing
      final sleep = root['sleep'];
      if (!appliedSections.contains('sleep') && sleep is Map<String, dynamic>) {
        if (sleep['wakeUpTime'] != null) {
          final parts = (sleep['wakeUpTime'] as String).split(':');
          if (parts.length == 2) {
            wakeUpController.hour.value =
                int.tryParse(parts[0]) ?? wakeUpController.hour.value;
            wakeUpController.minute.value =
                int.tryParse(parts[1]) ?? wakeUpController.minute.value;
            wakeUpController.period.value = wakeUpController.hour.value >= 12
                ? 'PM'
                : 'AM';
          }
        }

        if (sleep['sleepHours'] != null) {
          final val = (sleep['sleepHours'] as num).toDouble();
          sleepLastNightController.updateValue(val);
        }

        if (sleep['desiredSleepHours'] != null) {
          final val = (sleep['desiredSleepHours'] as num).toDouble();
          sleepGoalController.updateValue(val);
        }

        if (sleep['fatigueLevel'] != null) {
          final fl = sleep['fatigueLevel'].toString().toLowerCase();
          if (fl == 'low') {
            fatigueLevel.value = 'Low'.tr;
          } else if (fl == 'average' || fl == 'medium') {
            fatigueLevel.value = 'Average'.tr;
          } else if (fl == 'high') {
            fatigueLevel.value = 'High'.tr;
          } else {
            fatigueLevel.value = sleep['fatigueLevel'].toString();
          }
        }

        if (sleep['desiredSleepStart'] != null) {
          final parts = (sleep['desiredSleepStart'] as String).split(':');
          if (parts.length == 2) {
            desiredSleepStartController.hour.value =
                int.tryParse(parts[0]) ??
                desiredSleepStartController.hour.value;
            desiredSleepStartController.minute.value =
                int.tryParse(parts[1]) ??
                desiredSleepStartController.minute.value;
            desiredSleepStartController.period.value =
                desiredSleepStartController.hour.value >= 12 ? 'PM' : 'AM';
          }
        }

        if (sleep['desiredWakeTime'] != null) {
          final parts = (sleep['desiredWakeTime'] as String).split(':');
          if (parts.length == 2) {
            desiredSleepEndController.hour.value =
                int.tryParse(parts[0]) ?? desiredSleepEndController.hour.value;
            desiredSleepEndController.minute.value =
                int.tryParse(parts[1]) ??
                desiredSleepEndController.minute.value;
            desiredSleepEndController.period.value =
                desiredSleepEndController.hour.value >= 12 ? 'PM' : 'AM';
          }
        }
      }

      // Naps: some responses provide top-level `naps.items`
      final napsObj = root['naps'];
      if (!appliedSections.contains('sleep') &&
          napsObj is Map<String, dynamic>) {
        final items = (napsObj['items'] is List)
            ? List<dynamic>.from(napsObj['items'] as List)
            : <dynamic>[];
        if (items.isNotEmpty) {
          final list = <Map<String, dynamic>>[];
          for (final n in items) {
            if (n is Map<String, dynamic>) {
              final order = n['order'] ?? (list.length + 1);
              final start = n['startTime'] ?? n['start'] ?? '';
              final duration =
                  n['durationMin'] ?? n['duration'] ?? n['minutes'] ?? 0;
              list.add({
                'napNumber': order,
                'preferredTime': start,
                'duration': duration.toString(),
              });
            }
          }

          if (list.isNotEmpty) {
            wantsNap.value = true;
            naps.assignAll(list);
          }
        }
      }

      // Hydration: attempt to use scoreBreakdown if present
      if (!appliedSections.contains('hydration')) {
        final sb = root['scoreBreakdown'] as Map<String, dynamic>?;
        final hydrationScore =
            (sb != null ? (sb['hydration'] as num?) : null) ?? 0;
        final defaultGoal = (hydrationScore / 10).clamp(1, 10).toDouble();
        hydrationDailyGoalController.updateValue(defaultGoal);
      }

      // Caffeine: use scoreBreakdown or explicit fields
      if (!appliedSections.contains('caffeine')) {
        final sb = root['scoreBreakdown'] as Map<String, dynamic>?;
        final caffeineScore =
            (sb != null ? (sb['caffeine'] as num?) : null) ?? 0;
        final defaultCaffeine = (400.0 * (1 - (caffeineScore / 100))).clamp(
          0.0,
          caffeinMaxValue.value,
        );
        caffeine24hValue.value = defaultCaffeine;
      }

      // Sport: infer basic intensity/intent from overallScore
      if (!appliedSections.contains('sport')) {
        final overall = (root['overallScore'] as num?)?.toInt() ?? 0;
        if (overall >= 75) {
          trainingIntent.value = 'ALREADY_TRAINED';
          sportIntensity.value = 2.0;
        } else if (overall >= 40) {
          trainingIntent.value = 'WILL_TRAIN';
          sportIntensity.value = 1.0;
        } else {
          trainingIntent.value = 'NO_TRAINING';
          sportIntensity.value = 0.0;
        }
      }

      // Work / Shift: try 'shift' then 'work'
      final workObj = (root['shift'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(root['shift'] as Map)
          : root['work'];
      if (!appliedSections.contains('work') &&
          workObj is Map<String, dynamic>) {
        var appliedWork = false;
        if (workObj['shiftStart'] != null) {
          final parts = (workObj['shiftStart'] as String).split(':');
          if (parts.length == 2) {
            workBeginsController.hour.value =
                int.tryParse(parts[0]) ?? workBeginsController.hour.value;
            workBeginsController.minute.value =
                int.tryParse(parts[1]) ?? workBeginsController.minute.value;
            workBeginsController.period.value =
                workBeginsController.hour.value >= 12 ? 'PM' : 'AM';
            appliedWork = true;
          }
        }

        if (workObj['shiftEnd'] != null) {
          final parts = (workObj['shiftEnd'] as String).split(':');
          if (parts.length == 2) {
            workCompleteController.hour.value =
                int.tryParse(parts[0]) ?? workCompleteController.hour.value;
            workCompleteController.minute.value =
                int.tryParse(parts[1]) ?? workCompleteController.minute.value;
            workCompleteController.period.value =
                workCompleteController.hour.value >= 12 ? 'PM' : 'AM';
            appliedWork = true;
          }
        }

        if (workObj['shiftType'] != null) {
          selectedShiftType.value = workObj['shiftType'].toString();
          appliedWork = true;
        }

        if (workObj['daysWorked'] != null) {
          daysWorkedController.text = workObj['daysWorked'].toString();
          appliedWork = true;
        }

        if (appliedWork) appliedSections.add('work');
      }

      // Nutrition
      final nutrition = root['nutrition'];
      if (!appliedSections.contains('nutrition') &&
          nutrition is Map<String, dynamic>) {
        var appliedNutrition = false;
        if (nutrition['firstMealTime'] != null) {
          final parts = (nutrition['firstMealTime'] as String).split(':');
          if (parts.length == 2) {
            firstMealTimeController.hour.value =
                int.tryParse(parts[0]) ?? firstMealTimeController.hour.value;
            firstMealTimeController.minute.value =
                int.tryParse(parts[1]) ?? firstMealTimeController.minute.value;
            firstMealTimeController.period.value =
                firstMealTimeController.hour.value >= 12 ? 'PM' : 'AM';
            appliedNutrition = true;
          }
        }

        if (nutrition['lastMealTime'] != null) {
          final parts = (nutrition['lastMealTime'] as String).split(':');
          if (parts.length == 2) {
            lastMealTimeController.hour.value =
                int.tryParse(parts[0]) ?? lastMealTimeController.hour.value;
            lastMealTimeController.minute.value =
                int.tryParse(parts[1]) ?? lastMealTimeController.minute.value;
            lastMealTimeController.period.value =
                lastMealTimeController.hour.value >= 12 ? 'PM' : 'AM';
            appliedNutrition = true;
          }
        }

        if (nutrition['desiredMealCount'] != null) {
          desiredNumberOfMealsController.updateValue(
            (nutrition['desiredMealCount'] as num).toDouble(),
          );
          appliedNutrition = true;
        }

        if (nutrition['hadMealToday'] != null) {
          hasMealTodaySelection.value = (nutrition['hadMealToday'] as bool)
              ? 'Yes'
              : 'No';
          appliedNutrition = true;
        }

        if (appliedNutrition) appliedSections.add('nutrition');
      }

      // Hydration explicit mapping
      final hydrationObj = root['hydration'];
      if (!appliedSections.contains('hydration') &&
          hydrationObj is Map<String, dynamic>) {
        var appliedHydration = false;
        if (hydrationObj['waterConsumedL'] != null) {
          hydrationConsumedController.updateValue(
            (hydrationObj['waterConsumedL'] as num).toDouble(),
          );
          appliedHydration = true;
        }
        if (hydrationObj['waterGoalL'] != null) {
          hydrationDailyGoalController.updateValue(
            (hydrationObj['waterGoalL'] as num).toDouble(),
          );
          appliedHydration = true;
        }
        if (appliedHydration) appliedSections.add('hydration');
      }

      // Caffeine explicit mapping
      final caffeineObj = root['caffeine'];
      if (!appliedSections.contains('caffeine') &&
          caffeineObj is Map<String, dynamic>) {
        var appliedCaffeine = false;
        if (caffeineObj['rolling24hMg'] != null) {
          caffeine24hValue.value = (caffeineObj['rolling24hMg'] as num)
              .toDouble();
          appliedCaffeine = true;
        } else if (caffeineObj['totalConsumedMg'] != null) {
          caffeine24hValue.value = (caffeineObj['totalConsumedMg'] as num)
              .toDouble();
          appliedCaffeine = true;
        }

        if (caffeineObj['activeMg'] != null) {
          caffeineLastEightHoursValue.value = (caffeineObj['activeMg'] as num)
              .toDouble();
          appliedCaffeine = true;
        }

        if (caffeineObj['intakes'] != null && caffeineObj['intakes'] is List) {
          final entries = <Map<String, dynamic>>[];
          for (final item in (caffeineObj['intakes'] as List)) {
            if (item is Map<String, dynamic>) {
              final amount = (item['amountMg'] is num)
                  ? (item['amountMg'] as num).toInt()
                  : int.tryParse(item['amountMg']?.toString() ?? '') ?? 0;
              final name =
                  '${item['drinkName'] ?? ''} (${item['drinkType'] ?? ''})';
              final time = item['consumedAt'] ?? item['time'] ?? '';
              entries.add({
                'name': name,
                'dose': '${amount}mg',
                'time': time,
                'isFromLatest': true,
              });
            }
          }
          if (entries.isNotEmpty) {
            caffeineHistory.assignAll(entries);
            // sum total
            double total = 0;
            for (final e in entries) {
              total +=
                  int.tryParse(e['dose']!.replaceAll('mg', '').trim()) ?? 0;
            }
            caffeine24hValue.value = total;
            caffeineLastEightHoursValue.value = total;
            appliedCaffeine = true;
          }
        }

        if (appliedCaffeine) appliedSections.add('caffeine');
      }

      // Sport / Activity mapping (support 'activity' or 'sport')
      final activityObj = (root['activity'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(root['activity'] as Map)
          : root['sport'];
      if (!appliedSections.contains('sport') &&
          activityObj is Map<String, dynamic>) {
        var appliedAct = false;

        // If activity list present in latest result, populate sportActivities
        if (activityObj['activities'] != null &&
            activityObj['activities'] is List) {
          final list = <Map<String, dynamic>>[];
          for (final a in (activityObj['activities'] as List)) {
            if (a is Map<String, dynamic>) {
              final type = a['activityType'] ?? a['activity'] ?? '';
              final intensity = a['intensity'] ?? '';
              final duration = a['durationMin'] ?? a['duration'] ?? 0;
              final performedAt = a['performedAt'] ?? '';
              list.add({
                'activityType': type.toString(),
                'intensity': intensity.toString(),
                'durationMin': duration,
                'performedAt': performedAt.toString(),
              });
            }
          }

          if (list.isNotEmpty) {
            sportActivities.assignAll(list);
            appliedAct = true;
          }
        }

        if (activityObj['activityType'] != null) {
          try {
            selectedActivityType.value = ActivityType.fromApiValue(
              activityObj['activityType'].toString(),
            ).displayName;
          } catch (_) {
            selectedActivityType.value = activityObj['activityType'].toString();
          }
          appliedAct = true;
        }

        if (activityObj['activityDuration'] != null) {
          sportDurationController.text = activityObj['activityDuration']
              .toString();
          appliedAct = true;
        }

        if (activityObj['activityIntensity'] != null) {
          final ai = activityObj['activityIntensity'].toString().toLowerCase();
          if (ai == 'light')
            sportIntensity.value = 0.0;
          else if (ai == 'moderate')
            sportIntensity.value = 1.0;
          else if (ai == 'high')
            sportIntensity.value = 2.0;
          appliedAct = true;
        }

        // Map simple training intent heuristics
        if (!appliedAct && activityObj['activityDuration'] != null) {
          final dur = (activityObj['activityDuration'] as num?)?.toInt() ?? 0;
          if (dur > 0) {
            trainingIntent.value = 'WILL_TRAIN';
            appliedAct = true;
          }
        }

        if (appliedAct) appliedSections.add('sport');
      }
    } catch (_) {
      // swallow fallback mapping errors
    }
  }

  void _initializeSleepControllers() {
    wakeUpController = TimeController();
    desiredSleepStartController = TimeController();
    desiredSleepEndController = TimeController();
    preferredTimeController = TimeController();
    durationController = TextEditingController();
    currentNapDurationController = TextEditingController();
    sleepLastNightController = RangeSliderController(initialValue: 1);
    sleepGoalController = RangeSliderController(initialValue: 1);
  }

  void _initializeWorkControllers() {
    workBeginsController = TimeController();
    workCompleteController = TimeController();
    daysWorkedController = TextEditingController();
  }

  void _initializeNutritionControllers() {
    hydrationConsumedController = RangeSliderController(
      min: 0.0,
      max: 4.0,
      initialValue: 0.0,
    );
    hydrationDailyGoalController = RangeSliderController(
      min: 0.0,
      max: 4.0,
      initialValue: 0.0,
    );
    desiredNumberOfMealsController = RangeSliderController(initialValue: 1.0);
    firstMealTimeController = TimeController();
    lastMealTimeController = TimeController();
  }

  void _initializeSportControllers() {
    sportDurationController = TextEditingController();
  }

  void _initializeCaffeineControllers() {
    caffeineIntakeTimeController = TimeController();
    caffeineDrinkNameController = TextEditingController();
    caffeineDrinkTypeController = TextEditingController();
    caffeineAmountController = TextEditingController();
    // Initialize with sample caffeine history
    caffeineHistory.assignAll([]);
  }

  void _loadCaffeineHistory() {}

  Future<void> _fetchCaffeinePresets() async {
    try {
      isCaffeinePresetsLoading.value = true;
      caffeinePresetsError.value = '';

      final presets = await _calculatorService.getCaffeinePresets();
      caffeinePresets.assignAll(presets);
    } catch (e) {
      caffeinePresetsError.value = e.toString();
    } finally {
      isCaffeinePresetsLoading.value = false;
    }
  }

  void addCaffeineIntake(String name, int mgAmount, String time) {
    caffeineHistory.add({'name': name, 'dose': '${mgAmount}mg', 'time': time});
    caffeine24hValue.value += mgAmount;
    caffeineLastEightHoursValue.value += mgAmount;
  }

  void resetAddCaffeineForm() {
    caffeineDrinkNameController.clear();
    caffeineDrinkTypeController.clear();
    caffeineAmountController.clear();
    caffeineIntakeTimeController.reset();
  }

  bool submitAddCaffeineForm() {
    final String drinkName = caffeineDrinkNameController.text.trim();
    final String drinkType = caffeineDrinkTypeController.text.trim();
    final int? amount = int.tryParse(caffeineAmountController.text.trim());

    if (drinkName.isEmpty ||
        drinkType.isEmpty ||
        amount == null ||
        amount <= 0) {
      return false;
    }

    addCaffeineIntake(
      '$drinkName ($drinkType)',
      amount,
      caffeineIntakeTimeController.to24HourFormat,
    );
    resetAddCaffeineForm();
    return true;
  }

  void clearCaffeineHistory() {
    caffeineHistory.clear();
    caffeine24hValue.value = 0;
    caffeineLastEightHoursValue.value = 0;
  }

  void resetCaffeineTracking() {
    caffeineLastEightHoursValue.value = 0;
  }

  void removeCaffeineEntry(int index) {
    if (index >= 0 && index < caffeineHistory.length) {
      final removedEntry = caffeineHistory.removeAt(index);
      final removedDose =
          int.tryParse(
            (removedEntry['dose'] ?? '').toString().replaceAll('mg', '').trim(),
          ) ??
          0;

      caffeine24hValue.value = (caffeine24hValue.value - removedDose).clamp(
        0.0,
        double.infinity,
      );
      caffeineLastEightHoursValue.value =
          (caffeineLastEightHoursValue.value - removedDose).clamp(
            0.0,
            double.infinity,
          );
    }
  }

  Future<void> submitCaffeineIntake() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        caffeineSubmitError.value = 'Session not initialized';
        return;
      }

      isCaffeineSubmitting.value = true;
      caffeineSubmitError.value = '';

      // Convert caffeineHistory to CaffeineIntake objects
      final List<CaffeineIntake> intakes = [];
      for (final entry in caffeineHistory) {
        final name = entry['name'] ?? '';
        final dose = entry['dose'] ?? '';
        var time = entry['time'] ?? '';

        // Parse dose (e.g., "75mg" -> 75)
        final amountMg = int.tryParse(dose.replaceAll('mg', '').trim()) ?? 0;

        // If time is "Now" or a 12-hour format, use TimeWidget time or format properly
        if (time == 'Now' || time.contains(RegExp(r'(AM|PM)'))) {
          time = caffeineIntakeTimeController.to24HourFormat;
        }

        // Try to find the drink type from presets
        String drinkType = 'COFFEE'; // default
        for (final preset in caffeinePresets) {
          if (preset.label.toLowerCase() == name.toLowerCase()) {
            drinkType = preset.drinkType;
            break;
          }
        }

        intakes.add(
          CaffeineIntake(
            amountMg: amountMg,
            consumedAt: time,
            drinkType: drinkType,
            drinkName: name,
          ),
        );
      }

      final request = CaffeineIntakeRequest(caffeineIntakes: intakes);

      final response = await _calculatorService.submitCaffeineIntake(
        calculatorSession.value!.sessionId!,
        request,
      );

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );
      changeTab(5);
    } catch (e) {
      caffeineSubmitError.value = e.toString();
    } finally {
      isCaffeineSubmitting.value = false;
    }
  }

  Future<void> skipCaffeineIntake() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        caffeineSubmitError.value = 'Session not initialized';
        return;
      }

      isCaffeineSubmitting.value = true;
      caffeineSubmitError.value = '';

      final response = await _calculatorService.skipCaffeineIntake(
        calculatorSession.value!.sessionId!,
      );

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );

      changeTab(5);
    } catch (e) {
      caffeineSubmitError.value = e.toString();
    } finally {
      isCaffeineSubmitting.value = false;
    }
  }

  void selectShiftType(String shiftType) {
    selectedShiftType.value = shiftType;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  String _formatErrorMessage(Object error, {String? servicePrefix}) {
    var message = error.toString().replaceFirst('Exception: ', '');

    if (servicePrefix != null && message.startsWith(servicePrefix)) {
      message = message.substring(servicePrefix.length).trim();
    }

    return message;
  }

  Future<void> submitSleepData() async {
    try {
      if (calculatorSession.value == null) {
        sleepSubmitError.value = 'Session not initialized (value is null)';
        return;
      }

      if (calculatorSession.value!.sessionId == null) {
        sleepSubmitError.value = 'Session ID is null';
        return;
      }

      isSleepSubmitting.value = true;
      sleepSubmitError.value = '';

      // Build nap list
      List<NapData> napList = [];
      for (int i = 0; i < naps.length; i++) {
        final nap = naps[i];
        napList.add(
          NapData(
            startTime: nap['preferredTime'] ?? '00:00',
            durationMin: int.tryParse(nap['duration'] ?? '0') ?? 0,
            order: i + 1,
          ),
        );
      }

      // Normalize fatigue level to API values (always use English values)
      String normalizedFatigue;
      if (fatigueLevel.value == 'Low'.tr) {
        normalizedFatigue = 'Low';
      } else if (fatigueLevel.value == 'Average'.tr) {
        normalizedFatigue = 'Average';
      } else {
        normalizedFatigue = 'High';
      }

      // Build request
      final request = SleepCalculatorRequest(
        wakeUpTime: wakeUpController.to24HourFormat,
        sleepHours: sleepLastNightController.value.value,
        desiredSleepHours: sleepGoalController.value.value,
        fatigueLevel: normalizedFatigue.toUpperCase(),
        desiredSleepStart: desiredSleepStartController.to24HourFormat,
        desiredWakeTime: desiredSleepEndController.to24HourFormat,
        naps: napList,
      );

      final response = await _calculatorService.submitSleepData(
        calculatorSession.value!.sessionId!,
        request,
      );

      if (response.success && response.data != null) {
        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        // Navigate to next tab (work tab)
        changeTab(1);
      } else {
        sleepSubmitError.value = response.message;
      }
    } catch (e) {
      sleepSubmitError.value = _formatErrorMessage(
        e,
        servicePrefix: 'Error submitting sleep data:',
      );
    } finally {
      isSleepSubmitting.value = false;
    }
  }

  Future<void> submitWorkData() async {
    try {
      if (calculatorSession.value == null) {
        workSubmitError.value = 'Session not initialized (value is null)';
        return;
      }

      if (calculatorSession.value!.sessionId == null) {
        workSubmitError.value = 'Session ID is null';
        return;
      }

      isWorkSubmitting.value = true;
      workSubmitError.value = '';

      final request = WorkCalculatorRequest(
        shiftStart: workBeginsController.to24HourFormat,
        shiftEnd: workCompleteController.to24HourFormat,
      );

      final response = await _calculatorService.submitWorkData(
        calculatorSession.value!.sessionId!,
        request,
      );

      if (response.success && response.data != null) {
        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        // Navigate to next tab (nutrition tab)
        changeTab(2);
      } else {
        workSubmitError.value = response.message;
      }
    } catch (e) {
      workSubmitError.value = _formatErrorMessage(
        e,
        servicePrefix: 'Error submitting work data:',
      );
    } finally {
      isWorkSubmitting.value = false;
    }
  }

  Future<void> skipWorkData() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        workSubmitError.value = 'Session not initialized';
        return;
      }

      isWorkSubmitting.value = true;
      workSubmitError.value = '';

      final response = await _calculatorService.skipWorkData(
        calculatorSession.value!.sessionId!,
      );

      if (response.success && response.data != null) {
        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        // Navigate to next tab (nutrition tab)
        changeTab(2);
      } else {
        workSubmitError.value = response.message;
      }
    } catch (e) {
      workSubmitError.value = _formatErrorMessage(
        e,
        servicePrefix: 'Error skipping work:',
      );
    } finally {
      isWorkSubmitting.value = false;
    }
  }

  Future<void> submitNutritionData() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        nutritionSubmitError.value = 'Session not initialized';
        return;
      }

      isNutritionSubmitting.value = true;
      nutritionSubmitError.value = '';

      // Convert Yes/No to boolean
      final hadMealToday = hasMealTodaySelection.value == 'Yes';

      final request = NutritionCalculatorRequest(
        hadMealToday: hadMealToday,
        desiredMealCount: desiredNumberOfMealsController.value.value.toInt(),
        firstMealTime: firstMealTimeController.to24HourFormat,
        lastMealTime: lastMealTimeController.to24HourFormat,
      );

      final response = await _calculatorService.submitNutritionData(
        calculatorSession.value!.sessionId!,
        request,
      );

      if (response.success && response.data != null) {
        // Update session with response data
        calculatorSession.value = CalculatorSession(
          sessionId: response.data!.sessionId,
          completedSteps: response.data!.completedSteps,
          nextStep: response.data!.nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data!.isReadyToCalculate,
          prefilled: false,
        );

        // Navigate to next tab (hydration tab)
        changeTab(3);
      } else {
        nutritionSubmitError.value = response.message;
      }
    } catch (e) {
      nutritionSubmitError.value = e.toString();
    } finally {
      isNutritionSubmitting.value = false;
    }
  }

  Future<void> submitHydrationData() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        hydrationSubmitError.value = 'Session not initialized';
        return;
      }

      isHydrationSubmitting.value = true;
      hydrationSubmitError.value = '';

      final request = HydrationCalculatorRequest(
        waterConsumedL: hydrationConsumedController.value.value,
        waterGoalL: hydrationDailyGoalController.value.value,
      );

      final response = await _calculatorService.submitHydrationData(
        calculatorSession.value!.sessionId!,
        request,
      );

      if (response.success) {
        final currentSession = calculatorSession.value!;
        final completedSteps = response.data?.completedSteps.isNotEmpty == true
            ? response.data!.completedSteps
            : [
                ...currentSession.completedSteps,
                if (!currentSession.completedSteps.contains('hydration'))
                  'hydration',
              ];
        final nextStep = response.data?.nextStep.isNotEmpty == true
            ? response.data!.nextStep
            : 'caffeine';
        final sessionId = response.data?.sessionId.isNotEmpty == true
            ? response.data!.sessionId
            : currentSession.sessionId!;

        calculatorSession.value = CalculatorSession(
          sessionId: sessionId,
          completedSteps: completedSteps,
          nextStep: nextStep,
          isFinalized: false,
          isReadyToCalculate: response.data?.isReadyToCalculate ?? false,
          prefilled: false,
        );

        changeTab(4);
      } else {
        hydrationSubmitError.value = response.message;
      }
    } catch (e) {
      hydrationSubmitError.value = e.toString();
    } finally {
      isHydrationSubmitting.value = false;
    }
  }

  void selectActivityType(String activityType) {
    selectedActivityType.value = activityType;
  }

  void setTrainingIntent(String intent) {
    trainingIntent.value = intent;
    // if user chooses no training, clear duration and intensity
    if (intent == 'NO_TRAINING') {
      sportDurationController.clear();
      setSportIntensity(0);
    }
  }

  void setSportIntensity(double intensity) {
    sportIntensity.value = intensity;
  }

  // Nap management methods
  void addNap(String duration, String preferredTime) {
    if (duration.isNotEmpty && preferredTime.isNotEmpty) {
      naps.add({
        'duration': duration,
        'preferredTime': preferredTime,
        'napNumber': naps.length + 1,
      });
      // Clear inputs after adding
      currentNapDurationController.clear();
      preferredTimeController.reset();
    }
  }

  void removeNap(int index) {
    if (index >= 0 && index < naps.length) {
      naps.removeAt(index);
    }
  }

  void clearAllNaps() {
    naps.clear();
    currentNapDurationController.clear();
  }

  void setWantsNap(bool value) {
    wantsNap.value = value;
    if (!value) {
      clearAllNaps();
    }
  }

  Future<void> submitSportData() async {
    try {
      if (calculatorSession.value == null ||
          calculatorSession.value!.sessionId == null) {
        sportSubmitError.value = 'Session not initialized';
        return;
      }
      // Validate/prepare based on training intent
      isSportSubmitting.value = true;
      sportSubmitError.value = '';

      final intent = trainingIntent.value;

      int activityDuration = 0;
      String activityIntensity = 'LIGHT';
      String activityType = ActivityType.walk.apiValue;

      if (intent == 'WILL_TRAIN' || intent == 'ALREADY_TRAINED') {
        if (sportDurationController.text.isEmpty) {
          sportSubmitError.value = 'Please enter activity duration';
          isSportSubmitting.value = false;
          return;
        }

        activityDuration = int.tryParse(sportDurationController.text) ?? 0;
        if (activityDuration <= 0) {
          sportSubmitError.value = 'Invalid activity duration';
          isSportSubmitting.value = false;
          return;
        }
        // Determine activity type (UI stores display name)
        try {
          if (selectedActivityType.value.isNotEmpty) {
            activityType = ActivityType.fromDisplayName(
              selectedActivityType.value,
            ).apiValue;
          }
        } catch (_) {
          activityType = selectedActivityType.value.toUpperCase();
        }

        // Map slider intensity to API values
        if (sportIntensity.value == 1.0) {
          activityIntensity = 'MODERATE';
        } else if (sportIntensity.value == 2.0) {
          activityIntensity = 'HARD';
        } else {
          activityIntensity = 'LIGHT';
        }
      }

      // Build activities array per new API shape
      final activities = <SportActivity>[];
      if (intent == 'WILL_TRAIN' || intent == 'ALREADY_TRAINED') {
        activities.add(
          SportActivity(
            activityType: activityType,
            intensity: activityIntensity,
            durationMin: activityDuration,
            performedAt: '',
          ),
        );
      }

      final request = SportRequest(
        trainingIntent: intent,
        activities: activities,
      );

      final response = await _calculatorService.submitSportData(
        calculatorSession.value!.sessionId!,
        request,
      );

      // Update session with response data
      calculatorSession.value = CalculatorSession(
        sessionId: response.sessionId,
        completedSteps: response.completedSteps,
        nextStep: response.nextStep,
        isFinalized: false,
        isReadyToCalculate: response.isReadyToCalculate,
        prefilled: false,
      );
      // Immediately reflect submitted activities in the local UI list
      if (activities.isNotEmpty) {
        final list = activities
            .map(
              (a) => {
                'activityType': a.activityType,
                'intensity': a.intensity,
                'durationMin': a.durationMin,
                'performedAt': a.performedAt,
              },
            )
            .toList();
        // Append so new activities appear at the end
        sportActivities.addAll(list);
      }
    } catch (e) {
      sportSubmitError.value = e.toString();
    } finally {
      isSportSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    durationController.dispose();
    currentNapDurationController.dispose();
    daysWorkedController.dispose();
    sportDurationController.dispose();
    caffeineDrinkNameController.dispose();
    caffeineDrinkTypeController.dispose();
    caffeineAmountController.dispose();
    caffeineIntakeTimeController.dispose();
    super.onClose();
  }
}
