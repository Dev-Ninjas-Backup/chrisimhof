import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_caffeine_tab.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_nutrition_tab.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_sport_tab.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_hydration_tab.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_sleep_tab.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_tab_button.dart';
import 'package:chrisimhof/features/calculator/widgets/calculator_tab_swipe_detector.dart';
import 'package:chrisimhof/features/calculator/calculator_tabs/calculator_work_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});

  final CalculatorController controller =
      Get.isRegistered<CalculatorController>()
      ? Get.find<CalculatorController>()
      : Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    controller.handleCalculatorScreenEntered();

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          controller.handleCalculatorScreenExited();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 78,
              left: 16,
              right: 16,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Calculator'.tr, showBackButton: true),
                const SizedBox(height: 24),

                /// ✅ Tabs
                Obx(() {
                  controller.scrollToActiveTab(
                    controller.selectedTabIndex.value,
                  );

                  return SingleChildScrollView(
                    controller: controller.tabScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        controller.tabs.length,
                        (index) => CalculatorTabButton(
                          key: controller.tabKeys[index],
                          title: controller.tabs[index].tr,
                          isActive: controller.selectedTabIndex.value == index,
                          onTap: () async {
                            await controller.requestTabChange(index);
                          },
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                Obx(() {
                  final currentIndex = controller.selectedTabIndex.value;
                  final slideDirection = controller.tabTransitionDirection.value
                      .toDouble();

                  return CalculatorTabSwipeDetector(
                    onSwipeLeft: () {
                      controller.requestTabChange(currentIndex + 1);
                    },
                    onSwipeRight: () {
                      controller.requestTabChange(currentIndex - 1);
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      reverseDuration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final isIncoming = child.key == ValueKey(currentIndex);
                        final beginOffset = isIncoming
                            ? Offset(slideDirection * 0.16, 0)
                            : Offset(slideDirection * -0.08, 0);

                        return ClipRect(
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: beginOffset,
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            ...previousChildren,
                            ...(currentChild != null
                                ? [currentChild]
                                : const <Widget>[]),
                          ],
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(currentIndex),
                        child: switch (currentIndex) {
                          0 => CalculatorSleepTab(),
                          1 => CalculatorWorkTab(),
                          2 => const CalculatorNutritionTab(),
                          3 => const CalculatorHydrationTab(),
                          4 => const CalculatorCaffeineTab(),
                          5 => const CalculatorSportTab(),
                          _ => const SizedBox(),
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _SimpleTabWidget extends StatelessWidget {
//   final String title;

//   const _SimpleTabWidget({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Center(
//         child: Text(
//           title,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }
