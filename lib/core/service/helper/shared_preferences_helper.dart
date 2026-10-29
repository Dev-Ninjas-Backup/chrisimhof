import 'package:chrisimhof/core/service/helper/timezone_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _sessionIdKey = 'sessionId';
  static const String _sessionStartedAtKey = 'sessionStartedAt';
  static const String _sessionExpiresAtKey = 'sessionExpiresAt';
  static const String _languageKey = 'language';

  // Save language
  static Future<void> saveLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  // Get language
  static Future<String?> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Save session id
  static Future<void> saveSessionId(String sessionId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionIdKey, sessionId);
  }

  // Get session id
  static Future<String?> getSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionIdKey);
  }

  // Remove session id
  static Future<void> removeSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionIdKey);
    await prefs.remove(_sessionStartedAtKey);
    await prefs.remove(_sessionExpiresAtKey);
  }

  // Save session startedAt timestamp (UTC ISO)
  static Future<void> saveSessionStartedAtIso(String isoString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionStartedAtKey, isoString);
  }

  static Future<void> saveSessionStartedAt(DateTime dateTime) async {
    await saveSessionStartedAtIso(
      TimezoneHelper.formatToSessionUtcIso(dateTime),
    );
  }

  static Future<DateTime?> getSessionStartedAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_sessionStartedAtKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return TimezoneHelper.parseSessionUtcToLocal(raw);
    } catch (_) {
      return DateTime.tryParse(raw)?.toLocal();
    }
  }

  // Save session expiresAt timestamp (UTC ISO)
  static Future<void> saveSessionExpiresAtIso(String isoString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionExpiresAtKey, isoString);
  }

  static Future<DateTime?> getSessionExpiresAt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_sessionExpiresAtKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return TimezoneHelper.parseSessionUtcToLocal(raw);
    } catch (_) {
      return DateTime.tryParse(raw)?.toLocal();
    }
  }

  // Save login status
  static Future<void> setLoginStatus(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_sessionIdKey);
    await prefs.remove(_sessionStartedAtKey);
    await prefs.remove(_sessionExpiresAtKey);
  }

  // --- Caffeine Logs ---
  static Future<void> saveCaffeineLogs(String jsonStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('caffeineLogs', jsonStr);
  }

  static Future<String?> getCaffeineLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('caffeineLogs');
  }

  // --- Hydration Logs ---
  static Future<void> saveHydrationLogs(String jsonStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hydrationLogs', jsonStr);
  }

  static Future<String?> getHydrationLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('hydrationLogs');
  }

  // --- Nutrition (Meals) ---
  static Future<void> saveMeals(String jsonStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nutritionMeals', jsonStr);
  }

  static Future<String?> getMeals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nutritionMeals');
  }

  static Future<void> saveNutritionNotes(List<String> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nutritionNotes', notes);
  }

  static Future<List<String>?> getNutritionNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('nutritionNotes');
  }

  // --- Sports ---
  static Future<void> saveSportsSessions(String jsonStr) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sportsSessions', jsonStr);
  }

  static Future<String?> getSportsSessions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sportsSessions');
  }

  static Future<void> saveSportsTodayMetrics({
    required bool hasTodaySession,
    required int duration,
    required String zone,
    required String sport,
    required String distance,
    required String startTime,
    required String endTime,
    required String effort,
    required String type,
    required int recoveryScore,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sportsHasToday', hasTodaySession);
    await prefs.setInt('sportsDuration', duration);
    await prefs.setString('sportsZone', zone);
    await prefs.setString('sportsSport', sport);
    await prefs.setString('sportsDistance', distance);
    await prefs.setString('sportsStartTime', startTime);
    await prefs.setString('sportsEndTime', endTime);
    await prefs.setString('sportsEffort', effort);
    await prefs.setString('sportsType', type);
    await prefs.setInt('sportsRecoveryScore', recoveryScore);
  }

  static Future<Map<String, dynamic>> getSportsTodayMetrics() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'hasTodaySession': prefs.getBool('sportsHasToday') ?? false,
      'duration': prefs.getInt('sportsDuration') ?? 0,
      'zone': prefs.getString('sportsZone') ?? '',
      'sport': prefs.getString('sportsSport') ?? '',
      'distance': prefs.getString('sportsDistance') ?? '',
      'startTime': prefs.getString('sportsStartTime') ?? '',
      'endTime': prefs.getString('sportsEndTime') ?? '',
      'effort': prefs.getString('sportsEffort') ?? '',
      'type': prefs.getString('sportsType') ?? '',
      'recoveryScore': prefs.getInt('sportsRecoveryScore') ?? 0,
    };
  }

  static Future<void> saveSportsWeeklyGoal(int goal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sportsWeeklyGoal', goal);
  }

  static Future<int?> getSportsWeeklyGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('sportsWeeklyGoal');
  }

  // --- Timezone Settings ---
  static Future<void> saveTimezone(String timezone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userTimezone', timezone);
  }

  static Future<String?> getTimezone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userTimezone');
  }

  static Future<void> saveTimezoneDisplay(String display) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userTimezoneDisplay', display);
  }

  static Future<String?> getTimezoneDisplay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userTimezoneDisplay');
  }

  // --- User ID & FCM Token ---
  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveFcmToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmToken', token);
  }

  static Future<String?> getFcmToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken');
  }
}
