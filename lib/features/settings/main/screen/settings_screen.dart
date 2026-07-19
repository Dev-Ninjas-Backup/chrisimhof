import 'package:chrisimhof/core/common/widgets/custom_app_bar.dart';
import 'package:chrisimhof/core/common/widgets/custom_button.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/nav_bar/screen/navbar_screen.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/settings/main/widgets/profile_card.dart';
import 'package:chrisimhof/features/settings/main/widgets/settings_group.dart';
import 'package:chrisimhof/features/settings/main/widgets/section_header_with_badge.dart';
import 'package:chrisimhof/features/settings/main/widgets/wearables_group.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/sleep_taret_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/chronotype_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/caffeine_sensitivity_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/widgets/sport_profile_bottomsheet.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:chrisimhof/features/auth/baseline_setup/service/baseline_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();
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
              sectionLabel('Account'.tr),
              SettingsGroup(
                rows: [
                  SettingsRowData(
                    iconpath: IconPath.professional,
                    label: 'Edit profile',
                    onTap: () {
                      final String name = controller.fullName.value.isNotEmpty
                          ? controller.fullName.value
                          : 'User Name'.tr;
                      Get.toNamed(
                        AppRoutes.editProfileScreen,
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
                    onTap: () => Get.toNamed(AppRoutes.workScheduleSettingsScreen),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.privacy,
                    label: 'Change password',
                    onTap: () => Get.toNamed(AppRoutes.changePasswordScreen),
                  ),
                  SettingsRowData(
                    iconpath: IconPath.language,
                    label: 'Language',
                    trailing: Get.locale?.languageCode == 'fr'
                        ? 'Français'
                        : 'English',
                    onTap: () => Get.toNamed(AppRoutes.languageScreen),
                  ),
                ],
              ),
              sectionLabel('Baseline profile'.tr),
              Obx(() {
                final sleepMinutes = controller.sleepTargetMinutes.value;
                final hours = sleepMinutes ~/ 60;
                final mins = sleepMinutes % 60;
                final sleepDisplay = mins == 0
                    ? '${hours}h'
                    : '${hours}h ${mins}m';

                final chronoDisplay =
                    BaselineEnums.chronotype[BaselineEnums.normalizeChronotype(
                      controller.chronotype.value,
                    )] ??
                    'Intermediate';

                final caffeineDisplay =
                    BaselineEnums
                        .caffeineSensitivity[BaselineEnums.normalizeCaffeineSensitivity(
                      controller.caffeineSensitivity.value,
                    )] ??
                    'Medium sensitivity';

                final sportDisplay =
                    BaselineEnums
                        .sportProfile[BaselineEnums.normalizeSportProfile(
                      controller.sportProfile.value,
                    )] ??
                    'Light activity';

                return SettingsGroup(
                  accent: true,
                  rows: [
                    SettingsRowData(
                      iconpath: IconPath.sleep,
                      label: 'Sleep target',
                      trailing: sleepDisplay,
                      onTap: () async {
                        final baselineController = Get.find<BaselineSetupController>();
                        baselineController.isFromSettings = true;
                        await baselineController.fetchBaselineData();

                        final initialMinutes =
                            baselineController.sleepHours.value * 60 +
                            baselineController.sleepMinutes.value;

                        await Get.bottomSheet(
                          const SleepTaretBottomsheet(),
                          isScrollControlled: true,
                        );

                        final finalMinutes =
                            baselineController.sleepHours.value * 60 +
                            baselineController.sleepMinutes.value;

                        if (finalMinutes != initialMinutes) {
                          await baselineController.saveBaselineData();
                        }
                      },
                    ),
                    SettingsRowData(
                      iconpath: IconPath.chronotype,
                      label: 'Chronotype',
                      trailing: chronoDisplay,
                      onTap: () async {
                        final baselineController = Get.find<BaselineSetupController>();
                        baselineController.isFromSettings = true;
                        await baselineController.fetchBaselineData();

                        final initialChrono =
                            baselineController.chronotype.value;

                        await Get.bottomSheet(
                          const ChronotypeBottomsheet(),
                          isScrollControlled: true,
                        );

                        if (baselineController.chronotype.value !=
                            initialChrono) {
                          await baselineController.saveBaselineData();
                        }
                      },
                    ),
                    SettingsRowData(
                      iconpath: IconPath.caffeine,
                      label: 'Caffeine sensitivity',
                      trailing: caffeineDisplay,
                      onTap: () async {
                        final baselineController = Get.find<BaselineSetupController>();
                        baselineController.isFromSettings = true;
                        await baselineController.fetchBaselineData();

                        final initialCaffeine =
                            baselineController.caffeineSensitivity.value;

                        await Get.bottomSheet(
                          const CaffeineSensitivityBottomsheet(),
                          isScrollControlled: true,
                        );

                        if (baselineController.caffeineSensitivity.value !=
                            initialCaffeine) {
                          await baselineController.saveBaselineData();
                        }
                      },
                    ),
                    SettingsRowData(
                      iconpath: IconPath.sport,
                      label: 'Sport profile',
                      trailing: sportDisplay,
                      onTap: () async {
                        final baselineController = Get.find<BaselineSetupController>();
                        baselineController.isFromSettings = true;
                        await baselineController.fetchBaselineData();

                        final initialSport =
                            baselineController.sportProfile.value;

                        await Get.bottomSheet(
                          const SportProfileBottomsheet(),
                          isScrollControlled: true,
                        );

                        if (baselineController.sportProfile.value !=
                            initialSport) {
                          await baselineController.saveBaselineData();
                        }
                      },
                    ),
                  ],
                );
              }),
              const SectionHeaderWithBadge(label: 'Wearables', badge: 'Soon'),
              const WearablesGroup(),
              sectionLabel('More'.tr),
              SettingsGroup(
                rows: [
                  SettingsRowData(
                    iconpath: IconPath.premium,
                    label: 'Subscription'.tr,
                    trailing: 'Premium'.tr,
                    highlightTrailing: true,
                    onTap: () => Get.toNamed(AppRoutes.subscriptionsScreen),
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
