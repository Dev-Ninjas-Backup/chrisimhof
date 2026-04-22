import 'dart:convert';

import 'package:chrisimhof/core/service/end_points.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteAccountService {
  Future<bool> deleteAccount({
    required String accessToken,
    required String userId,
  }) async {
    final uri = Uri.parse(Urls.deleteAccount(userId));

    final response = await http.delete(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
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
