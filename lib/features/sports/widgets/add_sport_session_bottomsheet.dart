import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/activity_type_selector.dart';
import 'package:chrisimhof/features/sports/widgets/distance_card.dart';
import 'package:chrisimhof/features/sports/widgets/effort_and_type_row.dart';
import 'package:chrisimhof/features/sports/widgets/time_range_selector.dart';
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
            Obx(
              () => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    Get.bottomSheet(ZoneSelectionBottomsheet(zone: zone)),
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
              ),
            ),
            const SizedBox(height: 16),

            // Time range row
            TimeRangeSelector(
              startTime: startTime,
              endTime: endTime,
              onTimeChanged: _updateDuration,
            ),
            const SizedBox(height: 24),

            // Activity Type Section
            // ActivityTypeSelector(
            //   activity: activity,
            //   type: type,
            //   zone: zone,
            //   duration: duration,
            //   onActivityChanged: _updateDuration,
            // ),
            // const SizedBox(height: 24),

            // Distance Section
            DistanceCard(
              activity: activity,
              distanceController: distanceController,
              onDistanceChanged: () => activity.refresh(),
            ),

            // Effort and Type dropdowns
            EffortAndTypeRow(activity: activity, effort: effort, type: type),
            const SizedBox(height: 32),

            // Save Session Button
            CustomButton(
              text: 'SAVE SESSION',
              icon: null,
              backgroundColor: const Color(
                0xFF4C1D95,
              ), // Deep purple matching Figma
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
                  distance: activity.value == 'Rest day'
                      ? null
                      : distanceController.text,
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
