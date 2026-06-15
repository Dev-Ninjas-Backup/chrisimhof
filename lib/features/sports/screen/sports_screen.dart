import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SportsController controller = Get.put(SportsController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: 'Sport'.tr,
                showBackButton: true,
                showMoreButton: true,
              ),
              const SizedBox(height: 28),

              // TODAY'S SESSION CARD
              Obx(() {
                if (!controller.hasTodaySession.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE8FF),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S SESSION".tr,
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6D28D9),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          "Rest Day".tr,
                          style: getTextStyle2(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "No active workout session logged today.".tr,
                          style: getTextStyle(
                            fontSize: 13,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final parts = <String>[];
                parts.add(controller.todaySport.value.tr);
                if (controller.todayDistance.value.isNotEmpty) {
                  parts.add(controller.todayDistance.value);
                }
                if (controller.todayStartTime.value.isNotEmpty &&
                    controller.todayEndTime.value.isNotEmpty) {
                  parts.add(
                      '${controller.todayStartTime.value} → ${controller.todayEndTime.value}');
                }
                final infoText = parts.join(' · ');

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE8FF),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TODAY'S SESSION".tr,
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6D28D9),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${controller.todayDuration.value}',
                            style: getTextStyle2(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4C1D95),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'min · ${controller.todayZone.value}'.tr,
                            style: getTextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4C1D95),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        infoText,
                        style: getTextStyle(
                          fontSize: 13,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EFFORT'.tr,
                                    style: getTextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7C3AED),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    controller.todayEffort.value.tr,
                                    style: getTextStyle2(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF4C1D95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TYPE'.tr,
                                    style: getTextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF7C3AED),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    controller.todayType.value.tr,
                                    style: getTextStyle2(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF4C1D95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20.0),

              // RECOVERY IMPACT CARD
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: AppColors.borderSoft),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECOVERY IMPACT'.tr,
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const Icon(
                            Icons.favorite,
                            color: AppColors.rose,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${controller.recoveryScore.value}',
                                  style: getTextStyle2(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.rose,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: getTextStyle2(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.rose,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: controller.recoveryScore.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFF97316), // Orange
                                                Color(0xFFEF4444), // Red/Rose
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            100 - controller.recoveryScore.value,
                                        child: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  controller.recoveryText.value.tr,
                                  style: getTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20.0),

              // LOG A NEW SESSION BUTTON
              CustomButton(
                text: 'Log a new session',
                plusIcon: true,
                showIcon: Icons.add,
                icon: null,
                backgroundColor: AppColors.primaryTextColor,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () => showLogSessionBottomSheet(context, controller),
              ),
              const SizedBox(height: 28.0),

              // THIS WEEK HEADER
              Text(
                'THIS WEEK'.tr,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12.0),

              // THIS WEEK LIST
              Obx(() {
                return Column(
                  children: controller.sessionsList.map((session) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: AppColors.borderSoft),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                session.iconPath,
                                width: 20,
                                height: 20,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.directions_run,
                                  size: 20,
                                  color: AppColors.textSoft,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.title.tr,
                                    style: getTextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    session.subtitle.tr,
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSoft,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void showLogSessionBottomSheet(
      BuildContext context, SportsController controller) {
    final activity = 'Running'.obs;
    final duration = 30.obs;
    final zone = 'Z3'.obs;
    final effort = 'Medium'.obs;
    final type = 'Cardio'.obs;
    final distanceController = TextEditingController(text: '5.0 km');
    final startTime = '08:00'.obs;
    final endTime = '08:30'.obs;

    Get.bottomSheet(
      Container(
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
                          style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
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
      ),
      isScrollControlled: true,
    );
  }
}