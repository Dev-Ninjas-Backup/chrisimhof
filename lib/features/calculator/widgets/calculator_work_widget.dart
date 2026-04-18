import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorWorkWidget extends StatelessWidget {
  CalculatorWorkWidget({super.key});

  final TimeController workBeginsController = Get.put(
    TimeController(),
    tag: 'work_begins',
  );
  final TimeController workCompleteController = Get.put(
    TimeController(),
    tag: 'work_complete',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeWidget(topTitle: 'Work Begins', controller: workBeginsController),
        SizedBox(height: 16),
        TimeWidget(
          topTitle: 'Work Complete',
          controller: workCompleteController,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: CustomButton(text: 'Next', onTap: () {}),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TabButton(text: 'Skip', onTap: () {}),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TabButton(text: 'Reset', onTap: () {}),
            ),
          ],
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const TabButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}
