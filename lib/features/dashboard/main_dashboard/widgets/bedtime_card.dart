import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/core/const/image_path.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/sleep_orbit_widget.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/pulsing_rhythm_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedtimeCard extends StatelessWidget {
  const BedtimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Obx(() {
      final data = controller.dashboardData.value;

      final Color timeColor = data.isMissedBedtime
          ? AppColors.mintLight
          : AppColors.mintFaded;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF062A20), Color(0xFF0E3626), Color(0xFF0A2E22)],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ── Main content row ──────────────────────────────────────────────
            SizedBox(
              height: 220,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Left text column ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OPTIMAL BEDTIME',
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryButtonColor,
                            ).copyWith(letterSpacing: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.optimalBedtime,
                            style: getTextStyle2(
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.timeUntilBedtime,
                            style: getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: timeColor,
                            ),
                          ),
                          if (data.isMissedBedtime && !data.isSleepLogged) ...[
                            const SizedBox(height: 3),
                            Text(
                              'Still a great time to rest.',
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mintLight.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          PulsingRhythmBadge(
                            score: data.rhythmScore,
                            isSleepPrep: data.isSleepPrep,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Right: orbit + silhouette ────────────────────────────────
                  SizedBox(
                    width: 168,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          right: -4,
                          child: SleepOrbitWidget(
                            imagePath: ImagePath.circadianAvatar,
                            avatarSize: 155,
                            imageShiftFactor: 0.52,
                            optimalBedtime: data.optimalBedtime,
                            minutesToBedtime: data.minutesToBedtime,
                            isSleepLogged: data.isSleepLogged,
                            isSleepPrep: data.isSleepPrep,
                            isMissedBedtime: data.isMissedBedtime,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomAction(
              controller,
              data.isSleepLogged,
              data.isMissedBedtime,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomAction(
    DashboardController controller,
    bool isLogged,
    bool isMissed,
  ) {
    final String label = isLogged
        ? "Logged tonight's sleep"
        : isMissed
            ? "Log sleep — it's not too late"
            : "Log tonight's sleep";

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardDivider, width: 1)),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: controller.logSleep,
          splashColor: AppColors.secondaryButtonColor.withValues(alpha: 0.08),
          highlightColor: AppColors.secondaryButtonColor.withValues(
            alpha: 0.04,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      IconPath.sleep,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryButtonColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
