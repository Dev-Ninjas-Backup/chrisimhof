import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceInputDialog extends StatelessWidget {
  final TextEditingController distanceController;
  final VoidCallback? onSave;

  const DistanceInputDialog({
    super.key,
    required this.distanceController,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: distanceController.text);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Enter Distance',
        style: getTextStyle2(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4C1D95),
        ),
      ),
      content: TextField(
        controller: textController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          hintText: 'e.g. 6.8 km',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: getTextStyle(color: AppColors.textSoft)),
        ),
        TextButton(
          onPressed: () {
            distanceController.text = textController.text;
            if (onSave != null) {
              onSave!();
            }
            Get.back();
          },
          child: const Text(
            'Save',
            style: TextStyle(
              color: Color(0xFF4C1D95),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
