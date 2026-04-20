import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/auth/sign_in/model/login_response_model.dart';
import 'package:http/http.dart' as http;

class SignInService {
  Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(Urls.login);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email.trim(), 'password': password.trim()}),
    );

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message'] ?? 'Login failed');
    }
  }
}
