import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecoveryImpactCard extends StatelessWidget {
  const RecoveryImpactCard({
    super.key,
    required this.controller,
  });

  final SportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECOVERY IMPACT'.tr,
                  style: getTextStyle2(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: AppColors.rose,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${controller.recoveryScore.value}',
                        style: getTextStyle2(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.rose,
                        ),
                      ),
                      TextSpan(
                        text: '%',
                        style: getTextStyle2(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.rose,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: controller.recoveryScore.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(4.0),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF97316), // Orange
                                      Color(0xFFEF4444), // Red/Rose
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:
                                  100 - controller.recoveryScore.value,
                              child: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        controller.recoveryText.value.tr,
                        style: getTextStyle2(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
