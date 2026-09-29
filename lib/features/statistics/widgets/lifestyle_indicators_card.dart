import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LifestyleIndicatorsCard extends StatelessWidget {
  final StatisticsController controller;

  const LifestyleIndicatorsCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sport = controller.sportMetric.value > 0 ? controller.sportMetric.value : 71;
      final hydration = controller.hydrationMetric.value > 0 ? controller.hydrationMetric.value : 82;
      final caffeine = controller.caffeineMetric.value > 0 ? controller.caffeineMetric.value : 58;
      final nutrition = controller.nutritionMetric.value > 0 ? controller.nutritionMetric.value : 64;
      final sleep = controller.sleepMetric.value > 0 ? controller.sleepMetric.value : 76;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
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
                const Icon(
                  Icons.bar_chart_rounded,
                  size: 22,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mes indicateurs'.tr,
                  style: getTextStyle2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Row 1: Sport & Hydratation
            Row(
              children: [
                Expanded(
                  child: _buildIndicatorItem(
                    icon: Icons.fitness_center_rounded,
                    title: 'Sport'.tr,
                    percent: sport,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildIndicatorItem(
                    icon: Icons.water_drop_outlined,
                    title: 'Hydratation'.tr,
                    percent: hydration,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Row 2: Caféine & Nutrition
            Row(
              children: [
                Expanded(
                  child: _buildIndicatorItem(
                    icon: Icons.coffee_outlined,
                    title: 'Caféine'.tr,
                    percent: caffeine,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildIndicatorItem(
                    icon: Icons.apple_outlined,
                    title: 'Nutrition'.tr,
                    percent: nutrition,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Row 3: Sommeil (Full Width)
            _buildIndicatorItem(
              icon: Icons.bedtime_outlined,
              title: 'Sommeil'.tr,
              percent: sleep,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildIndicatorItem({
    required IconData icon,
    required String title,
    required int percent,
  }) {
    final clamped = (percent / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: const Color(0xFF10B981)),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Text(
              '$percent %',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: clamped,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
