import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_api_model.dart';
import 'package:chrisimhof/features/recomendations/widgets/recomendation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecomendationsScreen extends StatelessWidget {
  const RecomendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecommendationController controller =
        Get.find<RecommendationController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryButtonColor,
              ),
            );
          }

          final data = controller.recommendationResponse.value?.data;
          final grouped = data?.grouped;
          final List<List<RecommendationItem>> activeCategories = [];
          if (grouped != null) {
            if (grouped.Caffeine != null && grouped.Caffeine!.isNotEmpty) {
              activeCategories.add(grouped.Caffeine!);
            }
            if (grouped.Hydration != null && grouped.Hydration!.isNotEmpty) {
              activeCategories.add(grouped.Hydration!);
            }
            if (grouped.Nutrition != null && grouped.Nutrition!.isNotEmpty) {
              activeCategories.add(grouped.Nutrition!);
            }
            if (grouped.Sport != null && grouped.Sport!.isNotEmpty) {
              activeCategories.add(grouped.Sport!);
            }
            if (grouped.Work != null && grouped.Work!.isNotEmpty) {
              activeCategories.add(grouped.Work!);
            }
            if (grouped.Fatigue != null && grouped.Fatigue!.isNotEmpty) {
              activeCategories.add(grouped.Fatigue!);
            }
            if (grouped.Sleep != null && grouped.Sleep!.isNotEmpty) {
              activeCategories.add(grouped.Sleep!);
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  showBackButton: true,
                  showSettingsButton: false,
                  showLogo: false,
                  title: 'Recommendations',
                  showMoreButton: false,
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.mintSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppColors.primaryButtonColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              (data?.actionsLabel != null && data!.actionsLabel!.isNotEmpty)
                                  ? data.actionsLabel!.tr
                                  : (data?.message != null && data!.message!.isNotEmpty ? 'Note'.tr : ''),
                              style: getTextStyle2(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryButtonColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        (data?.contextNote != null && data!.contextNote!.isNotEmpty)
                            ? data.contextNote!
                            : (data?.message ?? ''),
                        style: getTextStyle2(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mint3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeCategories.length,
                  itemBuilder: (context, index) {
                    final categoryList = activeCategories[index];
                    final item = categoryList.first;

                    return RecomendationCard(
                      recomendation: item,
                      subRecommendations: categoryList,
                      onTap: () {
                        debugPrint('Tapped ${item.title}');
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
