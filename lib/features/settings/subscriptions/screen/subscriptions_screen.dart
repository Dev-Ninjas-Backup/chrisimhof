import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/settings/subscriptions/widget/subscription_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  List<String> get _freeFeatures => [
    'Basic daily score'.tr,
    'Access to the core calculator (inputs+basic analysis)'.tr,
    'Limited Recommendations (high-level guidance only)'.tr,
    'No long-term history or very limited history'.tr,
  ];

  List<String> get _premiumFeatures => [
    'Full personalized recommendation engline(sleep,nutrition timing, hydration,training)'
        .tr,
    'Advanced circadian logic and dynamic adjustments'.tr,
    'Complete tracking history with evolution over time'.tr,
    'Detailed insights ,trends and analytics'.tr,
    'Planning features (ideal schedule vs real schedule)'.tr,
    'Advanced modules like (fatigue management, caffeine tracking, and performance optimization'
        .tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 78,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: Column(
            children: [
              CustomAppBar(title: 'Subscriptions'.tr, showBackButton: true),
              const SizedBox(height: 24),

              // Free Plan
              SubscriptionPlanWidget(
                planName: 'Basic'.tr,
                planPrice: 'Free'.tr,
                buttonText: 'Current Plan'.tr,
                buttonColor: const Color(0xFFE9EAEB),
                features: _freeFeatures,
                onTap: () {},
                widgetColor: Colors.white,
              ),

              const SizedBox(height: 16),

              // Premium Plan
              SubscriptionPlanWidget(
                planName: 'Premium'.tr,
                planPrice: '\$9.99/mo'.tr,
                buttonText: 'Subscribe'.tr,
                buttonColor: Colors.white, // use your primary color
                features: _premiumFeatures,
                onTap: () {
                  // handle upgrade
                },
                widgetColor: AppColors.primaryButtonColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
