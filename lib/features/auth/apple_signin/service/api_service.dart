import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/apple_signin_response.dart';
import '../model/user_model.dart';

class ApiService {
  Future<AppleSignInResponse> sendUser(UserModel user) async {
    try {
      debugPrint("Apple User data: ${user.toJson()}");

      final response = await http
          .post(
            Uri.parse(Urls.appleSignin),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint("Apple Sign-In Response status: ${response.statusCode}");
      debugPrint("Apple Sign-In Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = AppleSignInResponse.fromJson(jsonResponse);
        debugPrint("Apple user logged in successfully");
        return apiResponse;
      } else {
        final errorMessage = response.body.isEmpty
            ? "Status ${response.statusCode}: Empty response"
            : response.body;
        debugPrint("Apple API Error: $errorMessage");
        return AppleSignInResponse(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      debugPrint("❌ Apple API Connection Error: $e");
      return AppleSignInResponse(
        success: false,
        message: "Connection error: $e",
      );
    } catch (e) {
      debugPrint("❌ Apple API Exception: $e");
      return AppleSignInResponse(success: false, message: "Exception: $e");
    }
  }
}
