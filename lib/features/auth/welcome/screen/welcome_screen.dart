import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/auth/widgets/ryvenza_auth_widgets.dart';
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const RyvenzaLogo(color: Colors.white),
                      Expanded(
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
                          fontSize: 34,
                          height: 1.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const SizedBox(height: 12),
                      // Text(
                      //   'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                      //       .tr,
                      //   style: GoogleFonts.manrope(
                      //     color: const Color(0xFFB9C9C3),
                      //     fontSize: 14,
                      //     height: 1.55,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  22 + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sleep, caffeine, hydration, meals and work shifts in one adaptive daily plan.'
                          .tr,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFFB9C9C3),
                        fontSize: 14,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
