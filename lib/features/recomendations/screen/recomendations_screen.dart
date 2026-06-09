import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class RecomendationsScreen extends StatelessWidget {
  const RecomendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 50.0),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                showBackButton: false,
                showSettingsButton: false,
                showLogo: false,
                title: 'Recomendations',
                showMoreButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
