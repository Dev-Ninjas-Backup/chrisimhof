import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/widgets/distance_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceCard extends StatelessWidget {
  final RxString activity;
  final TextEditingController distanceController;
  final VoidCallback onDistanceChanged;

  const DistanceCard({
    super.key,
    required this.activity,
    required this.distanceController,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (activity.value == 'Rest day') return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.dialog(
              DistanceInputDialog(
                distanceController: distanceController,
                onSave: onDistanceChanged,
              ),
            ),
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
    });
  }
}
