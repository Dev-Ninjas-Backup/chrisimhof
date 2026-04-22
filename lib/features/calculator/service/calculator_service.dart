import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/calculator/models/calculator_session_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_preset_model.dart';
import 'package:chrisimhof/features/calculator/models/caffeine_intake_model.dart';
import 'package:chrisimhof/features/calculator/models/hydration_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sleep_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/work_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/nutrition_calculator_model.dart';
import 'package:chrisimhof/features/calculator/models/sport_calculator_model.dart';
import 'package:chrisimhof/features/calculator/results/model/calculate_result_model.dart';
import 'package:http/http.dart' as http;

class CalculatorService {
  String _extractErrorMessage(dynamic message, String fallback) {
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    if (message is List) {
      final messages = message
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();

      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    return fallback;
  }

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

      if (response.statusCode == 200) {
        return CalculatorSessionResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to fetch calculator session',
        );
      }
    } catch (e) {
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SleepCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(
          _extractErrorMessage(
            jsonData['message'],
            'Failed to submit sleep data',
          ),
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(
          _extractErrorMessage(
            jsonData['message'],
            'Failed to submit work data',
          ),
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        return WorkCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(
          _extractErrorMessage(jsonData['message'], 'Failed to skip work'),
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        return NutritionCalculatorResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to submit nutrition data',
        );
      }
    } catch (e) {
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
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(request.toJson()))
          .timeout(const Duration(seconds: 10));

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
        } on FormatException {
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
      throw Exception('Error submitting hydration data: $e');
    }
  }

  Future<List<CaffeinePreset>> getCaffeinePresets() async {
    final uri = Uri.parse(Urls.caffeineQuickEntry);
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

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        final presets = <CaffeinePreset>[];
        for (int i = 0; i < jsonData.length; i++) {
          final item = jsonData[i] as Map<String, dynamic>;

          final preset = CaffeinePreset.fromJson(item);
          presets.add(preset);
        }

        return presets;
      } else {
        throw Exception('Failed to fetch caffeine presets');
      }
    } catch (e) {
      throw Exception('Error fetching caffeine presets: $e');
    }
  }

  Future<CaffeineIntakeResponse> submitCaffeineIntake(
    String sessionId,
    CaffeineIntakeRequest request,
  ) async {
    final uri = Uri.parse(Urls.addCaffeineIntake(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CaffeineIntakeResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to submit caffeine intake',
        );
      }
    } catch (e) {
      throw Exception('Error submitting caffeine intake: $e');
    }
  }

  Future<CaffeineIntakeResponse> skipCaffeineIntake(String sessionId) async {
    final uri = Uri.parse(Urls.skipCaffeineIntake(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CaffeineIntakeResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to skip caffeine intake',
        );
      }
    } catch (e) {
      throw Exception('Error skipping caffeine intake: $e');
    }
  }

  Future<SportResponse> submitSportData(
    String sessionId,
    SportRequest request,
  ) async {
    final uri = Uri.parse(Urls.sportsCalculator(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SportResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to submit sport activity',
        );
      }
    } catch (e) {
      throw Exception('Error submitting sport activity: $e');
    }
  }

  Future<CalculateResultResponse> calculateResult(String sessionId) async {
    final uri = Uri.parse(Urls.calculateResult(sessionId));
    final accessToken = await SharedPreferencesHelper.getAccessToken();

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CalculateResultResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to calculate result');
      }
    } catch (e) {
      throw Exception('Error calculating result: $e');
    }
  }
}
