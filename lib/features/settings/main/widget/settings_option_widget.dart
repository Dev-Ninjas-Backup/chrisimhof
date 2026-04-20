import 'package:chrisimhof/features/settings/language/screens/language_screen.dart';
import 'package:chrisimhof/features/settings/main/widget/option_item.dart';
import 'package:chrisimhof/features/settings/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:chrisimhof/features/settings/subscriptions/screen/subscriptions_screen.dart';
import 'package:chrisimhof/features/settings/terms_of_use/screen/terms_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsOptionWidget extends StatelessWidget {
  const SettingsOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          OptionItem(
            title: 'Subscriptions.'.tr,
            icon: Icons.attach_money_outlined,
            onTap: () {
              Get.to(SubscriptionsScreen());
            },
            showPremiumBadge: true,
          ),
          OptionItem(
            title: 'Change Password'.tr,
            icon: Icons.notifications_outlined,
            onTap: () {
              Get.toNamed('/changePasswordScreen');
            },
            showPremiumBadge: false,
          ),
          OptionItem(
            title: 'Choose Language'.tr,
            icon: Icons.language_outlined,
            onTap: () {
              Get.to(LanguageScreen());
            },
            showPremiumBadge: false,
          ),
          OptionItem(
            title: 'Privacy Policy'.tr,
            icon: Icons.lock,
            onTap: () {
              Get.to(PrivacyPolicyScreen());
            },
            showPremiumBadge: false,
          ),
          OptionItem(
            title: 'Terms of Use'.tr,
            icon: Icons.file_copy,
            onTap: () {
              Get.to(TermsOfUseScreen());
            },
            showPremiumBadge: false,
          ),
        ],
      ),
    );
  }
}
