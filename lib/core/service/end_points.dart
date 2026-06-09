class Urls {
  static const String baseUrl = 'https://api.ryvenza.app';

  static const String register = '$baseUrl/api/v1/auth/register';
  static const String verifyOtp = '$baseUrl/api/v1/auth/verify';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String logout = '$baseUrl/api/v1/auth/logout';
  static const String googleSignin = '$baseUrl/api/v1/auth/google';

  static const String microsoftSignin = '$baseUrl/api/v1/auth/microsoft';

  static const String profile = '$baseUrl/api/v1/profile';
  static const String updateProfile = '$baseUrl/api/v1/profile';
  static const String showSubscriptionPlans =
      '$baseUrl/api/v1/subscription-plans/public/active';
  static const String changePassword = '$baseUrl/api/v1/profile/password';
  static const String checkout = '$baseUrl/api/v1/billing/checkout';

  static const String userMe = '$baseUrl/api/v1/auth/me';
  static const String history = '$baseUrl/api/v1/history';
  static const String dashboard = '$baseUrl/api/v1/dashboard';

  // Analytics
  static String analytics(String days) =>
      '$baseUrl/api/v1/analytics?period=$days';
  static const String createCalculatorSession =
      '$baseUrl/api/v1/calculator/session';
  static String sleepCalculator(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/sleep';
  static String workCalculator(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/work';
  static String skipWork(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/work/skip';
  static String nutritionCalculator(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/nutrition';
  static String hydrationCalculator(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/hydration';
  static const String caffeineQuickEntry =
      '$baseUrl/api/v1/calculator/caffeine-presets';
  static String addCaffeineIntake(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/caffeine';
  static String skipCaffeineIntake(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/caffeine/skip';
  static String sportsCalculator(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/sport';
  static String calculateResult(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/calculate';
  static const String selectlanguage = '$baseUrl/api/v1/profile/language';
  static String deleteAccount(String userId) =>
      '$baseUrl/api/v1/users/$userId/permanent';
  static const String latestResults =
      '$baseUrl/api/v1/calculator/latest-result';
  static String historyDetails(String historyId) =>
      '$baseUrl/api/v1/history/$historyId';
  static String sessionReset(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/reset';
  static String updateCalculatorSession(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/update';
  static const String optimalBedtime =
      '$baseUrl/api/v1/calculator/optimal-bedtime';
  static const String forgotPassword = '$baseUrl/api/v1/auth/forgot-password';
  static const String resetPassword = '$baseUrl/api/v1/auth/reset-password';
}
