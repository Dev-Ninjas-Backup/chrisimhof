import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForYouSection extends StatelessWidget {
  const ForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecommendationController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FOR YOU'.tr,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.recomendationsScreen);
              },
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryButtonColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.secondaryButtonColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final recommendations = controller.forYouPreview;

          if (recommendations.isEmpty) {
            return _buildEmptyState();
          }

          // Show top 2
          final preview = recommendations.take(2).toList();

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderSoft, width: 1),
            ),
            child: Column(
              children: [
                for (int i = 0; i < preview.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.borderSoft,
                    ),
                  _buildRecommendationItem(preview[i]),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationItem(RecommendationItem item) {
    final style = RecomendationStyleHelper.getStyle(item.category);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: style.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                style.iconPath,
                width: 18,
                height: 18,
                color: style.iconColor,
                errorBuilder: (_, e, s) => Icon(
                  Icons.lightbulb_outline,
                  color: style.iconColor,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? item.category ?? '',
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.body ?? '',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSoft,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft, width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primaryButtonColor, size: 24),
          const SizedBox(height: 8),
          Text(
            'No recommendations yet',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Log your daily data to get personalised tips.',
            style: getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSoft,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
