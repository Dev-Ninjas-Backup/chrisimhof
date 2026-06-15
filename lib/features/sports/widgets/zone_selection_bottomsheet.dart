import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneSelectionBottomsheet extends StatelessWidget {
  final RxString zone;

  const ZoneSelectionBottomsheet({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    final tempZone = zone.value.obs;
    final zones = ['Z1', 'Z2', 'Z3', 'Z4', 'Z5'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heart Rate Zone',
            style: getTextStyle2(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: zones.map((z) {
              final isSelected = tempZone.value == z;
              return ChoiceChip(
                label: Text(z),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) tempZone.value = z;
                },
                selectedColor: const Color(0xFF4C1D95).withValues(alpha: 0.15),
                labelStyle: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF4C1D95) : AppColors.primaryTextColor,
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Save Details',
            icon: null,
            backgroundColor: const Color(0xFF4C1D95),
            textColor: Colors.white,
            onTap: () {
              zone.value = tempZone.value;
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
