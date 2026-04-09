import 'package:chrisimhof/features/auth/create_account/screen/create_account_screen.dart';
import 'package:chrisimhof/features/auth/forget_password/screen/forget_password_email_screen.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/settings/change_password/screen/change_password_screen.dart';
import 'package:chrisimhof/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String signInScreen = '/signInScreen';
  static String createAccountScreen = '/createAccountScreen';
  static String changePasswordScreen = '/changePasswordScreen';
  static String forgetPasswordEmailScreen = '/forgetPasswordEmailScreen';

  static String getSplashScreen() => splashScreen;
  static String getSignInScreen() => signInScreen;
  static String getCreateAccountScreen() => createAccountScreen;
  static String getChangePasswordScreen() => changePasswordScreen;
  static String getForgetPasswordEmailScreen() => forgetPasswordEmailScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: createAccountScreen, page: () => CreateAccountScreen()),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),
    GetPage(
      name: forgetPasswordEmailScreen,
      page: () => ForgetPasswordEmailScreen(),
    ),
  ];
}
