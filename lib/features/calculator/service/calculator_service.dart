import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/hydration_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:http/http.dart' as http;

class CalculatorService {
  Future<CalculatorSessionResponse> getCalculatorSession() async {
    final uri = Uri.parse(Urls.createCalculatorSession);
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('=== Calculator Session Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response: $jsonData');
      print('===================================');

      if (response.statusCode == 200) {
        return CalculatorSessionResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to fetch calculator session',
        );
      }
    } catch (e) {
      print('Calculator session error: $e');
      throw Exception('Error fetching calculator session: $e');
    }
  }

  Future<SleepCalculatorResponse> submitSleepData(
    String sessionId,
    SleepCalculatorRequest request,
  ) async {
    final uri = Uri.parse(Urls.sleepCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('=== Sleep Calculator Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response: $jsonData');
      print('=================================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SleepCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to submit sleep data');
      }
    } catch (e) {
      print('Sleep calculator error: $e');
      throw Exception('Error submitting sleep data: $e');
    }
  }

  Future<WorkCalculatorResponse> submitWorkData(
    String sessionId,
    WorkCalculatorRequest request,
  ) async {
    final uri = Uri.parse(Urls.workCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('=== Work Calculator Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response: $jsonData');
      print('================================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to submit work data');
      }
    } catch (e) {
      print('Work calculator error: $e');
      throw Exception('Error submitting work data: $e');
    }
  }

  Future<WorkCalculatorResponse> skipWorkData(String sessionId) async {
    final uri = Uri.parse(Urls.skipWork(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('=== Skip Work Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response: $jsonData');
      print('==========================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to skip work');
      }
    } catch (e) {
      print('Skip work error: $e');
      throw Exception('Error skipping work: $e');
    }
  }

  Future<NutritionCalculatorResponse> submitNutritionData(
    String sessionId,
    NutritionCalculatorRequest request,
  ) async {
    final uri = Uri.parse(Urls.nutritionCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('=== Nutrition Calculator Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response: $jsonData');
      print('=====================================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return NutritionCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to submit nutrition data',
        );
      }
    } catch (e) {
      print('Nutrition calculator error: $e');
      throw Exception('Error submitting nutrition data: $e');
    }
  }

  Future<HydrationCalculatorResponse> submitHydrationData(
    String sessionId,
    HydrationCalculatorRequest request,
  ) async {
    final uri = Uri.parse(Urls.hydrationCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      print('=== Hydration Calculator Request ===');
      print('URL: $uri');
      print('Headers: $headers');
      print('Request: ${request.toJson()}');
      print('====================================');

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(request.toJson()))
          .timeout(const Duration(seconds: 10));

      print('=== Hydration Calculator Response ===');
      print('Status Code: ${response.statusCode}');
      print(
        'Response Body: ${response.body.isEmpty ? '<empty>' : response.body}',
      );
      print('=====================================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.body.trim();

        if (body.isEmpty) {
          return HydrationCalculatorResponse(
            success: true,
            message: 'Hydration step saved.',
            data: null,
          );
        }

        try {
          final decodedBody = jsonDecode(body);
          if (decodedBody is Map<String, dynamic>) {
            return HydrationCalculatorResponse.fromJson(decodedBody);
          }

          throw const FormatException(
            'Hydration response was not a JSON object',
          );
        } on FormatException catch (e) {
          print('Hydration response parsing error: $e');
          return HydrationCalculatorResponse(
            success: true,
            message: 'Hydration step saved.',
            data: null,
          );
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final decodedBody = jsonDecode(response.body);
            if (decodedBody is Map<String, dynamic>) {
              throw Exception(
                decodedBody['message'] ?? 'Failed to submit hydration data',
              );
            }
          } catch (_) {
            // Fall through to the generic error below.
          }
        }

        throw Exception('Failed to submit hydration data');
      }
    } catch (e) {
      print('Hydration calculator error: $e');
      throw Exception('Error submitting hydration data: $e');
    }
  }
}
