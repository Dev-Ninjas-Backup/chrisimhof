import 'package:chrisimhof/core/common/widgets/custom_button2.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/widgets/rhythm_hero.dart';
import 'package:chrisimhof/features/auth/widgets/ryvenza_logo.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authDark,
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.authDark, AppColors.authDarkAlt],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RyvenzaLogo(color: Colors.white),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(0, 8),
                            child: const RyvenzaRhythmHero(),
                          ),
                        ),
                      ),
                      Text(
                        'Your rhythm, rebuilt around real life.'.tr,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                            .tr,
                        style: getTextStyle(
                          color: const Color(0xFFB9C9C3),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 43),
                      CustomAuthButton(
                        text: 'Create account',
                        isMint: true,
                        onTap: () => Get.toNamed(AppRoutes.createAccountScreen),
                      ),
                      const SizedBox(height: 10),
                      CustomSecondaryButton(
                        text: 'Log in',
                        onTap: () => Get.toNamed(AppRoutes.signInScreen),
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
