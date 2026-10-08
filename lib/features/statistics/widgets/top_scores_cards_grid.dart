import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopScoresCardsGrid extends StatelessWidget {
  final StatisticsController controller;

  const TopScoresCardsGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final global = controller.globalScore.value;
      final circadian = controller.circadianScore.value;
      final globalDiff = controller.globalRhythmDiff.value;
      final circadianDiff = controller.circadianChange.value;

      final periodSubtext = controller.selectedPeriod.value == '30d'
          ? 'vs 30 jours précédents'.tr
          : controller.selectedPeriod.value == '90d'
              ? 'vs 90 jours précédents'.tr
              : controller.selectedPeriod.value == '1y'
                  ? 'vs année précédente'.tr
                  : 'vs 7 jours précédents'.tr;

      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Rythme global'.tr,
              icon: Icons.trending_up_rounded,
              scoreText: '$global %',
              diffText: globalDiff != 0 ? '${globalDiff > 0 ? '+' : ''}$globalDiff pts' : '',
              isPositive: globalDiff >= 0,
              subtext: periodSubtext,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Stabilité circadienne'.tr,
              icon: Icons.wb_sunny_outlined,
              scoreText: '$circadian %',
              diffText: circadianDiff.isNotEmpty ? circadianDiff : '',
              isPositive: !circadianDiff.startsWith('-'),
              subtext: periodSubtext,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required String scoreText,
    required String diffText,
    required bool isPositive,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF10B981)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            scoreText,
            style: getTextStyle2(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          if (diffText.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isPositive
                    ? const Color(0xFFECFDF5)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPositive
                      ? const Color(0xFFA7F3D0)
                      : const Color(0xFFFECDD3),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    size: 12,
                    color: isPositive
                        ? const Color(0xFF059669)
                        : const Color(0xFFE11D48),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    diffText,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isPositive
                          ? const Color(0xFF059669)
                          : const Color(0xFFE11D48),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtext,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ] else ...[
            Text(
              'No prior data'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
