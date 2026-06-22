import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecomendationCard extends StatelessWidget {
  final RecommendationItem recomendation;
  final List<RecommendationItem>? subRecommendations;
  final VoidCallback onTap;

  const RecomendationCard({
    super.key,
    required this.recomendation,
    this.subRecommendations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = RecomendationStyleHelper.getStyle(recomendation.category);
    final controller = Get.find<RecommendationController>();

    final hasGroup =
        subRecommendations != null && subRecommendations!.isNotEmpty;

    return Obx(() {
      final isExpanded = controller.isCategoryExpanded(recomendation.category);

      return GestureDetector(
        onTap: () {
          if (hasGroup) {
            controller.toggleCategoryExpansion(recomendation.category);
          }
          onTap();
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: AppColors.borderSoft, // #EEF2F0
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container with background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: style.iconBgColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                      child: Image.asset(
                        style.iconPath,
                        width: 24,
                        height: 24,
                        color: style.iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                recomendation.category?.capitalizeFirst?.tr ?? '',
                                style: getTextStyle2(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                            if (subRecommendations != null &&
                                subRecommendations!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: style.badgeBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    subRecommendations!.length.toString(),
                                    style: getTextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: style.badgeTextColor,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          recomendation.body ?? '',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor,
                          ),
                          maxLines: isExpanded ? null : 2,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // Notification Badge & Chevron Right/Down/Up Arrow
                  Icon(
                    hasGroup
                        ? (isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded)
                        : Icons.chevron_right_rounded,
                    color: AppColors.borderColor,
                    size: 20,
                  ),
                ],
              ),
              if (hasGroup && isExpanded) ...[
                const SizedBox(height: 16.0),
                const Divider(color: AppColors.borderSoft, height: 1.0),
                const SizedBox(height: 8.0),
                ...subRecommendations!.map((subItem) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6.0, right: 12.0),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: style.iconColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (subItem.title != null &&
                                  subItem.title!.isNotEmpty)
                                Text(
                                  subItem.title!,
                                  style: getTextStyle2(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              if (subItem.body != null &&
                                  subItem.body!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    subItem.body!,
                                    style: getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondaryTextColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      );
    });
  }
}
