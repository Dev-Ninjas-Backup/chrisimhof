import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/calculator/models/activity_type_enum.dart';
import 'package:flutter/material.dart';

class ActivityTypeSelector extends StatelessWidget {
  final String selectedActivity;
  final Function(String) onSelect;

  const ActivityTypeSelector({
    super.key,
    required this.selectedActivity,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> activities = [
      ActivityType.walk,
      ActivityType.run,
      ActivityType.cycle,
      ActivityType.gym,
      ActivityType.rest,
      ActivityType.sport,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Activity Type",
          style: getTextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: activities.map((activity) {
              final bool isSelected = activity.displayName == selectedActivity;
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onSelect(activity.displayName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 32.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryButtonColor
                          : const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10000.0),
                    ),
                    child: Text(
                      activity.displayName,
                      style: getTextStyle(
                        color: AppColors.primaryTextColor,
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
