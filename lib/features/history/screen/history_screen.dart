import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
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
            CustomAppBar(title: 'History'.tr, showBackButton: false),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TabButton(
                      text: 'Recent'.tr,
                      isSelected: controller.selectedTab.value == 0,
                      onTap: () => controller.selectTab(0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TabButton(
                      text: 'Past'.tr,
                      isSelected: controller.selectedTab.value == 1,
                      onTap: () => controller.selectTab(1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.currentList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryButtonColor,
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading history'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.refreshHistory,
                          child: Text('Retry'.tr),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.currentList.isEmpty) {
                  return Center(
                    child: Text(
                      'No history found'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.refreshHistory();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: controller.currentList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.currentList[index];
                      return HistoryWidget(historyItem: item);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
