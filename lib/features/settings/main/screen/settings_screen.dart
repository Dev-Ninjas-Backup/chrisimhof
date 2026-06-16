import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:chrisimhof/features/settings/change_password/screen/change_password_screen.dart';
import 'package:chrisimhof/features/settings/edit_profile/screen/edit_profile_screen.dart';
import 'package:chrisimhof/features/settings/language/screens/language_screen.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/settings/main/widgets/profile_card.dart';
import 'package:chrisimhof/features/settings/main/widgets/settings_group.dart';
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
              CustomAppBar(title: 'Settings', showBackButton: false),
              const SizedBox(height: 28),
              ProfileCard(controller: controller),
              sectionLabel('Account'),
              SettingsGroup(
                rows: [
                  SettingsRowData(
                    iconpath: IconPath.professional,
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
                  SettingsRowData(
                    iconpath: IconPath.work,
                    label: 'Work schedule',
                    onTap: () => Get.toNamed(AppRoutes.workScheduleScreen),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.privacy,
                    label: 'Change password',
                    onTap: () => Get.to(() => ChangePasswordScreen()),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.language,
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
                    iconpath: IconPath.sleep,
                    label: 'Sleep target',
                    trailing: '7h 45m',
                  ),
                  SettingsRowData(
                    iconpath: IconPath.chronotype,
                    label: 'Chronotype',
                    trailing: 'Evening leaning',
                  ),
                  SettingsRowData(
                    iconpath: IconPath.caffeine,
                    label: 'Caffeine sensitivity',
                    trailing: 'Medium',
                  ),
                  SettingsRowData(
                    iconpath: IconPath.sport,
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
                    iconpath: IconPath.premium,
                    label: 'Subscription',
                    trailing: 'Premium',
                    highlightTrailing: true,
                    onTap: () => Get.to(() => SubscriptionsScreen()),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.legalData,
                    label: 'Legal & Data',
                    onTap: () => Get.toNamed(AppRoutes.legalAndDataScreen),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.dataControls,
                    label: 'Data controls',
                    onTap: () => Get.toNamed(AppRoutes.dataControlsScreen),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Logging out...'
                      : 'Log out',
                  onTap: controller.isLoading.value ? null : controller.logout,
                  textColor: AppColors.rose,
                  backgroundColor: AppColors.transparent,
                  borderColor: AppColors.rose,
                  borderWidth: 1,
                  iconColor: AppColors.rose,
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
