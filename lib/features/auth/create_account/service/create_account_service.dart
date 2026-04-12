import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/auth/create_account/model/register_response_model.dart';
import 'package:http/http.dart' as http;

class CreateAccountService {
  Future<RegisterResponseModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(Urls.register);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'name': name.trim(),
        'password': password.trim(),
      }),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RegisterResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Registration failed');
    }
  }
}
