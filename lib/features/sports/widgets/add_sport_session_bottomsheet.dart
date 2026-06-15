import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSportSessionBottomsheet extends StatelessWidget {
  const AddSportSessionBottomsheet({
    super.key,
    required this.activity,
    required this.type,
    required this.zone,
    required this.duration,
    required this.effort,
    required this.distanceController,
    required this.startTime,
    required this.endTime,
  });

  final RxString activity;
  final RxString type;
  final RxString zone;
  final RxInt duration;
  final RxString effort;
  final TextEditingController distanceController;
  final RxString startTime;
  final RxString endTime;

  @override
  Widget build(BuildContext context) {
    final SportsController controller = Get.find<SportsController>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log Sport Session'.tr,
                  style: getTextStyle2(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
    
            // Activity Chip Selector
            Text('Activity'.tr,
                style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryTextColor)),
            const SizedBox(height: 8),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      ['Running', 'Strength', 'Yoga', 'Rest day'].map((act) {
                    final isSelected = activity.value == act;
                    return ChoiceChip(
                      label: Text(act.tr),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          activity.value = act;
                          if (act == 'Rest day') {
                            type.value = 'Rest';
                            zone.value = '';
                          } else if (act == 'Strength') {
                            type.value = 'Strength';
                            zone.value = 'Z2';
                          } else if (act == 'Yoga') {
                            type.value = 'Flexibility';
                            zone.value = 'Z1';
                          } else {
                            type.value = 'Cardio';
                            zone.value = 'Z3';
                          }
                        }
                      },
                      selectedColor:
                          AppColors.primaryButtonColor.withValues(alpha: 0.15),
                      labelStyle: getTextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.mintSoftText
                            : AppColors.primaryTextColor,
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 16),
    
            Obx(() {
              if (activity.value == 'Rest day') return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration Slider & Quick select
                  Text('Duration'.tr,
                      style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: duration.value.toDouble(),
                          min: 5,
                          max: 180,
                          divisions: 35,
                          activeColor: AppColors.primaryButtonColor,
                          label: '${duration.value} min',
                          onChanged: (val) {
                            duration.value = val.round();
                          },
                        ),
                      ),
                      Text('${duration.value} min'.tr,
                          style: getTextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
    
                  // Zone Selection
                  Text('Heart Rate Zone'.tr,
                      style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Z1', 'Z2', 'Z3', 'Z4', 'Z5'].map((z) {
                      final isSelected = zone.value == z;
                      return ChoiceChip(
                        label: Text(z),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) zone.value = z;
                        },
                        selectedColor: AppColors.primaryButtonColor
                            .withValues(alpha: 0.15),
                        labelStyle: getTextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.mintSoftText
                              : AppColors.primaryTextColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
    
                  // Effort Selection
                  Text('Effort'.tr,
                      style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Light', 'Medium', 'High'].map((ef) {
                      final isSelected = effort.value == ef;
                      return ChoiceChip(
                        label: Text(ef.tr),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) effort.value = ef;
                        },
                        selectedColor: AppColors.primaryButtonColor
                            .withValues(alpha: 0.15),
                        labelStyle: getTextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.mintSoftText
                              : AppColors.primaryTextColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
    
                  // Type Selection
                  Text('Type'.tr,
                      style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryTextColor)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Cardio', 'Strength', 'Flexibility'].map((t) {
                      final isSelected = type.value == t;
                      return ChoiceChip(
                        label: Text(t.tr),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) type.value = t;
                        },
                        selectedColor: AppColors.primaryButtonColor
                            .withValues(alpha: 0.15),
                        labelStyle: getTextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.mintSoftText
                              : AppColors.primaryTextColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
    
                  if (activity.value == 'Running') ...[
                    // Distance
                    Text('Distance'.tr,
                        style: getTextStyle2(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryTextColor)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: distanceController,
                      decoration: InputDecoration(
                        hintText: 'e.g. 5.0 km',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            }),
    
            const SizedBox(height: 16),
            CustomButton(
              text: 'Save Session',
              icon: null,
              backgroundColor: AppColors.primaryTextColor,
              textColor: Colors.white,
              onTap: () {
                controller.addSession(
                  activity: activity.value,
                  duration: activity.value == 'Rest day' ? 0 : duration.value,
                  zone: zone.value,
                  startTime: startTime.value,
                  endTime: endTime.value,
                  effort: effort.value,
                  type: type.value,
                  distance: activity.value == 'Running'
                      ? distanceController.text
                      : null,
                );
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
