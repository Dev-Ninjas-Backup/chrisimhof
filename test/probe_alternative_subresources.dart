import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_sub_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Sub';

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

  print('4. Creating session...');
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );
  final sessionId = jsonDecode(sessionResponse.body)['data']['sessionId'];
  print('Session ID: $sessionId');

  // Alternative sub-resources to probe under the session prefix:
  // /api/v1/calculator/session/$sessionId/...
  final subresources = [
    'sleep',
    'work',
    'caffeine',
    'caffeine-intake',
    'caffeine-intakes',
    'caffeines',
    'hydration',
    'hydrations',
    'water',
    'water-intake',
    'water-intakes',
    'nutrition',
    'meal',
    'meals',
    'nutrition-intake',
    'sport',
    'sports',
    'exercise',
    'activity',
    'activities',
  ];

  final client = http.Client();
  for (var sub in subresources) {
    final path = '/api/v1/calculator/session/$sessionId/$sub';
    final url = '$baseUrl$path';
    for (var method in ['GET', 'POST']) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      try {
        http.Response res;
        if (method == 'GET') {
          res = await client.get(Uri.parse(url), headers: headers);
        } else {
          res = await client.post(Uri.parse(url), headers: headers, body: '{}');
        }
        if (res.statusCode != 404) {
          print('FOUND SUBRESOURCE: $method $path -> ${res.statusCode} (body: ${res.body})');
        }
      } catch (e) {
        print('Error on $method $path: $e');
      }
    }
  }
  client.close();
}
