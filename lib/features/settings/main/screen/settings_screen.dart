import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/common/widgets/custom_button2.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:chrisimhof/features/settings/change_password/screen/change_password_screen.dart';
import 'package:chrisimhof/features/settings/edit_profile/screen/edit_profile_screen.dart';
import 'package:chrisimhof/features/settings/language/screens/language_screen.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/settings/main/widgets/profile_card.dart';
import 'package:chrisimhof/features/settings/main/widgets/settings_group.dart';
import 'package:chrisimhof/features/settings/main/widgets/settings_top_bar.dart';
import 'package:chrisimhof/features/settings/main/widgets/section_header_with_badge.dart';
import 'package:chrisimhof/features/settings/main/widgets/wearables_group.dart';
import 'package:chrisimhof/features/settings/subscriptions/screen/subscriptions_screen.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            kNavBarTotalHeight + 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsTopBar(),
              ProfileCard(controller: controller),
              sectionLabel('Account'),
              SettingsGroup(
                rows: [
                  SettingsRowData(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit profile',
                    onTap: () {
                      final String name = controller.fullName.value.isNotEmpty
                          ? controller.fullName.value
                          : 'User Name'.tr;
                      Get.to(
                        () => EditProfileScreen(name: name),
                        arguments: {
                          'name': name,
                          'bio': controller.bio.value,
                          'avatarUrl': controller.avatarUrl.value,
                        },
                      );
                    },
                  ),
                  const SettingsRowData(
                    icon: Icons.business_center_outlined,
                    label: 'Work schedule',
                    trailing: 'Soon',
                  ),
                  SettingsRowData(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change password',
                    onTap: () => Get.to(() => ChangePasswordScreen()),
                  ),
                  SettingsRowData(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    trailing: Get.locale?.languageCode == 'fr'
                        ? 'Français'
                        : 'English',
                    onTap: () => Get.to(() => LanguageScreen()),
                  ),
                ],
              ),
              sectionLabel('Baseline profile'),
              SettingsGroup(
                accent: true,
                rows: const [
                  SettingsRowData(
                    icon: Icons.dark_mode_outlined,
                    label: 'Sleep target',
                    trailing: '7h 45m',
                  ),
                  SettingsRowData(
                    icon: Icons.psychology_outlined,
                    label: 'Chronotype',
                    trailing: 'Evening leaning',
                  ),
                  SettingsRowData(
                    icon: Icons.local_cafe_outlined,
                    label: 'Caffeine sensitivity',
                    trailing: 'Medium',
                  ),
                  SettingsRowData(
                    icon: Icons.fitness_center_rounded,
                    label: 'Sport profile',
                    trailing: 'Strength + cardio',
                  ),
                ],
              ),
              const SectionHeaderWithBadge(label: 'Wearables', badge: 'Soon'),
              const WearablesGroup(),
              sectionLabel('More'),
              SettingsGroup(
                rows: [
                  SettingsRowData(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Subscription',
                    trailing: 'Premium',
                    highlightTrailing: true,
                    onTap: () => Get.to(() => SubscriptionsScreen()),
                  ),
                  SettingsRowData(
                    icon: Icons.shield_outlined,
                    label: 'Legal & Data',
                    onTap: () => Get.toNamed(AppRoutes.legalAndDataScreen),
                  ),
                  // SettingsRowData(
                  //   icon: Icons.info_outline_rounded,
                  //   label: 'Terms of use',
                  //   onTap: () => Get.to(() => TermsOfUseScreen()),
                  // ),
                ],
              ),
              const SizedBox(height: 6),
              Obx(
                () => CustomSecondaryButton(
                  text: controller.isLoading.value
                      ? 'Logging out...'
                      : 'Log out',
                  onTap: controller.isLoading.value ? null : controller.logout,
                  side: const BorderSide(color: AppColors.roseSoft, width: 1.5),
                  foregroundColor: AppColors.rose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget sectionLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 7),
    child: Text(
      label.tr.toUpperCase(),
      style: getTextStyle(
        color: AppColors.textSoft,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
