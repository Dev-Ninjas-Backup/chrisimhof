import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/controller/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/features/calculator/models/activity_type_enum.dart';

class SportActivityList extends StatelessWidget {
  const SportActivityList({super.key});

  String _displayName(String apiValue) {
    if (apiValue.isEmpty) return '';
    try {
      return ActivityType.fromApiValue(apiValue).displayName;
    } catch (_) {
      // try to match by display name
      for (final t in ActivityType.values) {
        if (t.displayName.toLowerCase() == apiValue.toLowerCase()) {
          return t.displayName;
        }
      }
      // fallback: prettify
      final s = apiValue.toLowerCase();
      return s[0].toUpperCase() + s.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Activity Time".tr,
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Obx(
          () => controller.sportActivities.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "No activity entries yet".tr,
                    style: getTextStyle(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(controller.sportActivities.length, (
                    index,
                  ) {
                    final entry = controller.sportActivities[index];
                    final type = entry['activityType']?.toString() ?? '';
                    final duration = entry['durationMin']?.toString() ?? '0';
                    final display = _displayName(type);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    display,
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${duration} min',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Color(0xFF111827),
                            ),
                          ],
                        ),
                        if (index < controller.sportActivities.length - 1)
                          const Divider(height: 32),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }
}
