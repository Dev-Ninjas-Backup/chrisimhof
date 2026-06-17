import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_long_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Long';

  print('1. Registering user...');
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  ).timeout(const Duration(seconds: 30));
  final otp = jsonDecode(regResponse.body)['data']['otp'];

  print('2. Verifying OTP...');
  await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  ).timeout(const Duration(seconds: 30));

  print('3. Logging in...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  ).timeout(const Duration(seconds: 30));
  final accessToken = jsonDecode(loginResponse.body)['data']['tokens']['accessToken'];

  print('4. Creating session...');
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {'Authorization': 'Bearer $accessToken'},
  ).timeout(const Duration(seconds: 30));
  final sessionId = jsonDecode(sessionResponse.body)['data']['sessionId'];
  print('Session ID: $sessionId');

  // Alternative paths to test
  final pathsToTest = [
    '/api/v1/calculator/session/$sessionId/water',
    '/api/v1/calculator/session/$sessionId/meals',
    '/api/v1/calculator/session/$sessionId/sports',
    '/api/v1/calculator/session/$sessionId/nutrition',
    '/api/v1/calculator/session/$sessionId/caffeine',
    '/api/v1/calculator/session/$sessionId/sport',
  ];

  for (var path in pathsToTest) {
    print('Testing POST on: $path');
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({}),
    ).timeout(const Duration(seconds: 30));
    print('Response for POST $path: ${response.statusCode} - ${response.body}');
  }
}
