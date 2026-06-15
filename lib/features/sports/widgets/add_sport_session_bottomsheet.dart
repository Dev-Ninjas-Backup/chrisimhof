import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/distance_input_dialog.dart';
import 'package:chrisimhof/features/sports/widgets/effort_selection_bottomsheet.dart';
import 'package:chrisimhof/features/sports/widgets/type_selection_bottomsheet.dart';
import 'package:chrisimhof/features/sports/widgets/zone_selection_bottomsheet.dart';
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
        color: Color(0xFFEDE9FE), // Soft purple background matching figma
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOG NEW SESSION',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4C1D95),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Color(0xFF4C1D95),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Large Duration and Zone Selector (Interactive)
            Obx(() => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.bottomSheet(ZoneSelectionBottomsheet(zone: zone)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${duration.value}',
                    style: getTextStyle2(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4C1D95),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'min · ${zone.value}',
                    style: getTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4C1D95),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),

            // Time range row
            Obx(() => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, startTime),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'START',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            startTime.value,
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
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 16,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, endTime),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'END',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            endTime.value,
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
                ),
              ],
            )),
            const SizedBox(height: 24),

            // Activity Type Section
            const Text(
              'ACTIVITY TYPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Running', 'Cycling', 'Swimming', 'Walking', 'Rest day'].map((act) {
                  final isSelected = activity.value == act;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(act.tr),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          activity.value = act;
                          if (act == 'Rest day') {
                            type.value = 'Rest';
                            zone.value = '';
                            duration.value = 0;
                          } else if (act == 'Cycling') {
                            type.value = 'Cardio';
                            zone.value = 'Z2';
                            _updateDuration();
                          } else if (act == 'Swimming') {
                            type.value = 'Cardio';
                            zone.value = 'Z3';
                            _updateDuration();
                          } else if (act == 'Walking') {
                            type.value = 'Cardio';
                            zone.value = 'Z1';
                            _updateDuration();
                          } else {
                            type.value = 'Cardio';
                            zone.value = 'Z3';
                            _updateDuration();
                          }
                        }
                      },
                      selectedColor: const Color(0xFF4C1D95),
                      backgroundColor: Colors.white.withValues(alpha: 0.6),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                      labelStyle: getTextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF4C1D95),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),
            const SizedBox(height: 24),

            // Distance Section
            Obx(() {
              if (activity.value == 'Rest day') return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.dialog(DistanceInputDialog(distanceController: distanceController)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DISTANCE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            distanceController.text.isEmpty ? '—' : distanceController.text,
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
                  const SizedBox(height: 24),
                ],
              );
            }),

            // Effort and Type dropdowns
            Obx(() {
              if (activity.value == 'Rest day') return const SizedBox.shrink();
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.bottomSheet(EffortSelectionBottomsheet(effort: effort)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EFFORT',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8B5CF6)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              effort.value,
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
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.bottomSheet(TypeSelectionBottomsheet(type: type)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TYPE',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8B5CF6)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              type.value,
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
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),

            // Save Session Button
            CustomButton(
              text: 'SAVE SESSION',
              icon: null,
              backgroundColor: const Color(0xFF4C1D95), // Deep purple matching Figma
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
                  distance: activity.value == 'Rest day' ? null : distanceController.text,
                );
                Get.back();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Time Picker Helper
  Future<void> _pickTime(BuildContext context, RxString timeField) async {
    final currentParts = timeField.value.split(':');
    final currentHour = currentParts.isNotEmpty ? int.tryParse(currentParts[0]) ?? 12 : 12;
    final currentMinute = currentParts.length > 1 ? int.tryParse(currentParts[1]) ?? 0 : 0;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
    );
    if (picked != null) {
      final formattedHour = picked.hour.toString().padLeft(2, '0');
      final formattedMinute = picked.minute.toString().padLeft(2, '0');
      timeField.value = '$formattedHour:$formattedMinute';
      _updateDuration();
    }
  }

  // Calculate duration automatically based on start and end time
  void _updateDuration() {
    try {
      final startParts = startTime.value.split(':');
      final endParts = endTime.value.split(':');
      if (startParts.length == 2 && endParts.length == 2) {
        final sh = int.tryParse(startParts[0]) ?? 0;
        final sm = int.tryParse(startParts[1]) ?? 0;
        final eh = int.tryParse(endParts[0]) ?? 0;
        final em = int.tryParse(endParts[1]) ?? 0;

        int startMins = sh * 60 + sm;
        int endMins = eh * 60 + em;
        int diff = endMins - startMins;
        if (diff < 0) {
          diff += 24 * 60; // handle overnight sessions
        }
        duration.value = diff;
      }
    } catch (e) {
      // ignore
    }
  }
}
