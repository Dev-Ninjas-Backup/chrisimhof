import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/distance_card.dart';
import 'package:chrisimhof/features/sports/widgets/effort_and_type_row.dart';
import 'package:chrisimhof/features/sports/widgets/time_range_selector.dart';
import 'package:chrisimhof/features/sports/widgets/zone_selection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSportSessionBottomsheet extends StatelessWidget {
  AddSportSessionBottomsheet({
    super.key,
    required this.activity,
    required this.type,
    required this.zone,
    required this.duration,
    required this.effort,
    required this.distanceController,
    required this.startTime,
    required this.endTime,
    Rx<DateTime>? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now().obs;

  final RxString activity;
  final RxString type;
  final RxString zone;
  final RxInt duration;
  final RxString effort;
  final TextEditingController distanceController;
  final RxString startTime;
  final RxString endTime;
  final Rx<DateTime> selectedDate;

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
                  'LOG NEW SESSION'.tr,
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

            // Day selector row (Yesterday / Today / Tomorrow / Other)
            _buildDaySelector(context),
            const SizedBox(height: 16),

            // Time range row
            TimeRangeSelector(
              startTime: startTime,
              endTime: endTime,
              onTimeChanged: _updateDuration,
            ),
            const SizedBox(height: 24),
            // Distance Section
            Obx(() {
              if (type.value.toLowerCase() == 'cardio') {
                return const SizedBox.shrink();
              }
              return DistanceCard(
                activity: activity,
                distanceController: distanceController,
                onDistanceChanged: () => activity.refresh(),
              );
            }),

            // Effort and Type dropdowns
            EffortAndTypeRow(activity: activity, effort: effort, type: type),
            const SizedBox(height: 32),

            // Save Session Button
            CustomButton(
              text: 'SAVE SESSION'.tr,
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
                  selectedDate: selectedDate.value,
                  distance: activity.value == 'Rest day'
                      ? null
                      : distanceController.text,
                );
                Get.back();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    return Obx(() {
      final current = selectedDate.value;
      final isYesterday = isSameDay(current, yesterday);
      final isToday = isSameDay(current, today);
      final isTomorrow = isSameDay(current, tomorrow);
      final isCustom = !isYesterday && !isToday && !isTomorrow;

      final formattedCustom =
          '${current.day}/${current.month}/${current.year}';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAY'.tr,
            style: getTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDayChip(
                label: 'Yesterday'.tr,
                isSelected: isYesterday,
                onTap: () => selectedDate.value = yesterday,
              ),
              const SizedBox(width: 8),
              _buildDayChip(
                label: 'Today'.tr,
                isSelected: isToday,
                onTap: () => selectedDate.value = today,
              ),
              const SizedBox(width: 8),
              _buildDayChip(
                label: 'Tomorrow'.tr,
                isSelected: isTomorrow,
                onTap: () => selectedDate.value = tomorrow,
              ),
              const SizedBox(width: 8),
              _buildCustomDateChip(
                context: context,
                label: isCustom ? formattedCustom : 'Other'.tr,
                isSelected: isCustom,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDayChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4C1D95) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4C1D95)
                  : const Color(0xFFC4B5FD),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4C1D95),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDateChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate.value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          selectedDate.value = date;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4C1D95) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4C1D95)
                : const Color(0xFFC4B5FD),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 14,
              color: isSelected ? Colors.white : const Color(0xFF4C1D95),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
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
