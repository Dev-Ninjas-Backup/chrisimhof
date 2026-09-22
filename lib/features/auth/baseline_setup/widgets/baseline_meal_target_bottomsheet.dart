import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaselineMealTargetBottomsheet extends StatefulWidget {
  const BaselineMealTargetBottomsheet({super.key});

  @override
  State<BaselineMealTargetBottomsheet> createState() =>
      _BaselineMealTargetBottomsheetState();
}

class _BaselineMealTargetBottomsheetState
    extends State<BaselineMealTargetBottomsheet> {
  late int _selectedCount;
  late final BaselineSetupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BaselineSetupController>();
    _selectedCount = controller.defaultDailyMealTarget.value;
    if (_selectedCount < 1) _selectedCount = 3;
    if (_selectedCount > 8) _selectedCount = 8;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default daily meal target'.tr,
                style: getTextStyle2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.textSoft),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Your circadian day session will automatically initialize with this daily meal count preference (1–8 meals).'
                .tr,
            style: getTextStyle(
              fontSize: 13,
              color: AppColors.textSoft,
            ),
          ),
          const SizedBox(height: 28),

          // Stepper
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_selectedCount > 1) {
                      setState(() {
                        _selectedCount--;
                      });
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSoft),
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Text(
                      '$_selectedCount',
                      style: getTextStyle2(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      _selectedCount == 1 ? 'meal'.tr : 'meals'.tr,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    if (_selectedCount < 8) {
                      setState(() {
                        _selectedCount++;
                      });
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                controller.defaultDailyMealTarget.value = _selectedCount;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save'.tr,
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
