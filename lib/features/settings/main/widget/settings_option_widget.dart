import 'package:chrisimhof/features/settings/language/screens/language_screen.dart';
import 'package:chrisimhof/features/settings/main/widget/option_item.dart';
import 'package:chrisimhof/routes/app_routes.dart';
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
            title: 'Subscriptions',
            icon: Icons.attach_money_outlined,
            onTap: () {},
            showPremiumBadge: true,
          ),
          OptionItem(
            title: 'Change Password',
            icon: Icons.notifications_outlined,
            onTap: () {
              Get.toNamed('/changePasswordScreen');
            },
            showPremiumBadge: false,
          ),
          OptionItem(
            title: 'Choose Language',
            icon: Icons.language_outlined,
            onTap: () {
              Get.to(LanguageScreen());
            },
            showPremiumBadge: false,
          ),
        ],
      ),
    );
  }
}
