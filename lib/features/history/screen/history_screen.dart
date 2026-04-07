import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/history/controller/history_controller.dart';
import 'package:chrisimhof/features/history/widget/history_widget.dart';
import 'package:chrisimhof/features/history/widget/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 78,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Column(
          children: [
            CustomAppBar(title: 'History', showBackButton: false),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TabButton(
                      text: 'Recent',
                      isSelected: controller.selectedTab.value == 0,
                      onTap: () => controller.selectTab(0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TabButton(
                      text: 'Past',
                      isSelected: controller.selectedTab.value == 1,
                      onTap: () => controller.selectTab(1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.currentList.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.currentList[index];
                    return HistoryWidget(
                      dateTime: item.dateTime,
                      details: item.details,
                      score: item.score,
                      scoreDetails: item.scoreDetails,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
