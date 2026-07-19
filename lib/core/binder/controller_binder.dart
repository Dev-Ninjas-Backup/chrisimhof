import 'package:get/get.dart';
import 'package:chrisimhof/core/common/controller/language_controller.dart';
import 'package:chrisimhof/features/splash/controller/splash_screen_controller.dart';
import 'package:chrisimhof/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:chrisimhof/features/auth/create_account/controller/create_account_controller.dart';
import 'package:chrisimhof/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:chrisimhof/features/auth/safety/controller/safety_controller.dart';
import 'package:chrisimhof/features/auth/connected_sources/controller/connected_sources_controller.dart';
import 'package:chrisimhof/features/auth/baseline_setup/controller/baseline_setup_controller.dart';
import 'package:chrisimhof/features/nav_bar/controller/nav_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/widgets/sleep_orbit_widget.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/pulsing_rhythm_badge_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/settings/main/controller/settings_controller.dart';
import 'package:chrisimhof/features/settings/edit_profile/controller/edit_profile_controller.dart';
import 'package:chrisimhof/features/settings/subscriptions/controller/subscriptions_controller.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/controller/consent_settings_controller.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/controller/delete_account_controller.dart';
import 'package:chrisimhof/features/settings/change_password/controller/change_password_controller.dart';
import 'package:chrisimhof/core/common/controller/time_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController(), fenix: true);
    Get.lazyPut(() => SplashScreenController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => CreateAccountController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => SafetyController(), fenix: true);
    Get.lazyPut(() => ConnectedSourcesController(), fenix: true);
    Get.lazyPut(() => BaselineSetupController(), fenix: true);
    Get.lazyPut(() => NavController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => RecommendationController(), fenix: true);
    Get.lazyPut(() => SleepController(), fenix: true);
    Get.lazyPut(() => SleepOrbitController(), fenix: true);
    Get.lazyPut(() => PulsingRhythmBadgeController(), fenix: true);
    Get.lazyPut(() => CaffeineController(), fenix: true);
    Get.lazyPut(() => WorkController(), fenix: true);
    Get.lazyPut(() => WorkScheduleSettingsController(), fenix: true);
    Get.lazyPut(() => HydrationController(), fenix: true);
    Get.lazyPut(() => NutritionController(), fenix: true);
    Get.lazyPut(() => SportsController(), fenix: true);
    Get.lazyPut(() => StatisticsController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => EditProfileController(), fenix: true);
    Get.lazyPut(() => SubscriptionsController(), fenix: true);
    Get.lazyPut(() => ConsentSettingsController(), fenix: true);
    Get.lazyPut(() => DeleteAccountController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => TimeController(), fenix: true);
  }
}
