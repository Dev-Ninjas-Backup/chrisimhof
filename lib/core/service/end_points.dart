class Urls {
  static const String baseUrl = 'https://api.ryvenza.app';
  static const String realtimeSocket = '$baseUrl/realtime';

  static const String register = '$baseUrl/api/v1/auth/register';
  static const String verifyOtp = '$baseUrl/api/v1/auth/verify';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String logout = '$baseUrl/api/v1/auth/logout';
  static const String refresh = '$baseUrl/api/v1/auth/refresh';
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
  static String calculateResult(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/calculate';
  static const String selectlanguage = '$baseUrl/api/v1/profile/language';
  static String deleteAccount(String userId) =>
      '$baseUrl/api/v1/users/$userId/permanent';
  static String sessionReset(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/reset';
  static String updateCalculatorSession(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/update';
  static const String optimalBedtime =
      '$baseUrl/api/v1/calculator/optimal-bedtime';
  static const String forgotPassword = '$baseUrl/api/v1/auth/forgot-password';
  static const String resetPassword = '$baseUrl/api/v1/auth/reset-password';
  static String getSafety(String locale) =>
      '$baseUrl/api/v1/onboarding/safety?locale=$locale';
  static const String acceptSafety =
      '$baseUrl/api/v1/onboarding/safety/acknowledge';
  static const String baseline = '$baseUrl/api/v1/profile/baseline';
  static String getConnectedSources(String locale) =>
      '$baseUrl/api/v1/onboarding/sources?locale=$locale';
  static const String connectSource = '$baseUrl/api/v1/onboarding/sources';
  static String getConsentSettings(String locale) =>
      '$baseUrl/api/v1/onboarding/consent?locale=$locale';
  static const String updateConsentSettings =
      '$baseUrl/api/v1/onboarding/consent';
  static String quickAdd(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/log';
  static String endSession(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/end';
  static String liveScore(String sessionId, String locale) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/scores?locale=$locale';
  static String addDailyNotes(String sessionId) =>
      '$baseUrl/api/v1/calculator/session/$sessionId/notes';
  static String createWeeklyPattern(String sessionId) =>
      '$baseUrl/api/v1/calculator/work-settings/session/$sessionId/weekly-pattern';
  static const String createWorkSettings = '$baseUrl/api/v1/calculator/work-settings';
}
