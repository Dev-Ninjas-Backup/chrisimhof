import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfWorkouts extends StatelessWidget {
  const ListOfWorkouts({
    super.key,
    required this.controller,
  });

  final SportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: controller.sessionsList.map((session) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      session.iconPath,
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.directions_run,
                        size: 20,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title.tr,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          session.subtitle.tr,
                          style: getTextStyle2(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSoft,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
