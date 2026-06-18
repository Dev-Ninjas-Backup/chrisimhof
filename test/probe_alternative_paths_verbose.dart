import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_verbose_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Verbose';

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
      '/api/v1/calculator/session/$sessionId/sleep',
      '/api/v1/calculator/session/$sessionId/work',
      '/api/v1/calculator/session/$sessionId/water',
      '/api/v1/calculator/session/$sessionId/hydration',
      '/api/v1/calculator/session/$sessionId/meals',
      '/api/v1/calculator/session/$sessionId/nutrition',
      '/api/v1/calculator/session/$sessionId/caffeine',
      '/api/v1/calculator/session/$sessionId/sport',
      '/api/v1/calculator/session/$sessionId/sports',
      
      '/api/v1/calculator/session/water',
      '/api/v1/calculator/session/meals',
      '/api/v1/calculator/session/caffeine',
      '/api/v1/calculator/session/sport',

      '/api/v1/calculator/caffeine-presets',
    ];

    final client = http.Client();
    for (var path in pathsToTest) {
      final url = '$baseUrl$path';
      for (var method in ['GET', 'POST', 'PUT']) {
        print('Testing: $method $path ...');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        };
        try {
          http.Response res;
          if (method == 'GET') {
            res = await client.get(Uri.parse(url), headers: headers).timeout(const Duration(milliseconds: 1500));
          } else if (method == 'POST') {
            res = await client.post(Uri.parse(url), headers: headers, body: '{}').timeout(const Duration(milliseconds: 1500));
          } else {
            res = await client.put(Uri.parse(url), headers: headers, body: '{}').timeout(const Duration(milliseconds: 1500));
          }
          print('RESULT: $method $path -> ${res.statusCode} (body: ${res.body})');
        } catch (e) {
          print('ERROR: $method $path -> $e');
        }
      }
    }
    client.close();
    print('Done probing.');
  } catch (e) {
    print('Setup failed: $e');
  }
}
