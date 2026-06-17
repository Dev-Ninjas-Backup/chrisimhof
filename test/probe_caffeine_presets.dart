import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_presets_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Presets';

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

  print('4. Requesting caffeine presets...');
  final response = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/caffeine-presets'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Caffeine presets response: ${response.statusCode} - ${response.body}');
}
