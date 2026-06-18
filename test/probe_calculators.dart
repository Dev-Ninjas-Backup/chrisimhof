import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_probe_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Probe';

  print('1. Registering user...');
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );
  final regJson = jsonDecode(regResponse.body);
  final otp = regJson['data']['otp'];

  print('2. Verifying OTP...');
  await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );

  print('3. Logging in...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  final loginJson = jsonDecode(loginResponse.body);
  final accessToken = loginJson['data']['tokens']['accessToken'];

  print('4. Creating session...');
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  final sessionJson = jsonDecode(sessionResponse.body);
  final sessionId = sessionJson['data']['sessionId'];
  print('Session ID: $sessionId');

  // Let's probe Sleep Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/sleep
  print('Probing Sleep Calculator...');
  final sleepRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/sleep'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Sleep Response: ${sleepRes.statusCode} - ${sleepRes.body}');

  // Let's probe Work Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/work
  print('Probing Work Calculator...');
  final workRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/work'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Work Response: ${workRes.statusCode} - ${workRes.body}');

  // Let's probe Nutrition Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/nutrition
  print('Probing Nutrition Calculator...');
  final nutrRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/nutrition'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Nutrition Response: ${nutrRes.statusCode} - ${nutrRes.body}');

  // Let's probe Hydration Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/hydration
  print('Probing Hydration Calculator...');
  final hydRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/hydration'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Hydration Response: ${hydRes.statusCode} - ${hydRes.body}');

  // Let's probe Caffeine Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/caffeine
  print('Probing Caffeine Calculator...');
  final caffRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/caffeine'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Caffeine Response: ${caffRes.statusCode} - ${caffRes.body}');

  // Let's probe Sport Calculator
  // Endpoint: POST /api/v1/calculator/session/$sessionId/sport
  print('Probing Sport Calculator...');
  final sportRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/sport'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Sport Response: ${sportRes.statusCode} - ${sportRes.body}');
}
