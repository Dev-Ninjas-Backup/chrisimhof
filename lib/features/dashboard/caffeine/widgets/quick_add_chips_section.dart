import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/widgets/caffeine_entry_dialog.dart';
import 'package:flutter/material.dart';

class QuickAddChipsSection extends StatelessWidget {
  final CaffeineController controller;

  const QuickAddChipsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ADD',
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickAddChip(
              name: 'Espresso',
              amount: 75,
              onTap: () => controller.quickAdd('Espresso', 75),
            ),
            _buildQuickAddChip(
              name: 'Coffee',
              amount: 100,
              onTap: () => controller.quickAdd('Coffee', 100),
            ),
            _buildQuickAddChip(
              name: 'Energy',
              amount: 85,
              onTap: () => controller.quickAdd('Energy drink', 85),
            ),
            _buildQuickAddChip(
              name: 'Tea',
              amount: 45,
              onTap: () => controller.quickAdd('Tea', 45),
            ),
            GestureDetector(
              onTap: () => showCaffeineEntryDialog(context, controller),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: AppColors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Custom',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAddChip({
    required String name,
    required int amount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: AppColors.addButtonColor, size: 18),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
                children: [
                  TextSpan(text: name),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '${amount}mg',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
