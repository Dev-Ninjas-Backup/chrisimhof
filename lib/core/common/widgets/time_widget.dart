import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeWidget extends StatelessWidget {
  final String topTitle;
  final TimeController controller;

  const TimeWidget({
    super.key,
    required this.topTitle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,

      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topTitle,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _TimePartColumn(
                  onUpTap: controller.increaseHour,
                  onDownTap: controller.decreaseHour,
                  child: Obx(
                    () => Text(
                      controller.formattedHour,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: getTextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ),
              Expanded(
                child: _TimePartColumn(
                  onUpTap: controller.increaseMinute,
                  onDownTap: controller.decreaseMinute,
                  child: Obx(
                    () => Text(
                      controller.formattedMinute,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _TimePartColumn(
                  onUpTap: controller.togglePeriod,
                  onDownTap: controller.togglePeriod,
                  child: Obx(
                    () => Text(
                      controller.period.value,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimePartColumn extends StatelessWidget {
  final VoidCallback onUpTap;
  final VoidCallback onDownTap;
  final Widget child;

  const _TimePartColumn({
    required this.onUpTap,
    required this.onDownTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ArrowButton(icon: Icons.keyboard_arrow_up_rounded, onTap: onUpTap),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 10),
        _ArrowButton(icon: Icons.keyboard_arrow_down_rounded, onTap: onDownTap),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 32, color: AppColors.secondaryTextColor),
      ),
    );
  }
}
