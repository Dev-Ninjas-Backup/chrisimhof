import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/auth/widgets/ryvenza_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
export 'package:chrisimhof/features/auth/widgets/ryvenza_top_bar.dart';
export 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
export 'package:chrisimhof/features/auth/widgets/ryvenza_logo.dart';
export 'package:chrisimhof/features/auth/widgets/rhythm_hero.dart';
export 'package:chrisimhof/features/auth/widgets/ryvenza_text_field.dart';
export 'package:chrisimhof/features/auth/widgets/ryvenza_buttons.dart';
export 'package:chrisimhof/features/auth/widgets/auth_divider.dart';
export 'package:chrisimhof/features/auth/widgets/social_button.dart';
export 'package:chrisimhof/features/auth/widgets/privacy_by_design_card.dart';

class RyvenzaAuthScaffold extends StatelessWidget {
  const RyvenzaAuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            RyvenzaTopBar(title: title, showBackButton: showBackButton),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle.tr,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        height: 1.45,
                        color: AppColors.textSoft,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 26),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
