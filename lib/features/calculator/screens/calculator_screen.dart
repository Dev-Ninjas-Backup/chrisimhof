import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_tab_button.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
