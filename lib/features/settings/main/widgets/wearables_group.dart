import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WearablesGroup extends StatelessWidget {
  const WearablesGroup();

  @override
  Widget build(BuildContext context) {
    const List<({String label, String sublabel})> rows = [
      (label: 'Apple Health', sublabel: 'Sync sleep + workouts'),
      (label: 'Garmin', sublabel: 'Auto-import HR and sleep'),
      (label: 'Google Health Connect', sublabel: 'Android health hub'),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.borderColor,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          return Opacity(
            opacity: 0.65,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                border: index < rows.length - 1
                    ? const Border(
                        bottom: BorderSide(color: AppColors.borderSoft),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.subtle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.watch_outlined,
                      color: AppColors.textMid,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label.tr,
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          row.sublabel.tr,
                          style: GoogleFonts.manrope(
                            color: AppColors.textSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Later'.tr,
                    style: GoogleFonts.manrope(
                      color: AppColors.textSoft,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
