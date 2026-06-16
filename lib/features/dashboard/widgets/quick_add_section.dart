import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickAddSection extends StatelessWidget {
  const QuickAddSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'QUICK ADD',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            Text(
              'tap to log',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final data = controller.dashboardData.value;
          return Row(
            children: [
              _buildAddCard(
                iconPath: IconPath.homeScreenWaterIcon,
                label: 'Water',
                value: '${data.waterLiters}L',
                iconColor: AppColors.blue,
                bgColor: AppColors.indigoSoft2,
                onTap: controller.addWater,
              ),
              const SizedBox(width: 8),
              _buildAddCard(
                iconPath: IconPath.homeScreenCaffeineIcon,
                label: 'Caffeine',
                value: '${data.caffeineMg}mg',
                iconColor: AppColors.amberDark,
                bgColor: AppColors.amberSoft,
                onTap: () => Get.toNamed(AppRoutes.caffeineScreen),
              ),
              const SizedBox(width: 8),
              _buildAddCard(
                iconPath: IconPath.homeScreenMealIcon,
                label: 'Meal',
                value: '${data.mealsLogged}/${data.mealsTarget}',
                iconColor: AppColors.secondaryButtonColor,
                bgColor: AppColors.mintSoft2,
                onTap: controller.addMeal,
              ),
              const SizedBox(width: 8),
              _buildAddCard(
                iconPath: IconPath.homeScreenSportIcon,
                label: 'Sport',
                value: '${data.sportMinutes}m',
                iconColor: AppColors.violet,
                bgColor: AppColors.indigoSoft3,
                onTap: controller.addSport,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAddCard({
    required String iconPath,
    required String label,
    required String value,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSoft, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        iconPath,
                        width: 20,
                        height: 20,
                        color: iconColor,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.add, color: iconColor, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: getTextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: -2,
              right: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primaryButtonColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.add, color: AppColors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
