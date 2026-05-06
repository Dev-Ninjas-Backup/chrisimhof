import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:chrisimhof/features/calculator/widgets/add_caffeine.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:get/get.dart';

class CaffeineHistoryList extends StatelessWidget {
  const CaffeineHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Caffeine Time".tr,
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(
          () => controller.caffeineHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "No caffeine entries yet".tr,
                    style: getTextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(controller.caffeineHistory.length, (
                    index,
                  ) {
                    final entry = controller.caffeineHistory[index];
                    return Column(
                      children: [
                        _buildItem(entry, index, controller),
                        if (index < controller.caffeineHistory.length - 1)
                          const Divider(height: 32),
                      ],
                    );
                  }),
                ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: "+ Add Caffeine".tr,
          onTap: () {
            controller.resetAddCaffeineForm();
            Get.bottomSheet(
              const AddCaffeineBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
        ),
      ],
    );
  }

  Widget _buildItem(
    Map<String, dynamic> entry,
    int index,
    CalculatorController controller,
  ) {
    final title = (entry['name'] ?? '') as String;
    final dose = (entry['dose'] ?? '') as String;
    final rawTime = (entry['time'] ?? '') as String;
    final isFromLatest = (entry['isFromLatest'] == true);
    final time = rawTime == 'Now' ? 'Now'.tr : rawTime;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _displayDrinkName(title),
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                dose,
                style: getTextStyle(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        if (isFromLatest)
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () => controller.removeCaffeineEntry(index),
          )
        else
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF111827),
          ),
      ],
    );
  }

  String _displayDrinkName(String title) {
    final idx = title.indexOf('(');
    if (idx == -1) return title.trim();
    return title.substring(0, idx).trim();
  }
}
