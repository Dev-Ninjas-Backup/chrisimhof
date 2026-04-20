class Urls {
  static const String baseUrl = 'http://83.228.246.134/api/v1';

  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String profile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  static const String showSubscriptionPlans =
      '$baseUrl/subscription-plans/public/active';
  static const String changePassword = '$baseUrl/profile/password';
  static const String checkout = '$baseUrl/billing/checkout';
  static const String userMe = '$baseUrl/auth/me';

  // Analytics
  static String analytics(String days) => '$baseUrl/analytics?period=$days';
}
