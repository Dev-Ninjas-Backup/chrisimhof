import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_no_id_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test No ID';

  print('1. Registering user...');
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );
  final otp = jsonDecode(regResponse.body)['data']['otp'];

  print('2. Verifying OTP...');
  await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );

  print('3. Logging in...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  final accessToken = jsonDecode(loginResponse.body)['data']['tokens']['accessToken'];

  final pathsToTest = [
    '/api/v1/calculator/session/sleep',
    '/api/v1/calculator/session/work',
    '/api/v1/calculator/session/caffeine',
    '/api/v1/calculator/session/hydration',
    '/api/v1/calculator/session/nutrition',
    '/api/v1/calculator/session/sport',
  ];

  final client = http.Client();
  for (var path in pathsToTest) {
    final url = '$baseUrl$path';
    for (var method in ['GET', 'POST', 'PUT', 'PATCH']) {
      print('Testing: $method $path');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      try {
        http.Response res;
        if (method == 'GET') {
          res = await client.get(Uri.parse(url), headers: headers);
        } else if (method == 'POST') {
          res = await client.post(Uri.parse(url), headers: headers, body: '{}');
        } else if (method == 'PUT') {
          res = await client.put(Uri.parse(url), headers: headers, body: '{}');
        } else {
          res = await client.patch(Uri.parse(url), headers: headers, body: '{}');
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
}
