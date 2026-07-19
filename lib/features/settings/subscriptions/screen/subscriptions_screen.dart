import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/subscriptions/controller/subscriptions_controller.dart';
import 'package:chrisimhof/features/settings/subscriptions/widget/subscription_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      title: 'Subscription'.tr,
                      showBackButton: true,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Choose your plan'.tr,
                      style: getTextStyle2(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start simple. Premium unlocks deeper rhythm support and history.'
                          .tr,
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMid,
                      ),
                    ),
                    const SizedBox(height: 30),
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
                              style: const TextStyle(color: AppColors.red),
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
                            final plan =
                                controller.subscriptionPlans.value[index];
                            final isSelected =
                                plan.id == controller.selectedPlanId.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SubscriptionPlanWidget(
                                planName: plan.name.tr,
                                planPrice: plan.formattedPrice,
                                features: plan.features,
                                isSelected: isSelected,
                                description: plan.description,

                                onTap: () {
                                  controller.selectPlan(plan.id);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      if (controller.isLoading.value ||
                          controller.subscriptionPlans.value.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final isCurrentPlan =
                          controller.selectedPlanId.value ==
                          controller.activePlanId.value;

                      return CustomButton(
                        text: isCurrentPlan ? 'Current Plan' : 'Subscribe',
                        icon: null,
                        onTap: isCurrentPlan
                            ? null
                            : () {
                                controller.subscribeSelectedPlan();
                              },
                        backgroundColor: isCurrentPlan
                            ? AppColors.gray100Alt
                            : null,
                        textColor: isCurrentPlan ? AppColors.textMid : null,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
