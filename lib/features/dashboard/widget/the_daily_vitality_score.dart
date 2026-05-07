import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/widget/vitality_progress_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TheDailyVitalityScore extends StatelessWidget {
  const TheDailyVitalityScore({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 196,
            height: 315,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Daily Vitality Score'.tr,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 125,
                          height: 125,
                          child: CustomPaint(
                            size: const Size(125, 125),
                            painter: VitalityProgressPainter(
                              progress: controller.vitalityScore.value / 100,
                              percentage: controller.vitalityScore.value
                                  .toInt(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.levelText.value,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  Flexible(
                    child: SizedBox(
                      width: 164,
                      child: Text(
                        controller.improvementPercentLabel.value,
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                ImagePath.manBody,
                height: 268,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
