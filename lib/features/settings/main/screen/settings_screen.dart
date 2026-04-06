import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/widget/logout_button.dart';
import 'package:chrisimhof/features/settings/main/widget/profile_cart_widget.dart';
import 'package:chrisimhof/features/settings/main/widget/settings_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 78, left: 16, right: 16),
          child: Column(
            children: [
              CustomAppBar(title: 'Settings', showBackButton: false),
              ProfileCartWidget(),
              SettingsOptionWidget(),
              LogoutButton(),
              GestureDetector(
                onTap: () => Get.offAllNamed('/signInScreen'),
                child: Text(
                  'Delete Account',
                  style: getTextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
