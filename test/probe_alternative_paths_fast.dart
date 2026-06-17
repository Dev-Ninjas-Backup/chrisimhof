import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_fast_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Fast';

  try {
    print('1. Registering user...');
    final regResponse = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
    ).timeout(const Duration(seconds: 5));
    final otp = jsonDecode(regResponse.body)['data']['otp'];

    print('2. Verifying OTP...');
    await http.post(
      Uri.parse('$baseUrl/api/v1/auth/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
    ).timeout(const Duration(seconds: 5));

    print('3. Logging in...');
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 5));
    final accessToken = jsonDecode(loginResponse.body)['data']['tokens']['accessToken'];

    print('4. Creating session...');
    final sessionResponse = await http.get(
      Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).timeout(const Duration(seconds: 5));
    final sessionId = jsonDecode(sessionResponse.body)['data']['sessionId'];
    print('Session ID: $sessionId');

    final pathsToTest = [
      // Paths with sessionId
      '/api/v1/calculator/session/$sessionId/water',
      '/api/v1/calculator/session/$sessionId/hydration',
      '/api/v1/calculator/session/$sessionId/meals',
      '/api/v1/calculator/session/$sessionId/nutrition',
      '/api/v1/calculator/session/$sessionId/caffeine',
      '/api/v1/calculator/session/$sessionId/sport',
      '/api/v1/calculator/session/$sessionId/sports',
      
      // Paths without sessionId
      '/api/v1/calculator/session/water',
      '/api/v1/calculator/session/hydration',
      '/api/v1/calculator/session/meals',
      '/api/v1/calculator/session/nutrition',
      '/api/v1/calculator/session/caffeine',
      '/api/v1/calculator/session/sport',
      '/api/v1/calculator/session/sports',

      '/api/v1/calculator/water',
      '/api/v1/calculator/hydration',
      '/api/v1/calculator/meals',
      '/api/v1/calculator/nutrition',
      '/api/v1/calculator/caffeine',
      '/api/v1/calculator/sport',
      '/api/v1/calculator/sports',
      
      '/api/v1/calculator/caffeine-presets',
    ];

    for (var path in pathsToTest) {
      final url = '$baseUrl$path';
      for (var method in ['GET', 'POST', 'PUT']) {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        };
        http.Response res;
        try {
          if (method == 'GET') {
            res = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 2));
          } else if (method == 'POST') {
            res = await http.post(Uri.parse(url), headers: headers, body: '{}').timeout(const Duration(seconds: 2));
          } else {
            res = await http.put(Uri.parse(url), headers: headers, body: '{}').timeout(const Duration(seconds: 2));
          }
          if (res.statusCode != 404) {
            print('FOUND: $method $path -> ${res.statusCode} - ${res.body}');
          }
        } catch (e) {
          // ignore timeouts
        }
      }
    }
    print('Probing finished successfully.');
  } catch (e) {
    print('Failed with error: $e');
  }
}
