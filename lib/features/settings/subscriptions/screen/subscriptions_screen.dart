import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/settings/subscriptions/widget/subscription_plan_widget.dart';
import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  static const List<String> _freeFeatures = [
    'Basic daily score',
    'Access to the core calculator (inputs+basic analysis)',
    'Limited Recommendations (high-level guidance only)',
    'No long-term history or very limited history',
  ];

  static const List<String> _premiumFeatures = [
    'Full personalized recommendation engline(sleep,nutrition timing, hydration,training)',
    'Advanced circadian logic and dynamic adjustments',
    'Complete tracking history with evolution over time',
    'Detailed insights ,trends and analytics',
    'Planning features (ideal schedule vs real schedule)',
    'Advanced modules like (fatigue management, caffeine tracking, and performance optimization',
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
              CustomAppBar(title: 'Subscriptions', showBackButton: true),
              const SizedBox(height: 24),

              // Free Plan
              SubscriptionPlanWidget(
                planName: 'Basic',
                planPrice: 'Free',
                buttonText: 'Current Plan',
                buttonColor: const Color(0xFFE9EAEB),
                features: _freeFeatures,
                onTap: () {},
                widgetColor: Colors.white,
              ),

              const SizedBox(height: 16),

              // Premium Plan
              SubscriptionPlanWidget(
                planName: 'Premium',
                planPrice: '\$9.99/mo',
                buttonText: 'Subscribe',
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
