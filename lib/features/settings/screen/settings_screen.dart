import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/settings/widget/profile_cart_widget.dart';
import 'package:flutter/material.dart';

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
              SizedBox(height: 24),
              ProfileCartWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
