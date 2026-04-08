import 'package:chrisimhof/features/dashboard/widget/short_cut_button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OptionButtonWidget extends StatelessWidget {
  const OptionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ShortCutButton(icon: Icons.add, onTap: () {}),
          ShortCutButton(icon: Icons.history, onTap: () {}),
          ShortCutButton(icon: Icons.settings, onTap: () {}),
        ],
      ),
    );
  }
}
