import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/widgets/add_caffeine_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickAddChipsSection extends StatelessWidget {
  final CaffeineController controller;

  const QuickAddChipsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ADD'.tr,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),

        // 2x2 Grid of drink presets
        Row(
          children: [
            Expanded(
              child: _buildPresetCard(
                name: 'Espresso',
                amount: 75,
                icon: Icons.coffee_outlined,
                onTap: () => controller.quickAdd('Espresso', 75),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPresetCard(
                name: 'Coffee',
                amount: 100,
                icon: Icons.local_cafe_outlined,
                onTap: () => controller.quickAdd('Coffee', 100),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildPresetCard(
                name: 'Energy',
                amount: 85,
                icon: Icons.bolt_rounded,
                onTap: () => controller.quickAdd('Energy', 85),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPresetCard(
                name: 'Tea',
                amount: 45,
                icon: Icons.emoji_food_beverage_outlined,
                onTap: () => controller.quickAdd('Tea', 45),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Full-width "Personnalisé" / "Custom" card
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => AddCaffeineBottomSheet.show(context, controller: controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFED7AA),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFED7AA),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: Color(0xFF9A3412),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Custom'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Name and caffeine amount'.tr,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9A3412),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetCard({
    required String name,
    required int amount,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: const Color(0xFF9A3412),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$amount mg',
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.add_rounded,
              color: Color(0xFF9A3412),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
