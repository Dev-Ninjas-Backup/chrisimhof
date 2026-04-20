import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/settings/subscriptions/model/subscription_plan_model.dart';
import 'package:http/http.dart' as http;

class SubscriptionsService {
  Future<SubscriptionPlansResponse> getSubscriptionPlans() async {
    final uri = Uri.parse(Urls.showSubscriptionPlans);
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
        return SubscriptionPlansResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to fetch subscription plans',
        );
      }
    } catch (e) {
      throw Exception('Error fetching subscription plans: $e');
    }
  }

  Future<UserResponse> getCurrentUser() async {
    final uri = Uri.parse(Urls.userMe);
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
        return UserResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to fetch current user');
      }
    } catch (e) {
      throw Exception('Error fetching current user: $e');
    }
  }

  Future<CheckoutResponse> initiateCheckout(String planId) async {
    final uri = Uri.parse(Urls.checkout);
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
            body: jsonEncode({'planId': planId}),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('Checkout response status: ${response.statusCode}');
      print('Checkout response body: $jsonData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckoutResponse.fromJson(jsonData);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to initiate checkout');
      }
    } catch (e) {
      print('Checkout error: $e');
      throw Exception('Error initiating checkout: $e');
    }
  }
}
