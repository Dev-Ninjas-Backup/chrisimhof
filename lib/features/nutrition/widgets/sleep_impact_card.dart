import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:flutter/material.dart';

class SleepImpactCard extends StatelessWidget {
  const SleepImpactCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blueSoft, // Indigo soft
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: AppColors.indigoSoft),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.indigoSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Image(
                image: AssetImage(IconPath.sleep),
                width: 24,
                height: 24,
                color: AppColors.indigo,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SLEEP IMPACT',
                  style: getTextStyle2(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: getTextStyle2(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:AppColors.textMid,
                    ),
                    children: [
                      const TextSpan(text: 'Keep night meal '),
                      TextSpan(
                        text: 'Light',
                        style: getTextStyle2(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                      const TextSpan(
                        text: ' — Heavy meals after 02:00 reduce deep sleep by ~15%.',
                      ),
                    ],
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
