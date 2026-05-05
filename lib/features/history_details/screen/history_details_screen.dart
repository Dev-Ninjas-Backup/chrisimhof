import 'package:chrisimhof/features/history_details/controller/history_details_controller.dart';
import 'package:chrisimhof/features/history_details/model/history_details_model.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_metric_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_overall_state_card.dart';
import 'package:chrisimhof/features/history_details/widgets/history_details_recommendations_card.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:get/get.dart';

class HistoryDetailsScreen extends StatelessWidget {
  const HistoryDetailsScreen({super.key});

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = [
        'Jan'.tr,
        'Feb'.tr,
        'Mar'.tr,
        'Apr'.tr,
        'May'.tr,
        'Jun'.tr,
        'Jul'.tr,
        'Aug'.tr,
        'Sep'.tr,
        'Oct'.tr,
        'Nov'.tr,
        'Dec'.tr,
      ];
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM'.tr : 'AM'.tr;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final second = dateTime.second.toString().padLeft(2, '0');

      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} $hour:$minute:$second';
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryDetailsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final resultData = controller.resultData.value;

        if (controller.isLoading.value && resultData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resultData == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.error.value.isNotEmpty
                    ? controller.error.value
                    : 'No data available'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryTextColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'History Details'.tr,
                          style: getTextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          _formatDateTime(resultData.createdAt),
                          style: getTextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Overall State Section
              HistoryDetailsOverallStateCard(
                score: resultData.overallScore,
                label: controller.getLabelForScore(resultData.overallScore),
              ),
              const SizedBox(height: 16),

              // 2x2 Grid for State Summary Cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.98,
                ),
                itemBuilder: (context, index) {
                  final metrics = [
                    HistoryMetric(
                      title: 'Sleep',
                      score: resultData.scoreBreakdown.sleep,
                      category: 'sleep',
                    ),
                    HistoryMetric(
                      title: 'Hydration',
                      score: resultData.scoreBreakdown.hydration,
                      category: 'hydration',
                    ),
                    HistoryMetric(
                      title: 'Caffeine',
                      score: resultData.scoreBreakdown.caffeine,
                      category: 'caffeine',
                    ),
                    HistoryMetric(
                      title: 'Nutrition',
                      score: resultData.scoreBreakdown.nutrition,
                      category: 'nutrition',
                    ),
                  ];
                  return HistoryDetailsMetricCard(metric: metrics[index]);
                },
              ),
              const SizedBox(height: 16),

              // Recommendations Section
              HistoryDetailsRecommendationsCard(
                recommendations: resultData.recommendations,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
