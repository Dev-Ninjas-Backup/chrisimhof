import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_sleep_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Sleep';

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

  print('5. Submitting Sleep...');
  final sleepResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/sleep'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'sleepStartTime': '23:08',
      'wakeTime': '05:50',
    }),
  );
  print('Sleep response status: ${sleepResponse.statusCode}');
  print('Sleep response body: ${sleepResponse.body}');
}
