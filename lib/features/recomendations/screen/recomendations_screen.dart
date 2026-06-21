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
        Get.isRegistered<RecommendationController>()
            ? Get.find<RecommendationController>()
            : Get.put(RecommendationController());

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
          final recommendations = data?.recommendations ?? [];

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
                              data?.actionsLabel?.tr ?? '',
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
                        data?.contextNote ?? '',
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
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final item = recommendations[index];

                    List<RecommendationItem>? subRecommendations;
                    final category = item.category?.toLowerCase();
                    if (data?.grouped != null && category != null) {
                      switch (category) {
                        case 'sleep':
                          subRecommendations = data!.grouped!.sleep;
                          break;
                        case 'caffeine':
                          subRecommendations = data!.grouped!.caffeine;
                          break;
                        case 'hydration':
                          subRecommendations = data!.grouped!.hydration;
                          break;
                        case 'sport':
                          subRecommendations = data!.grouped!.sport;
                          break;
                        case 'nutrition':
                          subRecommendations = data!.grouped!.nutrition;
                          break;
                        case 'fatigue':
                          subRecommendations = data!.grouped!.fatigue;
                          break;
                      }
                    }

                    return RecomendationCard(
                      recomendation: item,
                      subRecommendations: subRecommendations,
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
