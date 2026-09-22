import 'dart:convert';

import 'package:chrisimhof/core/service/end_points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteAccountService {
  // POST /api/v1/users/account-deletion/request-otp
  Future<bool> requestDeletionOtp({required String accessToken}) async {
    final uri = Uri.parse(Urls.requestAccountDeletionOtp);

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({}),
    );

    debugPrint('Request deletion OTP status: ${response.statusCode}');
    debugPrint('Request deletion OTP body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    String errorMessage = 'Failed to request verification code';
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      errorMessage = jsonData['message'] ?? errorMessage;
    } catch (_) {
      if (response.body.isNotEmpty) {
        errorMessage = response.body;
      }
    }
    throw Exception(errorMessage);
  }

  // DELETE /api/v1/users/:id with {"otp": "..."}
  Future<bool> deleteAccount({
    required String accessToken,
    required String userId,
    required String otp,
  }) async {
    final uri = Uri.parse(Urls.deleteAccount(userId));

    final response = await http.delete(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'otp': otp,
      }),
    );

    debugPrint('Delete account status code: ${response.statusCode}');
    debugPrint('Delete account response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }

    String errorMessage = 'Delete account failed';

    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      errorMessage = jsonData['message'] ?? errorMessage;
    } catch (_) {
      if (response.body.isNotEmpty) {
        errorMessage = response.body;
      }
    }

    throw Exception(errorMessage);
  }
}
