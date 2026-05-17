import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HydrationHistoryList extends StatelessWidget {
  final CalculatorController controller;

  const HydrationHistoryList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hydration Entries'.tr,
            style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.hydrationEntries.isEmpty) {
              return Text(
                'No hydration entries yet'.tr,
                style: getTextStyle(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              );
            }

            return Column(
              children: List.generate(controller.hydrationEntries.length, (
                index,
              ) {
                final entry = controller.hydrationEntries[index];
                final amount =
                    (entry['amountL'] as num?)?.toDouble() ??
                    double.tryParse(entry['amountL']?.toString() ?? '') ??
                    0.0;
                final label = entry['label']?.toString() ?? 'Water';
                final loggedAt = entry['loggedAt']?.toString() ?? '';

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label.tr,
                                style: getTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_formatLiters(amount)} L',
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (loggedAt.isNotEmpty)
                          Text(
                            loggedAt,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              controller.removeHydrationEntry(index),
                        ),
                      ],
                    ),
                    if (index < controller.hydrationEntries.length - 1)
                      const Divider(height: 24),
                  ],
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

String _formatLiters(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
