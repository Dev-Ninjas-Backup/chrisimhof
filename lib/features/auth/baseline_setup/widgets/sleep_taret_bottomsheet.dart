import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepTaretBottomsheet extends StatelessWidget {
  const SleepTaretBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaselineSetupController>();

    void incrementHours() {
      final nextHour = controller.sleepHours.value < 23
          ? controller.sleepHours.value + 1
          : 0;
      controller.setSleepTarget(
        hours: nextHour,
        minutes: controller.sleepMinutes.value,
      );
    }

    void decrementHours() {
      final nextHour = controller.sleepHours.value > 0
          ? controller.sleepHours.value - 1
          : 23;
      controller.setSleepTarget(
        hours: nextHour,
        minutes: controller.sleepMinutes.value,
      );
    }

    void incrementMinutes() {
      controller.setSleepTarget(
        hours: controller.sleepHours.value,
        minutes: (controller.sleepMinutes.value + 1) % 60,
      );
    }

    void decrementMinutes() {
      controller.setSleepTarget(
        hours: controller.sleepHours.value,
        minutes: (controller.sleepMinutes.value - 1 + 60) % 60,
      );
    }

    double hoursDragAccumulator = 0;
    double minutesDragAccumulator = 0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD5D7DA),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header: Moon, Sleep Target, Close button
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.subtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    IconPath.sleep,
                    width: 22,
                    height: 22,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Sleep target'.tr,
                style: getTextStyle2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.subtle,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Picker controls
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours Column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: incrementHours,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 32,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragStart: (_) => hoursDragAccumulator = 0,
                      onVerticalDragUpdate: (details) {
                        hoursDragAccumulator += details.delta.dy;
                        if (hoursDragAccumulator.abs() > 20) {
                          if (hoursDragAccumulator < 0) {
                            incrementHours();
                          } else {
                            decrementHours();
                          }
                          hoursDragAccumulator = 0;
                        }
                      },
                      onVerticalDragEnd: (_) => hoursDragAccumulator = 0,
                      child: Container(
                        width: 104,
                        height: 92,
                        decoration: BoxDecoration(
                          color: AppColors.subtle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${controller.sleepHours.value}',
                              style: getTextStyle2(
                                fontSize: 52,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'h',
                              style: getTextStyle2(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: decrementHours,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 32,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 24),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    ':',
                    style: getTextStyle2(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD1D5DB),
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // Minutes Column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: incrementMinutes,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 32,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragStart: (_) => minutesDragAccumulator = 0,
                      onVerticalDragUpdate: (details) {
                        minutesDragAccumulator += details.delta.dy;
                        if (minutesDragAccumulator.abs() > 20) {
                          if (minutesDragAccumulator < 0) {
                            incrementMinutes();
                          } else {
                            decrementMinutes();
                          }
                          minutesDragAccumulator = 0;
                        }
                      },
                      onVerticalDragEnd: (_) => minutesDragAccumulator = 0,
                      child: Container(
                        width: 104,
                        height: 92,
                        decoration: BoxDecoration(
                          color: AppColors.subtle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              controller.sleepMinutes.value.toString().padLeft(
                                2,
                                '0',
                              ),
                              style: getTextStyle2(
                                fontSize: 52,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'm',
                              style: getTextStyle2(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: decrementMinutes,
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 32,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          Center(
            child: Text(
              'Adults need 7–9 hours for optimal recovery.'.tr,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
