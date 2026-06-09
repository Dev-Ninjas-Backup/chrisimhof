import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/recomendations/model/recomendation_model.dart';
import 'package:flutter/material.dart';

class RecomendationCard extends StatelessWidget {
  final RecomendationModel recomendation;
  final VoidCallback onTap;

  const RecomendationCard({
    super.key,
    required this.recomendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = RecomendationStyleHelper.getStyle(recomendation.title);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: AppColors.borderSoft, // #EEF2F0
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container with background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: style.iconBgColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Image.asset(
                  style.iconPath,
                  width: 24,
                  height: 24,
                  color: style.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 16.0),

            // Text Content (Title & Description)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recomendation.title,
                          style: getTextStyle2(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: style.badgeBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            recomendation.count.toString(),
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: style.badgeTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    recomendation.description,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),

            // Notification Badge & Chevron Right Arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.borderColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
