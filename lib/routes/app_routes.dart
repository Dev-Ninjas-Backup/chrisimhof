import 'package:chrisimhof/features/auth/create_account/screen/create_account_screen.dart';
import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String signInScreen = '/signInScreen';
  static String createAccountScreen = '/createAccountScreen';

  static String getSplashScreen() => splashScreen;
  static String getSignInScreen() => signInScreen;
  static String getCreateAccountScreen() => createAccountScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: createAccountScreen, page: () => CreateAccountScreen()),
  ];
}
