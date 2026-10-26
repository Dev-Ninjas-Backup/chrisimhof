import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/screen/dashboard_screen.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/nav_bar/widget/custom_navbar.dart';
import 'package:chrisimhof/features/recomendations/screen/recomendations_screen.dart';
import 'package:chrisimhof/features/settings/main/screen/settings_screen.dart';
import 'package:chrisimhof/features/statistics/screen/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/main/service/profile_service.dart';
import 'package:chrisimhof/features/settings/main/model/profile_response_model.dart';
import 'package:chrisimhof/core/common/controller/language_controller.dart';

import 'package:chrisimhof/core/service/fcm_service.dart';
import 'package:chrisimhof/core/service/work_settings_service.dart';

const double kNavBarTotalHeight = 86;

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> with WidgetsBindingObserver {
  static bool _languageApplied = false;
  static bool _timezoneSynced = false;
  static bool _fcmSynced = false;

  static const List<Widget> _screens = [
    DashboardScreen(),
    RecomendationsScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-verify and sync timezone on app resume (DST change or travel)
      WorkSettingsService.syncTimezoneSilently();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_timezoneSynced) {
        _timezoneSynced = true;
        WorkSettingsService.syncTimezoneSilently();
      }
      if (!_fcmSynced) {
        _fcmSynced = true;
        FcmService().initialize();
      }
    });

    if (!_languageApplied) {
      _languageApplied = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final String? accessToken =
              await SharedPreferencesHelper.getAccessToken();
          if (accessToken == null || accessToken.trim().isEmpty) return;

          final ProfileService service = ProfileService();
          final ProfileResponseModel resp = await service.getProfile(
            accessToken: accessToken,
          );

          final localLang = await SharedPreferencesHelper.getLanguage();
          final String? lang = localLang?.toUpperCase() ?? resp.data?.language?.toUpperCase();
          if (lang != null && (lang == 'FR' || lang == 'EN')) {
            if (lang == 'FR') {
              Get.updateLocale(const Locale('fr', 'FR'));
            } else {
              Get.updateLocale(const Locale('en', 'US'));
            }
            try {
              final lc = Get.find<LanguageController>();
              lc.selectedLanguage.value = lang;
            } catch (_) {}
          }
        } catch (e) {
          debugPrint('Failed to apply user language: $e');
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Obx(() => _screens[controller.currentIndex.value]),
          const Align(alignment: Alignment.bottomCenter, child: CustomNavBar()),
        ],
      ),
    );
  }
}
