import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityTypeSelector extends StatelessWidget {
  final RxString activity;
  final RxString type;
  final RxString zone;
  final RxInt duration;
  final VoidCallback onActivityChanged;

  const ActivityTypeSelector({
    super.key,
    required this.activity,
    required this.type,
    required this.zone,
    required this.duration,
    required this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      } else {
                        type.value = 'Cardio';
                        if (act == 'Cycling') {
                          zone.value = 'Z2';
                        } else if (act == 'Swimming') {
                          zone.value = 'Z3';
                        } else if (act == 'Walking') {
                          zone.value = 'Z1';
                        } else {
                          zone.value = 'Z3';
                        }
                        onActivityChanged();
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
      ],
    );
  }
}
