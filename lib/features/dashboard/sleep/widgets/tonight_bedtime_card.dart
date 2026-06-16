import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';

class TonightBedtimeCard extends StatelessWidget {
  const TonightBedtimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white, width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blueSoft,
            AppColors.mintSoft2,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.indigo,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TONIGHT\'S BEDTIME',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.indigo,
                  ).copyWith(letterSpacing: 1.1),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '22:48',
                      style: getTextStyle2(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: AppColors.selectionGray,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '06:18',
                      style: getTextStyle2(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Adjusted for your 22:00 shift start tomorrow.\nTargets 7h 30m.',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
