import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodayProgressSection extends StatelessWidget {
  const TodayProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TODAY'.tr,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 14),
        Obx(() {
          final data = controller.dashboardData.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing(
                context: context,
                progress: data.sleepProgress,
                label: 'Sleep',
                color: AppColors.secondaryButtonColor, // Mint
              ),
              _buildProgressRing(
                context: context,
                progress: data.hydrationProgress,
                label: 'Hydration',
                color: AppColors.blue, // Blue
              ),
              _buildProgressRing(
                context: context,
                progress: data.caffeineProgress,
                label: 'Caffeine',
                color: AppColors.amber, // Orange
              ),
              _buildProgressRing(
                context: context,
                progress: data.recoveryProgress,
                label: 'Recovery',
                color: AppColors.violet, // Purple
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildProgressRing({
    required BuildContext context,
    required double progress,
    required String label,
    required Color color,
  }) {
    final displayPercent = (progress * 100).toInt();

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showMetricExplanation(context, label, color, displayPercent),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Ring track background & active progress
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 5.5,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  '$displayPercent%',
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.tr,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.info_outline_rounded,
                  size: 11,
                  color: AppColors.textSoft.withValues(alpha: 0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMetricExplanation(
    BuildContext context,
    String label,
    Color color,
    int percent,
  ) {
    final isFrench = (Get.locale?.languageCode ?? 'fr') == 'fr';

    String title;
    String description;
    IconData icon;

    switch (label) {
      case 'Sleep':
        title = isFrench ? 'Sommeil' : 'Sleep';
        icon = Icons.bedtime_outlined;
        description = isFrench
            ? 'Indique dans quelle mesure le sommeil enregistré correspond à votre objectif. 0 % : objectif non atteint. 100 % : objectif atteint. Plus le pourcentage est élevé, plus l’indicateur est favorable.'
            : 'Shows how closely your logged sleep matches your target. 0%: target not met. 100%: target met. A higher percentage is more favourable.';
        break;
      case 'Hydration':
        title = isFrench ? 'Hydratation' : 'Hydration';
        icon = Icons.water_drop_outlined;
        description = isFrench
            ? 'Indique votre progression vers l’objectif d’hydratation de la journée. 0 % : aucune eau enregistrée. 100 % : objectif atteint. Le pourcentage augmente à mesure que vous vous rapprochez de l’objectif.'
            : 'Shows your progress towards today’s hydration target. 0%: no water logged. 100%: target reached. The percentage rises as you get closer to the target.';
        break;
      case 'Caffeine':
        title = isFrench ? 'Caféine' : 'Caffeine';
        icon = Icons.coffee_outlined;
        description = isFrench
            ? 'Indique à quel point vos prises de caféine sont compatibles avec votre sommeil prévu. 0 % : compatibilité faible. 100 % : compatibilité élevée. Un pourcentage plus élevé est plus favorable.'
            : 'Shows how compatible your caffeine intake is with your planned sleep. 0%: low compatibility. 100%: high compatibility. A higher percentage is more favourable.';
        break;
      case 'Recovery':
      default:
        title = isFrench ? 'Récupération' : 'Recovery';
        icon = Icons.favorite_outline_rounded;
        description = isFrench
            ? 'Représente votre récupération estimée à partir des données utilisées par l’application. 0 % : récupération estimée très faible. 100 % : récupération estimée élevée. Un pourcentage plus élevé est plus favorable.'
            : 'Represents your estimated recovery based on the data used by the app. 0%: very low estimated recovery. 100%: high estimated recovery. A higher percentage is more favourable.';
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: getTextStyle2(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            Text(
                              isFrench ? 'Score actuel : $percent%' : 'Current score: $percent%',
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      description,
                      style: getTextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isFrench ? 'Compris' : 'Got it',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
