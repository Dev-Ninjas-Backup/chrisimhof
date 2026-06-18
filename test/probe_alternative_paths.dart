import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_alt_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Alt';

  // Reg, verify, login
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );
  final otp = jsonDecode(regResponse.body)['data']['otp'];
  await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  final accessToken = jsonDecode(loginResponse.body)['data']['tokens']['accessToken'];
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
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
    
    // Paths with sessionId but different order/keys
    '/api/v1/calculator/session/water/$sessionId',
    '/api/v1/calculator/session/hydration/$sessionId',
    '/api/v1/calculator/session/caffeine/$sessionId',
    
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

    // Caffeine presets
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
      if (method == 'GET') {
        res = await http.get(Uri.parse(url), headers: headers);
      } else if (method == 'POST') {
        res = await http.post(Uri.parse(url), headers: headers, body: '{}');
      } else {
        res = await http.put(Uri.parse(url), headers: headers, body: '{}');
      }
      if (res.statusCode != 404) {
        print('FOUND: $method $path -> ${res.statusCode} - ${res.body}');
      }
    }
  }
}
