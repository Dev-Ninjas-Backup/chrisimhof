import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/recomendations/widgets/recomendation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecomendationsScreen extends StatelessWidget {
  const RecomendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecomendationsController controller = Get.put(
      RecomendationsController(),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 120.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                showBackButton: true,
                showSettingsButton: false,
                showLogo: false,
                title: 'Recommendations',
                showMoreButton: true,
              ),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.mintSoft, // #E8FBF3
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome, // Sparkle icon
                          color: AppColors.primaryButtonColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '13 ACTIONS FOR TODAY',
                          style: getTextStyle2(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Your night-shift rhythm is mostly stable — focus on caffeine timing & sleep window.',
                      style: getTextStyle2(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mint3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryButtonColor,
                      ),
                    ),
                  );
                }
                return Column(
                  children: controller.recomendationsList.map((item) {
                    return RecomendationCard(
                      recomendation: item,
                      onTap: () {
                        debugPrint('Tapped ${item.title}');
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
