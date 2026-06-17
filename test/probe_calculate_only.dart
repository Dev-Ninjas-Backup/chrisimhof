import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'agent_calc_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Agent Calc';

  print('1. Registering user...');
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );
  print('Reg response: ${regResponse.statusCode} - ${regResponse.body}');
  final regJson = jsonDecode(regResponse.body);
  final otp = regJson['data']['otp'];

  print('2. Verifying OTP...');
  final verifyResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );
  print('Verify response: ${verifyResponse.statusCode} - ${verifyResponse.body}');

  print('3. Logging in...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  print('Login response: ${loginResponse.statusCode} - ${loginResponse.body}');
  final loginJson = jsonDecode(loginResponse.body);
  final accessToken = loginJson['data']['tokens']['accessToken'];
  print('Login successful. Access Token: $accessToken');

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
      'sleepStartTime': '23:00',
      'wakeTime': '07:00',
    }),
  );
  print('Sleep response status: ${sleepResponse.statusCode}');

  print('6. Calculating Result...');
  final calcResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/calculate'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Calculate response status: ${calcResponse.statusCode}');
  print('Calculate response body: ${calcResponse.body}');
}
