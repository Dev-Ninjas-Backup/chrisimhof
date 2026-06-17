import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'fixed_agent_probe@example.com';
  final password = 'Password123!';
  final name = 'Fixed Agent';

  String? accessToken;

  print('1. Attempting login...');
  try {
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 5));
    if (loginResponse.statusCode == 200) {
      final loginJson = jsonDecode(loginResponse.body);
      accessToken = loginJson['data']['tokens']['accessToken'];
      print('Direct login successful. Access Token: $accessToken');
    }
  } catch (e) {
    print('Direct login failed/timed out: $e');
  }

  if (accessToken == null) {
    print('2. User not found or login failed. Registering...');
    try {
      final regResponse = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
      ).timeout(const Duration(seconds: 10));
      if (regResponse.statusCode == 200 || regResponse.statusCode == 201) {
        final regJson = jsonDecode(regResponse.body);
        final otp = regJson['data']['otp'];
        print('Registration successful. OTP: $otp');

        print('3. Verifying OTP...');
        final verifyResponse = await http.post(
          Uri.parse('$baseUrl/api/v1/auth/verify'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
        ).timeout(const Duration(seconds: 10));
        print('OTP verification: ${verifyResponse.statusCode}');

        print('4. Logging in after verification...');
        final loginResponse = await http.post(
          Uri.parse('$baseUrl/api/v1/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        ).timeout(const Duration(seconds: 10));
        final loginJson = jsonDecode(loginResponse.body);
        accessToken = loginJson['data']['tokens']['accessToken'];
        print('Login successful. Access Token: $accessToken');
      } else {
        print('Registration failed: ${regResponse.statusCode} - ${regResponse.body}');
        return;
      }
    } catch (e) {
      print('Registration/verification failed: $e');
      return;
    }
  }

  print('5. Creating session...');
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {'Authorization': 'Bearer $accessToken'},
  ).timeout(const Duration(seconds: 5));
  final sessionJson = jsonDecode(sessionResponse.body);
  final sessionId = sessionJson['data']['sessionId'];
  print('Session ID: $sessionId');

  final pathsToTest = [
    // Sleep and Work (known to work)
    '/api/v1/calculator/session/$sessionId/sleep',
    '/api/v1/calculator/session/$sessionId/work',
    
    // Nutrition/Meals
    '/api/v1/calculator/session/$sessionId/nutrition',
    '/api/v1/calculator/session/$sessionId/meals',
    '/api/v1/calculator/session/$sessionId/meal',
    
    // Hydration/Water
    '/api/v1/calculator/session/$sessionId/hydration',
    '/api/v1/calculator/session/$sessionId/water',
    
    // Caffeine
    '/api/v1/calculator/session/$sessionId/caffeine',
    
    // Sport/Sports
    '/api/v1/calculator/session/$sessionId/sport',
    '/api/v1/calculator/session/$sessionId/sports',
  ];

  final client = http.Client();
  for (var path in pathsToTest) {
    final url = '$baseUrl$path';
    for (var method in ['GET', 'POST', 'PUT']) {
      print('Testing: $method $path');
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
        if (res.statusCode != 404) {
          print('FOUND: $method $path -> ${res.statusCode} (body: ${res.body})');
        }
      } catch (e) {
        print('Error on $method $path: $e');
      }
    }
  }
  client.close();
  print('Probe finished.');
}
