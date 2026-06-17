import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_success_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Success';

  print('1. Registering user...');
  final regResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/register'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'fullName': name, 'password': password}),
  );
  final regJson = jsonDecode(regResponse.body);
  final otp = regJson['data']['otp'];

  print('2. Verifying OTP...');
  await http.post(
    Uri.parse('$baseUrl/api/v1/auth/verify'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'otp': otp, 'purpose': 'register'}),
  );

  print('3. Logging in...');
  final loginResponse = await http.post(
    Uri.parse('$baseUrl/api/v1/auth/login'),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  final loginJson = jsonDecode(loginResponse.body);
  final accessToken = loginJson['data']['tokens']['accessToken'];

  print('4. Acknowledging safety...');
  await http.post(
    Uri.parse('$baseUrl/api/v1/onboarding/safety/acknowledge'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'acknowledgedItems': [1, 2, 3]
    }),
  );

  print('5. Setting baseline...');
  await http.patch(
    Uri.parse('$baseUrl/api/v1/profile/baseline'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'sleepTargetMinutes': 480,
      'chronotype': 'evening',
      'caffeineSensitivity': 'medium',
      'sportProfile': 'mixed',
    }),
  );

  print('6. Creating session...');
  final sessionResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/calculator/session?locale=en'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  final sessionJson = jsonDecode(sessionResponse.body);
  final sessionId = sessionJson['data']['sessionId'];
  print('Session ID: $sessionId');

  print('7. Logging sleep...');
  final sleepRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/sleep'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'sleepStartTime': '23:00',
      'wakeTime': '07:00'
    }),
  );
  print('Sleep Response: ${sleepRes.statusCode} - ${sleepRes.body}');

  print('8. Logging work...');
  final workRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/work'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'shiftType': 'night',
      'shiftStartTime': '22:00',
      'shiftEndTime': '06:00'
    }),
  );
  print('Work Response: ${workRes.statusCode} - ${workRes.body}');

  print('9. Running calculation...');
  final calcRes = await http.post(
    Uri.parse('$baseUrl/api/v1/calculator/session/$sessionId/calculate'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({}),
  );
  print('Calculate Response: ${calcRes.statusCode} - ${calcRes.body}');

  print('10. Fetching dashboard...');
  final dashResponse = await http.get(
    Uri.parse('$baseUrl/api/v1/dashboard'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );
  print('Dashboard Response: ${dashResponse.statusCode} - ${dashResponse.body}');
}
