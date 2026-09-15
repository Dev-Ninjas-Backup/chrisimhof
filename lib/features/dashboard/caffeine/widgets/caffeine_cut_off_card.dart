import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaffeineCutOffCard extends StatelessWidget {
  const CaffeineCutOffCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaffeineController>();
    return Obx(() {
      // 1. Primary source: CaffeineController
      var cutoffTime = controller.forYouCaffeineCutoff.value;
      var fullBody = controller.forYouCaffeineBody.value;

      // 2. Fallback: DashboardController cached caffeine card
      if ((cutoffTime == null || cutoffTime.isEmpty) &&
          Get.isRegistered<DashboardController>()) {
        final db = Get.find<DashboardController>();
        final card = db.caffeineCardData.value;
        if (card != null && card['cutoffTime'] != null) {
          cutoffTime = card['cutoffTime'] as String?;
        }
      }

      // 3. Fallback: RecommendationController recommendations
      if ((cutoffTime == null || cutoffTime.isEmpty) &&
          Get.isRegistered<RecommendationController>()) {
        final recs = Get.find<RecommendationController>()
            .recommendationResponse
            .value
            ?.data
            ?.recommendations;
        final caffeineRec = recs?.firstWhereOrNull(
          (r) => r.category?.toLowerCase() == 'caffeine',
        );
        if (caffeineRec != null) {
          cutoffTime = caffeineRec.bodyParams?['cutoffTime'] as String? ??
              caffeineRec.bodyParams?['cutoff'] as String?;
          fullBody ??= caffeineRec.body;
        }
      }

      // Split body into bold part (before '—') and normal part (after '—') if possible
      final String boldPart;
      final String normalPart;
      if (fullBody != null && fullBody.contains('—')) {
        final idx = fullBody.indexOf('—');
        boldPart = fullBody.substring(0, idx).trim();
        normalPart = ' — ${fullBody.substring(idx + 1).trim()}';
      } else if (fullBody != null && fullBody.isNotEmpty) {
        boldPart = fullBody;
        normalPart = '';
      } else {
        boldPart = '${'Cut-off'.tr} ${cutoffTime ?? '--:--'}';
        normalPart = cutoffTime != null
            ? ' — protect tonight\'s sleep window.'.tr
            : '';
      }


      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.amber, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.amber, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: boldPart,
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amberDark,
                      ),
                    ),
                    TextSpan(
                      text: normalPart,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
