import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SportProfileBottomsheet extends StatefulWidget {
  const SportProfileBottomsheet({super.key});

  @override
  State<SportProfileBottomsheet> createState() =>
      _SportProfileBottomsheetState();
}

class _SportProfileBottomsheetState extends State<SportProfileBottomsheet> {
  late String selectedTitle;
  late final BaselineSetupController controller;

  final List<Map<String, String>> options = [
    {
      'title': 'Sedentary',
      'desc': 'Little to no exercise',
      'icon': IconPath.sedentary,
      'value': BaselineEnums.sportProfileSedentary,
    },
    {
      'title': 'Lightly active',
      'desc': '1-2x per week',
      'icon': IconPath.lightlyActive,
      'value': BaselineEnums.sportProfileLight,
    },
    {
      'title': 'Cardio',
      'desc': '3-4x per week',
      'icon': IconPath.running,
      'value': BaselineEnums.sportProfileCardio,
    },
    {
      'title': 'Strength',
      'desc': '5-6x per week',
      'icon': IconPath.veryActive,
      'value': BaselineEnums.sportProfileStrength,
    },
    {
      'title': 'Mixed',
      'desc': 'Mixed training',
      'icon': IconPath.running,
      'value': BaselineEnums.sportProfileMixed,
    },
    {
      'title': 'Endurance',
      'desc': 'Intense training daily',
      'icon': IconPath.athlete,
      'value': BaselineEnums.sportProfileEndurance,
    },
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<BaselineSetupController>();
    final currentEnum = BaselineEnums.normalizeSportProfile(
      controller.sportProfile.value,
    );
    final matched = options.firstWhere(
      (opt) => opt['value'] == currentEnum,
      orElse: () => options[2],
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
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 50),
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
                    IconPath.sport_profile,
                    width: 22,
                    height: 22,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Sport profile'.tr,
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
              final desc = opt['desc']!;
              final iconPath = opt['icon']!;
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
                      // Icon circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFD1FAE5)
                              : AppColors.subtle,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            iconPath,
                            width: 20,
                            height: 20,
                            color: isSelected
                                ? const Color(0xFF10B981)
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title and range
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
                              desc.tr,
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
          const SizedBox(height: 24),

          // Save Button
          CustomButton(
            onTap: () {
              final matched = options.firstWhere(
                (opt) => opt['title'] == selectedTitle,
              );
              controller.sportProfile.value = matched['value']!;
              Get.back();
            },
            text: 'Save'.tr,
            icon: null,
          ),
          const SizedBox(height: 16),

          // Cancel Button
          CustomButton(
            text: 'Cancel',
            onTap: Get.back,
            backgroundColor: Colors.transparent,
            borderColor: AppColors.greyMedium,
            textColor: AppColors.primaryTextColor,
            icon: null,
          ),
        ],
      ),
    );
  }
}
