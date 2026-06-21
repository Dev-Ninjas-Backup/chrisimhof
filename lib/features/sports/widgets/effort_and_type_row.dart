import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/widgets/effort_selection_bottomsheet.dart';
import 'package:chrisimhof/features/sports/widgets/type_selection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EffortAndTypeRow extends StatelessWidget {
  final RxString activity;
  final RxString effort;
  final RxString type;

  const EffortAndTypeRow({
    super.key,
    required this.activity,
    required this.effort,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                     Text(
                      'EFFORT'.tr,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B5CF6),
                      ),
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
                     Text(
                      'TYPE'.tr,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B5CF6),
                      ),
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
    });
  }
}
