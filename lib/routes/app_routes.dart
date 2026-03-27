import 'package:chrisimhof/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:chrisimhof/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String signInScreen = '/signInScreen';

  static String getSplashScreen() => splashScreen;
  static String getSignInScreen() => signInScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
  ];
}
