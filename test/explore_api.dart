import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_agent_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Agent';

  print('1. Registering user...');
  final regUri = Uri.parse('$baseUrl/api/v1/auth/register');
  final regResponse = await http.post(
    regUri,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );

  print('Register response: ${regResponse.statusCode} - ${regResponse.body}');
  if (regResponse.statusCode != 200 && regResponse.statusCode != 201) {
    print('Failed to register');
    return;
  }

  final regJson = jsonDecode(regResponse.body);
  final otp = regJson['data']['otp'];
  print('Registration successful. OTP: $otp');

  print('2. Verifying OTP...');
  final verifyUri = Uri.parse('$baseUrl/api/v1/auth/verify');
  final verifyResponse = await http.post(
    verifyUri,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );

  print('Verify response: ${verifyResponse.statusCode} - ${verifyResponse.body}');
  if (verifyResponse.statusCode != 200 && verifyResponse.statusCode != 201) {
    print('Failed to verify OTP');
    return;
  }

  print('3. Logging in...');
  final loginUri = Uri.parse('$baseUrl/api/v1/auth/login');
  final loginResponse = await http.post(
    loginUri,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  print('Login response: ${loginResponse.statusCode} - ${loginResponse.body}');
  if (loginResponse.statusCode != 200 && loginResponse.statusCode != 201) {
    print('Failed to login');
    return;
  }

  final loginJson = jsonDecode(loginResponse.body);
  final accessToken = loginJson['data']['tokens']['accessToken'];
  print('Login successful. Access Token: $accessToken');

  // Let's create a session
  print('4. Creating session...');
  final sessionUri = Uri.parse('$baseUrl/api/v1/calculator/session?locale=en');
  final sessionResponse = await http.get(
    sessionUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Session response: ${sessionResponse.statusCode} - ${sessionResponse.body}');
  final sessionJson = jsonDecode(sessionResponse.body);
  final sessionId = sessionJson['data']['sessionId'];
  print('Session created. Session ID: $sessionId');

  // Let's acknowledge safety
  print('5. Acknowledging safety...');
  final safetyUri = Uri.parse('$baseUrl/api/v1/onboarding/safety/acknowledge');
  final safetyResponse = await http.post(
    safetyUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Safety response: ${safetyResponse.statusCode} - ${safetyResponse.body}');

  // Let's setup baseline
  print('6. Setting up baseline...');
  final baselineUri = Uri.parse('$baseUrl/api/v1/profile/baseline');
  final baselineResponse = await http.patch(
    baselineUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'sleepTargetMinutes': 480,
      'chronotype': 'LARK',
      'caffeineSensitivity': 'NORMAL',
      'sportProfile': 'FIT',
    }),
  );
  print('Baseline response: ${baselineResponse.statusCode} - ${baselineResponse.body}');

  // Let's set connected sources
  print('7. Setting connected sources...');
  final sourcesUri = Uri.parse('$baseUrl/api/v1/onboarding/sources');
  final sourcesResponse = await http.post(
    sourcesUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'appleHealth': true,
      'googleHealthConnect': false,
    }),
  );
  print('Sources response: ${sourcesResponse.statusCode} - ${sourcesResponse.body}');

  // Let's set consent settings
  print('8. Setting consent settings...');
  final consentUri = Uri.parse('$baseUrl/api/v1/onboarding/consent');
  final consentResponse = await http.post(
    consentUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'performanceOptimization': true,
      'scientificResearch': true,
    }),
  );
  print('Consent response: ${consentResponse.statusCode} - ${consentResponse.body}');

  // Let's get user profile
  print('9. Fetching user profile...');
  final profileUri = Uri.parse('$baseUrl/api/v1/auth/me');
  final profileResponse = await http.get(
    profileUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Profile response: ${profileResponse.statusCode} - ${profileResponse.body}');

  // Let's fetch dashboard
  print('10. Fetching dashboard...');
  final dashUri = Uri.parse('$baseUrl/api/v1/dashboard');
  final dashResponse = await http.get(
    dashUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Dashboard response: ${dashResponse.statusCode} - ${dashResponse.body}');

  // Let's fetch latest-result
  print('11. Fetching latest calculator results...');
  final latestUri = Uri.parse('$baseUrl/api/v1/calculator/latest-result');
  final latestResponse = await http.get(
    latestUri,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Latest results response: ${latestResponse.statusCode} - ${latestResponse.body}');
}
