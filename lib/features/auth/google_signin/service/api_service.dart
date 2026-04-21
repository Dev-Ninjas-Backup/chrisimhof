import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/auth/google_signin/model/google_signin_response.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class ApiService {

  Future<GoogleSignInResponse> sendUser(UserModel user) async {
    try {
      print("Sending user data to: https://api.ryvenza.app/api/v1/auth/google");
      print("User data: ${user.toJson()}");

      final response = await http.post(
        Uri.parse("https://api.ryvenza.app/api/v1/auth/google"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 10));

      print("Response status code: ${response.statusCode}");
      print("Response headers: ${response.headers}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = GoogleSignInResponse.fromJson(jsonResponse);
        print("User sent successfully");
        print("Access Token: ${apiResponse.accessToken}");
        print("Refresh Token: ${apiResponse.refreshToken}");
        return apiResponse;
      } else {
        final errorMessage = response.body.isEmpty 
          ? "Status ${response.statusCode}: Empty response" 
          : response.body;
        print("API Error: $errorMessage");
        return GoogleSignInResponse(
          success: false,
          message: errorMessage,
        );
      }
    } on http.ClientException catch (e) {
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("❌ API CONNECTION ERROR");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("URL: https://api.ryvenza.app/api/v1/auth/google");
      print("Error: $e");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      return GoogleSignInResponse(
        success: false,
        message: "Connection error: $e",
      );
    } catch (e) {
      print("❌ API Exception: $e");
      print("Stack trace: ${StackTrace.current}");
      return GoogleSignInResponse(
        success: false,
        message: "Exception: $e",
      );
    }
  }
}