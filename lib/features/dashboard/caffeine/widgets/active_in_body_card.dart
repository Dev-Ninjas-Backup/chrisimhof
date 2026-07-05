import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveInBodyCard extends StatelessWidget {
  final CaffeineController controller;

  const ActiveInBodyCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeVal = controller.activeCaffeine.value;
      final totalVal = controller.todayTotalCaffeine.value;
      final double totalValDouble = totalVal.toDouble();
      final double maxVal = totalValDouble > 400.0
          ? ((totalValDouble / 200.0).ceil() * 200.0)
          : 400.0;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.caffeineBgStart, AppColors.caffeineBgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACTIVE IN BODY'.tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.caffeineTextDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${activeVal.round()}',
                  style: getTextStyle2(
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'mg',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
                const Spacer(),
                Text(
                  'half-life ~5h',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double progress = (totalValDouble / maxVal).clamp(0.0, 1.0);
                final double knobPosition = progress * width;
                return Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.caffeineAccent.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Container(
                      height: 6,
                      width: knobPosition,
                      decoration: BoxDecoration(
                        color: AppColors.caffeineTextDark,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Positioned(
                      left: (knobPosition - 8).clamp(0.0, width - 16.0),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.caffeineTextDark,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0 mg',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
                Text(
                  '${(maxVal / 2).round()} mg',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
                Text(
                  '${maxVal.round()} mg',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.caffeineTextDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: getTextStyle(
                  fontSize: 16,
                  color: AppColors.caffeineTextDark,
                ),
                children: [
                  TextSpan(text: 'Today: '.tr),
                  TextSpan(
                    text: '$totalVal',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.caffeineTextDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
