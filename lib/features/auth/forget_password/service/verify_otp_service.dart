import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/features/auth/forget_password/model/verify_otp_response_model.dart';
import 'package:http/http.dart' as http;

class VerifyOtpService {
  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
    required String purpose, // "register" or "forget_password"
  }) async {
    final uri = Uri.parse(Urls.verifyOtp);

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'otp': otp, 'purpose': purpose}),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return VerifyOtpResponseModel.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }
}
