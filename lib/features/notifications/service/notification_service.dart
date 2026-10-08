import 'dart:convert';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/notifications/model/notification_model.dart';
import 'package:chrisimhof/features/notifications/model/notification_preferences_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    final url = Urls.notifications(page: page, limit: limit, unreadOnly: unreadOnly);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final data = json['data'] as Map<String, dynamic>? ?? {};
      final list = (data['notifications'] as List? ?? [])
          .map((n) => AppNotificationItem.fromJson(n))
          .toList();
      return {
        'notifications': list,
        'unreadCount': data['unreadCount'] ?? 0,
        'total': data['total'] ?? 0,
      };
    }
    return {'notifications': <AppNotificationItem>[], 'unreadCount': 0, 'total': 0};
  }

  Future<int> getUnreadCount() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.unreadNotificationCount;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['data']?['unreadCount'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      debugPrint('Failed to get unread notification count: $e');
    }
    return 0;
  }

  Future<bool> markAsRead(String id) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.markNotificationRead(id);

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Failed to mark notification read: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.markAllNotificationsRead;

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Failed to mark all notifications read: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.deleteNotification(id);

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Failed to delete notification: $e');
      return false;
    }
  }

  Future<NotificationPreferencesModel> getPreferences() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.notificationPreferences;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return NotificationPreferencesModel.fromJson(json['data'] ?? {});
      }
    } catch (e) {
      debugPrint('Failed to get notification preferences: $e');
    }
    return NotificationPreferencesModel();
  }

  Future<bool> updatePreferences(Map<String, dynamic> partialData) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final url = Urls.notificationPreferences;

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(partialData),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Failed to update notification preferences: $e');
      return false;
    }
  }
}
