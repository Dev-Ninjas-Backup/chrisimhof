import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/pulsing_rhythm_badge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PulsingRhythmBadge extends StatelessWidget {
  final int score;
  final bool isSleepPrep;

  const PulsingRhythmBadge({
    super.key,
    required this.score,
    required this.isSleepPrep,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PulsingRhythmBadgeController());
    controller.updateState(isSleepPrep: isSleepPrep);

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryButtonColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondaryButtonColor.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.primaryButtonColor,
            size: 15,
          ),
          const SizedBox(width: 7),
          Text(
            'Rhythm score $score',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryButtonColor,
            ),
          ),
        ],
      ),
    );

    return !isSleepPrep
        ? badge
        : AnimatedBuilder(
            animation: controller.anim,
            builder: (_, child) => Transform.scale(
              scale: controller.anim.value,
              child: Opacity(opacity: controller.anim.value, child: badge),
            ),
          );
  }
}
