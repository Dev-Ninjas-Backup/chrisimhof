import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final email = 'test_upd_corr_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test Update Correct';

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

  final url = '$baseUrl/api/v1/calculator/session/$sessionId/update';
  final client = http.Client();
  for (var method in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']) {
    print('Testing: $method $url ...');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    http.Response response;
    if (method == 'GET') {
      response = await client.get(Uri.parse(url), headers: headers);
    } else if (method == 'POST') {
      response = await client.post(Uri.parse(url), headers: headers, body: '{}');
    } else if (method == 'PUT') {
      response = await client.put(Uri.parse(url), headers: headers, body: '{}');
    } else if (method == 'PATCH') {
      response = await client.patch(Uri.parse(url), headers: headers, body: '{}');
    } else {
      response = await client.delete(Uri.parse(url), headers: headers);
    }
    print('$method response: ${response.statusCode} - ${response.body}');
  }
  client.close();
}
