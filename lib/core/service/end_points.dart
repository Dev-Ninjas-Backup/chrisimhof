class Urls {
 // static const String baseUrl = 'http://83.228.246.134/api/v1';
 static const String baseUrl = 'https://api.ryvenza.app/api/v1';

  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
static const String googleSignin = '$baseUrl/auth/google';

  static const String profile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String showSubscriptionPlans =
      '$baseUrl/subscription-plans/public/active';
  static const String changePassword = '$baseUrl/profile/password';
  static const String checkout = '$baseUrl/billing/checkout';

  static const String userMe = '$baseUrl/auth/me';
  static const String history = '$baseUrl/history';
  static const String dashboard = '$baseUrl/dashboard';

  // Analytics
  static String analytics(String days) => '$baseUrl/analytics?period=$days';
  static const String createCalculatorSession = '$baseUrl/calculator/session';
  static String sleepCalculator(String sessionId) =>
      '$baseUrl/calculator/session/$sessionId/sleep';
  static String workCalculator(String sessionId) =>
      '$baseUrl/calculator/session/$sessionId/work';
  static String skipWork(String sessionId) =>
      '$baseUrl/calculator/session/$sessionId/work/skip';
  static String nutritionCalculator(String sessionId) =>
      '$baseUrl/calculator/session/$sessionId/nutrition';
  static String hydrationCalculator(String sessionId) =>
      '$baseUrl/calculator/session/$sessionId/hydration';
}
