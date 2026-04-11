import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/model/dashboard_item_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final vitalityScore = 81.0.obs;
  final levelText = 'Good level'.obs;
  final improvementPercent = 5.obs;

  final dashboardItems = <DashboardItemModel>[
    DashboardItemModel(
      title: 'Sleep',
      image: IconPath.moon,
      percent: '90%',
      description: '7h slept / 0h debt',
    ),
    DashboardItemModel(
      title: 'Hydration',
      image: IconPath.waterDrops,
      percent: '72%',
      description: '1.5L / 2.5L',
    ),
    DashboardItemModel(
      title: 'Caffeine',
      image: IconPath.vector,
      percent: '82%',
      description: '123 mg today',
    ),
    DashboardItemModel(
      title: 'Nutrition',
      image: IconPath.iron,
      percent: '86%',
      description: 'Small night meal • 3 meals',
    ),
  ].obs;

  void updateVitalityScore(double newScore) {
    vitalityScore.value = newScore;
  }

  String get formattedScore => '${vitalityScore.value.toInt()}%';
}
