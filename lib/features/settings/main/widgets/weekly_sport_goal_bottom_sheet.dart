import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklySportGoalBottomSheet extends StatefulWidget {
  final SettingsController controller;

  const WeeklySportGoalBottomSheet({super.key, required this.controller});

  @override
  State<WeeklySportGoalBottomSheet> createState() =>
      _WeeklySportGoalBottomSheetState();
}

class _WeeklySportGoalBottomSheetState
    extends State<WeeklySportGoalBottomSheet> {
  late int _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.controller.weeklySportGoal.value;
    if (_selectedGoal < 1) _selectedGoal = 3;
    if (_selectedGoal > 7) _selectedGoal = 7;
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
                'Weekly workout goal'.tr,
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
            'Target number of workout sessions per week (1–7). Ryvenza uses this to balance workout pacing and adaptive rest.'
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
                    if (_selectedGoal > 1) {
                      setState(() {
                        _selectedGoal--;
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
                      '$_selectedGoal',
                      style: getTextStyle2(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Text(
                      _selectedGoal == 1
                          ? 'workout / week'.tr
                          : 'workouts / week'.tr,
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
                    if (_selectedGoal < 7) {
                      setState(() {
                        _selectedGoal++;
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
              onPressed: () async {
                Navigator.of(context).pop();
                await widget.controller.updateWeeklySportGoal(_selectedGoal);
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
