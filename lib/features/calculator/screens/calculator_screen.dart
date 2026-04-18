import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_sleep_widget.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_tab_button.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_work_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 78,
            left: 16,
            right: 16,
            bottom: 34,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(title: 'Calculator', showBackButton: true),
              const SizedBox(height: 24),

              /// ✅ Tabs
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.tabs.length,
                      (index) => CalculatorTabButton(
                        title: controller.tabs[index],
                        isActive: controller.selectedTabIndex.value == index,
                        onTap: () => controller.changeTab(index),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Obx(() {
                switch (controller.selectedTabIndex.value) {
                  case 0:
                    return CalculatorSleepWidget();

                  case 1:
                    return CalculatorWorkWidget();

                  case 2:
                    return const _SimpleTabWidget(title: "Nutrition Widget");

                  case 3:
                    return const _SimpleTabWidget(title: "Hydration Widget");

                  case 4:
                    return const _SimpleTabWidget(title: "Caffeine Widget");

                  case 5:
                    return const _SimpleTabWidget(title: "Sport Widget");

                  default:
                    return const SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleTabWidget extends StatelessWidget {
  final String title;

  const _SimpleTabWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
