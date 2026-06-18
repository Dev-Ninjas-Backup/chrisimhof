import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeSelectionBottomsheet extends StatelessWidget {
  final RxString type;

  const TypeSelectionBottomsheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final options = ['cardio', 'strength', 'mobility', 'mixed', 'other'];
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
            'Select Type',
            style: getTextStyle2(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((opt) {
            final isSelected = type.value == opt;
            return GestureDetector(
              onTap: () {
                type.value = opt;
                Get.back();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFD),
                  borderRadius: BorderRadius.circular(12.0),
                  border: isSelected ? Border.all(color: const Color(0xFF10B981)) : null,
                ),
                child: Text(
                  opt,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF059669) : const Color(0xFF4C1D95),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
