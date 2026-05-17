import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HydrationSummaryCard extends StatelessWidget {
  final double consumed;
  final double goal;
  final double remaining;

  const HydrationSummaryCard({
    super.key,
    required this.consumed,
    required this.goal,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal <= 0 ? 0.0 : (consumed / goal).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Hydration'.tr,
            style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HydrationStat(
                  label: 'Consumed'.tr,
                  value: '${_formatLiters(consumed)} L',
                ),
              ),
              Expanded(
                child: _HydrationStat(
                  label: 'Remaining'.tr,
                  value: '${_formatLiters(remaining)} L',
                ),
              ),
              Expanded(
                child: _HydrationStat(
                  label: 'Goal'.tr,
                  value: '${_formatLiters(goal)} L',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryButtonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationStat extends StatelessWidget {
  final String label;
  final String value;

  const _HydrationStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(fontSize: 12, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

String _formatLiters(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
