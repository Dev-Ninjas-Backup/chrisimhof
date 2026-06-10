import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxString selectedPeriod = '7d'.obs;

  // Global Rhythm Score metrics
  final RxInt globalScore = 69.obs;
  final RxInt sleepMetric = 88.obs;
  final RxInt caffeineMetric = 45.obs;
  final RxInt sportMetric = 64.obs;
  final RxInt hydrationMetric = 72.obs;
  final RxInt nutritionMetric = 67.obs;
  final RxInt workFitMetric = 80.obs;

  // Circadian Stability metrics
  final RxInt circadianScore = 82.obs;
  final RxString circadianChange = '+6 vs last week'.obs;

  // Sleep Duration metrics
  final RxString sleepDurationValue = '6h 58m'.obs;
  final RxList<double> sleepDurationData = <double>[
    0.3,
    0.5,
    0.4,
    0.45,
    0.25,
    0.6,
    0.4,
  ].obs;

  // Recovery metrics
  final RxInt recoveryScore = 78.obs;
  final RxInt recoveryChange = 4.obs;
  final RxList<double> recoveryData = <double>[
    0.2,
    0.35,
    0.28,
    0.35,
    0.28,
    0.45,
    0.48,
  ].obs;

  // Fatigue Prediction metrics
  final RxString fatigueExpectedTime = 'Thu 14:00'.obs;
  final RxList<double> fatigueWeeklyData = <double>[
    0.35,
    0.7,
    0.95,
    0.7,
    0.35,
    0.15,
    0.35,
  ].obs; // M, T, W, T, F, S, S

  // Sleep Debt metrics
  final RxString sleepDebtValue = '1h 18m'.obs;
  final RxString sleepDebtChange = '-35m'.obs;
  final RxDouble sleepDebtProgress = 0.35.obs;

  void changePeriod(String period) {
    selectedPeriod.value = period;

    // Update data with slightly different mock values to simulate fetching new metrics
    if (period == '7d') {
      globalScore.value = 69;
      sleepMetric.value = 88;
      caffeineMetric.value = 45;
      sportMetric.value = 64;
      hydrationMetric.value = 72;
      nutritionMetric.value = 67;
      workFitMetric.value = 80;
      circadianScore.value = 82;
      circadianChange.value = '+6 vs last week';
      sleepDurationValue.value = '6h 58m';
      sleepDurationData.assignAll([0.3, 0.5, 0.4, 0.45, 0.25, 0.6, 0.4]);
      recoveryScore.value = 78;
      recoveryChange.value = 4;
      recoveryData.assignAll([0.2, 0.35, 0.28, 0.35, 0.28, 0.45, 0.48]);
      fatigueWeeklyData.assignAll([0.35, 0.7, 0.95, 0.7, 0.35, 0.15, 0.35]);
      sleepDebtValue.value = '1h 18m';
      sleepDebtChange.value = '-35m';
      sleepDebtProgress.value = 0.35;
    } else if (period == '30d') {
      globalScore.value = 72;
      sleepMetric.value = 82;
      caffeineMetric.value = 50;
      sportMetric.value = 70;
      hydrationMetric.value = 68;
      nutritionMetric.value = 75;
      workFitMetric.value = 85;
      circadianScore.value = 79;
      circadianChange.value = '-2 vs last month';
      sleepDurationValue.value = '7h 12m';
      sleepDurationData.assignAll([0.4, 0.35, 0.6, 0.55, 0.4, 0.7, 0.55]);
      recoveryScore.value = 75;
      recoveryChange.value = -2;
      recoveryData.assignAll([0.3, 0.4, 0.35, 0.42, 0.3, 0.55, 0.5]);
      fatigueWeeklyData.assignAll([0.4, 0.65, 0.8, 0.65, 0.4, 0.25, 0.4]);
      sleepDebtValue.value = '0h 45m';
      sleepDebtChange.value = '-15m';
      sleepDebtProgress.value = 0.22;
    } else if (period == '90d') {
      globalScore.value = 75;
      sleepMetric.value = 85;
      caffeineMetric.value = 40;
      sportMetric.value = 75;
      hydrationMetric.value = 78;
      nutritionMetric.value = 70;
      workFitMetric.value = 82;
      circadianScore.value = 85;
      circadianChange.value = '+8 vs last period';
      sleepDurationValue.value = '7h 05m';
      sleepDurationData.assignAll([0.45, 0.55, 0.5, 0.65, 0.3, 0.55, 0.6]);
      recoveryScore.value = 80;
      recoveryChange.value = 5;
      recoveryData.assignAll([0.35, 0.45, 0.4, 0.5, 0.35, 0.6, 0.55]);
      fatigueWeeklyData.assignAll([0.3, 0.6, 0.75, 0.6, 0.3, 0.2, 0.3]);
      sleepDebtValue.value = '0h 58m';
      sleepDebtChange.value = '-22m';
      sleepDebtProgress.value = 0.28;
    } else if (period == '1y') {
      globalScore.value = 78;
      sleepMetric.value = 80;
      caffeineMetric.value = 35;
      sportMetric.value = 78;
      hydrationMetric.value = 82;
      nutritionMetric.value = 73;
      workFitMetric.value = 84;
      circadianScore.value = 88;
      circadianChange.value = '+12 vs last year';
      sleepDurationValue.value = '7h 20m';
      sleepDurationData.assignAll([0.5, 0.6, 0.55, 0.7, 0.45, 0.65, 0.7]);
      recoveryScore.value = 82;
      recoveryChange.value = 8;
      recoveryData.assignAll([0.4, 0.5, 0.45, 0.55, 0.4, 0.65, 0.6]);
      fatigueWeeklyData.assignAll([0.3, 0.55, 0.7, 0.55, 0.3, 0.18, 0.3]);
      sleepDebtValue.value = '0h 30m';
      sleepDebtChange.value = '-45m';
      sleepDebtProgress.value = 0.15;
    }
  }
}
