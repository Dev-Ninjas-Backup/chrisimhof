import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
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
        Text("Last Caffeine Time", style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Obx(
          () => controller.caffeineHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "No caffeine entries yet",
                    style: getTextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(
                    controller.caffeineHistory.length,
                    (index) {
                      final entry = controller.caffeineHistory[index];
                      return Column(
                        children: [
                          _buildItem(
                            entry['name'] ?? '',
                            entry['dose'] ?? '',
                            entry['time'] ?? '',
                          ),
                          if (index < controller.caffeineHistory.length - 1)
                            const Divider(height: 32),
                        ],
                      );
                    },
                  ),
                ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: "+ Add Caffeine",
          onTap: () {
            Get.snackbar(
              'Add Caffeine',
              'Quick entry or manual add',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    );
  }

  Widget _buildItem(String title, String dose, String time) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(dose, style: getTextStyle(fontSize: 14, color: const Color(0xFF6B7280))),
            ],
          ),
        ),
        Text(time, style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF111827)),
      ],
    );
  }
}