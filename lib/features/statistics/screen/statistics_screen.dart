import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 50.0),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                showBackButton: false,
                showSettingsButton: false,
                showLogo: false,
                title: 'Statistics',
                showMoreButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
