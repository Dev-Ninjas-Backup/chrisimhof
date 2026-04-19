import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart'; // CHANGE: add this import
import 'package:chrisimhof/features/settings/main/widget/logout_button.dart';
import 'package:chrisimhof/features/settings/main/widget/profile_cart_widget.dart';
import 'package:chrisimhof/features/settings/main/widget/settings_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 78, left: 16, right: 16),
          child: Column(
            children: [
              CustomAppBar(title: 'Settings'.tr, showBackButton: false),
              ProfileCartWidget(),
              SettingsOptionWidget(),
              LogoutButton(),
              GestureDetector(
                onTap: () => Get.offAllNamed('/signInScreen'),
                child: Text(
                  'Delete Account'.tr,
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
