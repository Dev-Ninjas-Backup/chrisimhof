import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorSleepWidget extends StatelessWidget {
  CalculatorSleepWidget({super.key});

  final TimeController wakeUpController = Get.put(
    TimeController(),
    tag: 'wake_up',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeWidget(topTitle: 'Wake-up-Time', controller: wakeUpController),
        SizedBox(height: 16),
        CustomRangeSlider(headerText: 'Sleep Last Night (h) ', currentValue: 8, onChanged: (double p1) {  }),
         SizedBox(height: 16),
        CustomRangeSlider(headerText: 'Sleep Goal (h) ', currentValue: 5, onChanged: (double p1) {  }),
         SizedBox(height: 100),
         TimeWidget(topTitle: 'Desired Sleep Start', controller: wakeUpController),
        SizedBox(height: 16),
        TimeWidget(topTitle: 'Desired Sleep Start', controller: wakeUpController),
        SizedBox(height: 16),

      ],
    );
  }
}
