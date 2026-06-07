import 'package:chrisimhof/features/auth/create_account/screen/create_account_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/forget_password_email_screen.dart';
import 'package:chrisimhof/features/auth/safety/screen/safety_screen.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/auth/welcome/screen/welcome_screen.dart';
import 'package:chrisimhof/features/history_details/screen/history_details_screen.dart';
import 'package:chrisimhof/features/medical_disclaimer/screen/medical_disclaimer_screen.dart';
import 'package:chrisimhof/features/settings/change_password/screen/change_password_screen.dart';
import 'package:chrisimhof/features/settings/data_controls/screen/data_controls_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/consent_settings/screen/consent_settings_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/delete_account/screen/delete_account_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/health_and_safety_notes/screen/health_and_safety_notes_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/main_screen/legal_and_data_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:chrisimhof/features/settings/legal_and_data/terms_of_use/screen/terms_of_use_screen.dart';
import 'package:chrisimhof/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String welcomeScreen = '/welcomeScreen';
  static String signInScreen = '/signInScreen';
  static String createAccountScreen = '/createAccountScreen';
  static String changePasswordScreen = '/changePasswordScreen';
  static String forgetPasswordEmailScreen = '/forgetPasswordEmailScreen';
  static String medicalDisclaimerScreen = '/medicalDisclaimerScreen';
  static String historyDetailsScreen = '/historyDetailsScreen';
  static String legalAndDataScreen = '/legalAndDataScreen';
  static String privacyPolicyScreen = '/privacyPolicyScreen';
  static String termsOfUseScreen = '/termsOfUseScreen';
  static String healthAndSafetyScreen = '/healthAndSafetyScreen';
  static String consentSettingsScreen = '/consentSettingsScreen';
  static String deleteAccountScreen = '/deleteAccountScreen';
  static String dataControlsScreen = '/dataControlsScreen';
  static String safetyScreen = '/safetyScreen';

  static String getSplashScreen() => splashScreen;
  static String getWelcomeScreen() => welcomeScreen;
  static String getSignInScreen() => signInScreen;
  static String getCreateAccountScreen() => createAccountScreen;
  static String getChangePasswordScreen() => changePasswordScreen;
  static String getForgetPasswordEmailScreen() => forgetPasswordEmailScreen;
  static String getMedicalDisclaimerScreen() => medicalDisclaimerScreen;
  static String getHistoryDetailsScreen() => historyDetailsScreen;
  static String getLegalAndDataScreen() => legalAndDataScreen;
  static String getPrivacyPolicyScreen() => privacyPolicyScreen;
  static String getTermsOfUseScreen() => termsOfUseScreen;
  static String getHealthAndSafetyScreen() => healthAndSafetyScreen;
  static String getConsentSettingsScreen() => consentSettingsScreen;
  static String getDeleteAccountScreen() => deleteAccountScreen;
  static String getDataControlsScreen() => dataControlsScreen;
  static String getSafetyScreen() => safetyScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: createAccountScreen, page: () => CreateAccountScreen()),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),
    GetPage(
      name: forgetPasswordEmailScreen,
      page: () => ForgetPasswordEmailScreen(),
    ),
    GetPage(
      name: medicalDisclaimerScreen,
      page: () => MedicalDisclaimerScreen(),
    ),
    GetPage(name: historyDetailsScreen, page: () => HistoryDetailsScreen()),
    GetPage(name: legalAndDataScreen, page: () => LegalAndDataScreen()),
    GetPage(name: privacyPolicyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsOfUseScreen, page: () => const TermsOfUseScreen()),
    GetPage(
      name: healthAndSafetyScreen,
      page: () => const HealthAndSafetyNotesScreen(),
    ),
    GetPage(name: consentSettingsScreen, page: () => ConsentSettingsScreen()),
    GetPage(name: deleteAccountScreen, page: () => DeleteAccountScreen()),
    GetPage(name: dataControlsScreen, page: () => const DataControlsScreen()),
    GetPage(name: safetyScreen, page: () => const SafetyScreen()),
  ];
}
