import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChronotypeBottomsheet extends StatefulWidget {
  const ChronotypeBottomsheet({super.key});

  @override
  State<ChronotypeBottomsheet> createState() => _ChronotypeBottomsheetState();
}

class _ChronotypeBottomsheetState extends State<ChronotypeBottomsheet> {
  late String selectedTitle;
  late final BaselineSetupController controller;

  final List<Map<String, String>> options = [
    {
      'title': 'Early Bird',
      'range': '5am – 9pm',
      'value': BaselineEnums.chronotypeMorning,
    },
    {
      'title': 'Intermediate',
      'range': '7am – 11pm',
      'value': BaselineEnums.chronotypeIntermediate,
    },
    {
      'title': 'Night Owl',
      'range': '10am – 2am',
      'value': BaselineEnums.chronotypeEvening,
    },
    {
      'title': 'Extreme Night Owl',
      'range': '12am – 4am',
      'value': BaselineEnums.chronotypeEvening,
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<BaselineSetupController>();
    final currentEnum = BaselineEnums.normalizeChronotype(
      controller.chronotype.value,
    );
    final matched = options.firstWhere(
      (opt) => opt['value'] == currentEnum,
      orElse: () => options[1],
    );
    selectedTitle = matched['title']!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD5D7DA),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.subtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    IconPath.chronotype,
                    width: 22,
                    height: 22,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Chronotype'.tr,
                style: getTextStyle2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.subtle,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Options List
          Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              final title = opt['title']!;
              final range = opt['range']!;
              final isSelected = selectedTitle == title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTitle = title;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFECFDF5)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : AppColors.borderSoft,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.tr,
                              style: getTextStyle2(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              range.tr,
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF047857)
                                    : AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 22,
                        )
                      else
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Info description text
          Center(
            child: Text(
              'Your chronotype affects when you should ideally sleep and wake.'
                  .tr,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSoft,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          GestureDetector(
            onTap: () {
              final matched = options.firstWhere(
                (opt) => opt['title'] == selectedTitle,
              );
              controller.chronotype.value = matched['value']!;
              Get.back();
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Save'.tr,
                style: getTextStyle2(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cancel Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 36,
              alignment: Alignment.center,
              child: Text(
                'Cancel'.tr,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSoft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
