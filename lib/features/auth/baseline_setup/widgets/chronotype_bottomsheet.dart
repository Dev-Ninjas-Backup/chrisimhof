import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChronotypeBottomsheet extends StatefulWidget {
  const ChronotypeBottomsheet({super.key});

  @override
  State<ChronotypeBottomsheet> createState() => _ChronotypeBottomsheetState();
}

class _ChronotypeBottomsheetState extends State<ChronotypeBottomsheet> {
  late String selectedValue;
  late final BaselineSetupController controller;

  bool get _is24Hour {
    if (Get.isRegistered<SettingsController>()) {
      return Get.find<SettingsController>().timeFormat.value != '12h';
    }
    return controller.timeFormat.value != '12h';
  }

  List<Map<String, String>> _getOptions(bool is24h) {
    return [
      {
        'title': 'Early Bird',
        'range': is24h ? '05:00 - 21:00' : '5am - 9pm',
        'value': BaselineEnums.chronotypeMorning,
      },
      {
        'title': 'Intermediate',
        'range': is24h ? '07:00 - 23:00' : '7am - 11pm',
        'value': BaselineEnums.chronotypeIntermediate,
      },
      {
        'title': 'Night Owl',
        'range': is24h ? '10:00 - 02:00' : '10am - 2am',
        'value': BaselineEnums.chronotypeEvening,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<BaselineSetupController>();
    selectedValue = BaselineEnums.normalizeChronotype(
      controller.chronotype.value,
    );
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
          Builder(
            builder: (context) {
              final options = _getOptions(_is24Hour);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((opt) {
                  final String title = opt['title']!;
                  final String range = opt['range']!;
                  final String value = opt['value']!;
                  final isSelected = selectedValue == value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = value;
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
              );
            },
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

          CustomButton(
            text: 'Save'.tr,
            onTap: () {
              controller.chronotype.value = selectedValue;
              Get.back();
            },
            icon: null,
            textColor: AppColors.white,
          ),

          const SizedBox(height: 16),

          CustomButton(
            text: 'Cancel'.tr,
            onTap: () => Get.back(),
            backgroundColor: AppColors.transparent,
            textColor: AppColors.secondaryTextColor,
            icon: null,
          ),
        ],
      ),
    );
  }
}
