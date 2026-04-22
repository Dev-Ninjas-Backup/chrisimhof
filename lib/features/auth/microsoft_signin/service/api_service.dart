import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/auth/microsoft_signin/model/microsoft_signin_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class MicrosoftApiService {
  Future<MicrosoftSignInResponse> sendUser(UserModel user) async {
    try {
      debugPrint("User data: ${user.toJson()}");

      final response = await http
          .post(
            Uri.parse(Urls.microsoftSignin),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response headers: ${response.headers}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = MicrosoftSignInResponse.fromJson(jsonResponse);
        debugPrint("User sent successfully");
        debugPrint("Access Token: ${apiResponse.accessToken}");
        debugPrint("Refresh Token: ${apiResponse.refreshToken}");
        return apiResponse;
      } else {
        final errorMessage = response.body.isEmpty
            ? "Status ${response.statusCode}: Empty response"
            : response.body;
        debugPrint("API Error: $errorMessage");
        return MicrosoftSignInResponse(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("❌ API CONNECTION ERROR");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("URL: ${Urls.microsoftSignin}");
      debugPrint("Error: $e");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return MicrosoftSignInResponse(
        success: false,
        message: "Connection error: $e",
      );
    } catch (e) {
      debugPrint("❌ API Exception: $e");
      debugPrint("Stack trace: ${StackTrace.current}");
      return MicrosoftSignInResponse(success: false, message: "Exception: $e");
    }
  }
}
