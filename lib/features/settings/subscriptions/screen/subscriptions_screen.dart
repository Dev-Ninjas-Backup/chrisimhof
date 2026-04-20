import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/settings/subscriptions/controller/subscriptions_controller.dart';
import 'package:chrisimhof/features/settings/subscriptions/widget/subscription_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionsController());

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
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryButtonColor,
                      ),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (controller.subscriptionPlans.value.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text('No subscription plans available'.tr),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    controller.subscriptionPlans.value.length,
                    (index) {
                      final plan = controller.subscriptionPlans.value[index];
                      // Check if this is the active plan
                      final isActive = plan.id == controller.activePlanId.value;
                      // Highlight the most popular plan (Monthly)
                      final isPremium =
                          plan.name.toLowerCase() == 'weekly' ||
                          plan.name.toLowerCase() == 'monthly' ||
                          plan.name.toLowerCase() == 'yearly';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SubscriptionPlanWidget(
                          planName: plan.name.tr,
                          planPrice: plan.formattedPrice,
                          buttonText: isActive ? 'Current'.tr : 'Subscribe'.tr,
                          buttonColor: isActive
                              ? const Color(0xFFE9EAEB)
                              : Colors.white,
                          features: plan.features,
                          onTap: isActive
                              ? null
                              : () {
                                  controller.handleSubscription(plan);
                                },
                          widgetColor: isPremium
                              ? AppColors.primaryButtonColor
                              : Colors.white,
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
