import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_methods_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Methods';

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

  final endpoints = {
    'nutrition': '$baseUrl/api/v1/calculator/session/$sessionId/nutrition',
    'hydration': '$baseUrl/api/v1/calculator/session/$sessionId/hydration',
    'caffeine': '$baseUrl/api/v1/calculator/session/$sessionId/caffeine',
    'sport': '$baseUrl/api/v1/calculator/session/$sessionId/sport',
  };

  final methods = ['GET', 'POST', 'PUT', 'PATCH'];

  for (var name in endpoints.keys) {
    final url = endpoints[name]!;
    print('--- Testing Endpoints for: $name ($url) ---');
    for (var method in methods) {
      http.Response res;
      try {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        };
        if (method == 'GET') {
          res = await http.get(Uri.parse(url), headers: headers);
        } else if (method == 'POST') {
          res = await http.post(Uri.parse(url), headers: headers, body: '{}');
        } else if (method == 'PUT') {
          res = await http.put(Uri.parse(url), headers: headers, body: '{}');
        } else {
          res = await http.patch(Uri.parse(url), headers: headers, body: '{}');
        }
        print('$method: ${res.statusCode} - ${res.body}');
      } catch (e) {
        print('$method failed with error: $e');
      }
    }
  }
}
