import 'package:chrisimhof/core/common/controller/range_slider_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/common/widgets/custom_range_slider.dart';
import 'package:chrisimhof/core/common/widgets/custom_text_form_field.dart';
import 'package:chrisimhof/core/common/widgets/time_widget.dart';
// import 'package:chrisimhof/features/calculator/widgets/nap_entry_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorSleepWidget extends StatelessWidget {
  CalculatorSleepWidget({super.key});

  final TimeController wakeUpController = Get.put(
    TimeController(),
    tag: 'wake_up',
  );

  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeWidget(topTitle: 'Wake-up-Time', controller: wakeUpController),
        SizedBox(height: 16),
        CustomRangeSlider(
          headerText: 'Sleep Last Night (h)',
          controller: RangeSliderController(initialValue: 8),
        ),
         SizedBox(height: 16),
         CustomRangeSlider(
          headerText: 'Sleep Goal (h)',
          controller: RangeSliderController(initialValue: 8),
        ),
         SizedBox(height: 100),
         TimeWidget(topTitle: 'Desired Sleep Start', controller: wakeUpController),
        SizedBox(height: 16),
        TimeWidget(topTitle: 'Desired Sleep Start', controller: wakeUpController),
        SizedBox(height: 16),
       Row(children: [
         Text("Nap 1#?"),
      
       ],),
       const SizedBox(height: 34),
          CustomTextFormField(
            label: "Desired Nap Duration (min)",
            hintText: "Enter Duration",
            isRequired: true,
            controller: durationController,
            keyboardType: TextInputType.number,
          ),
        SizedBox(height: 40),
        TimeWidget(topTitle: 'Preferred time *', controller: wakeUpController),
         SizedBox(height: 48),
         CustomButton(
            text: "Next",
            onTap: () {},
            width: double.infinity,
          ),
          SizedBox(height: 133),
         CustomButton(
            text: "Next",
            onTap: () {},
            width: double.infinity,
          ),
          SizedBox(height: 16),
         CustomButton(
            text: "Reset",
            onTap: () {},
            width: double.infinity,
            backgroundColor: Color(0xFFF3F4F6),
          ),
      ],
    );
  }
}
