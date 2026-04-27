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
            topTitle.tr,
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
                  topValue: () => ((controller.hour.value - 1 + 24) % 24)
                      .toString()
                      .padLeft(2, '0'),
                  centerValue: () => controller.formattedHour,
                  bottomValue: () => ((controller.hour.value + 1) % 24)
                      .toString()
                      .padLeft(2, '0'),
                  onUpTap: controller.increaseHour,
                  onDownTap: controller.decreaseHour,
                  onVerticalDragUpdate: (details) =>
                      controller.handleHourDrag(details.delta.dy),
                  onVerticalDragEnd: (_) => controller.handleHourDragEnd(),
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
                  topValue: () => ((controller.minute.value - 1 + 60) % 60)
                      .toString()
                      .padLeft(2, '0'),
                  centerValue: () => controller.formattedMinute,
                  bottomValue: () => ((controller.minute.value + 1) % 60)
                      .toString()
                      .padLeft(2, '0'),
                  onUpTap: controller.increaseMinute,
                  onDownTap: controller.decreaseMinute,
                  onVerticalDragUpdate: (details) =>
                      controller.handleMinuteDrag(details.delta.dy),
                  onVerticalDragEnd: (_) => controller.handleMinuteDragEnd(),
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
  final String Function() topValue;
  final String Function() centerValue;
  final String Function() bottomValue;
  final VoidCallback onUpTap;
  final VoidCallback onDownTap;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;

  const _TimePartColumn({
    required this.topValue,
    required this.centerValue,
    required this.bottomValue,
    required this.onUpTap,
    required this.onDownTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onUpTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Obx(
                () => Text(
                  topValue(),
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9AA0A6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Obx(
            () => Text(
              centerValue(),
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onDownTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Obx(
                () => Text(
                  bottomValue(),
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9AA0A6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
