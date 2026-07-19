import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/log_sleep_card.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/sleep_debt_card.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/sleep_history_list.dart';
import 'package:chrisimhof/features/dashboard/sleep/widgets/tonight_bedtime_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SleepController controller = Get.find<SleepController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Sleep'.tr,
                showBackButton: true,
                showMoreButton: false,
              ),
              const SizedBox(height: 20),

              LogSleepCard(controller: controller),
              const SizedBox(height: 24),

              const SleepDebtCard(),
              const SizedBox(height: 24),

              const TonightBedtimeCard(),
              const SizedBox(height: 32),

              SleepHistoryList(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
