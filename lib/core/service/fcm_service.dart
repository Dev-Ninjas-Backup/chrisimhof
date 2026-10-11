import 'dart:convert';
import 'dart:io';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/notifications/controller/notification_controller.dart';
import 'package:chrisimhof/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const AndroidNotificationChannel highImportanceChannel =
    AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description:
          'This channel is used for important notifications and alerts.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
    '[FCM] Background message received: ${message.messageId} (channel: ${message.data['channel']})',
  );
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // 1. Request notification permissions (required for iOS & Android 13+)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

      // 2. Fetch and print FCM Registration Token prominently
      try {
        final token = await _messaging.getToken();
        debugPrint('\n==================================================');
        debugPrint('🔥 FCM REGISTRATION TOKEN:');
        debugPrint('$token');
        debugPrint('==================================================\n');
        print('🔥 FCM REGISTRATION TOKEN: $token');
      } catch (e) {
        debugPrint('[FCM] Error fetching initial token: $e');
      }

      // 3. iOS foreground presentation options
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 4. Initialize local notifications for heads-up popup notifications
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      await _localNotificationsPlugin.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: darwinInit,
        ),
        onDidReceiveNotificationResponse: (response) {
          _handleNotificationTap(null);
        },
      );

      // Create Android Notification Channel with MAX importance for heads-up popups
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(highImportanceChannel);

      // 5. Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('\n==================================================');
        debugPrint('🔥 FCM TOKEN REFRESHED:');
        debugPrint('$newToken');
        debugPrint('==================================================\n');
        print('🔥 FCM TOKEN REFRESHED: $newToken');
        syncTokenWithBackend(newToken);
      });

      // 6. Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          '[FCM] Foreground message received: ${message.notification?.title}',
        );
        _handleForegroundMessage(message);
      });

      // 7. App opened from background via notification tap
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint(
          '[FCM] Notification opened from background: ${message.data}',
        );
        _handleNotificationTap(message);
      });

      // 8. Check if app was opened from terminated state
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '[FCM] App launched from terminated state via notification: ${initialMessage.data}',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNotificationTap(initialMessage);
        });
      }

      // 9. Initial token sync if user is logged in
      await syncTokenWithBackend();
    } catch (e) {
      debugPrint('[FCM] Initialization error: $e');
    }
  }

  /// Syncs device FCM token with backend API (PATCH /api/v1/users/:userId/fcm-token)
  Future<bool> syncTokenWithBackend([String? tokenToSync]) async {
    try {
      String? token = tokenToSync;
      if (token == null) {
        try {
          if (Platform.isIOS) {
            final apnsToken = await _messaging.getAPNSToken();
            debugPrint('[FCM] iOS APNs token: $apnsToken');
          }
          token = await _messaging.getToken();
        } catch (tokenErr) {
          debugPrint(
            '[FCM] getToken note (normal on iOS Simulator or before APNs generated): $tokenErr',
          );
        }
      }

      if (token == null || token.trim().isEmpty) {
        debugPrint('[FCM] No FCM token available yet.');
        return false;
      }

      debugPrint('\n==================================================');
      debugPrint('🔥 FCM REGISTRATION TOKEN:');
      debugPrint('$token');

      await SharedPreferencesHelper.saveFcmToken(token);

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        debugPrint('[FCM] User not authenticated yet. Token stored locally.');
        return false;
      }

      // Retrieve or fetch userId
      String? userId = await SharedPreferencesHelper.getUserId();
      if (userId == null || userId.trim().isEmpty) {
        final profileResp = await http.get(
          Uri.parse(Urls.userMe),
          headers: {'accept': '*/*', 'Authorization': 'Bearer $accessToken'},
        );

        if (profileResp.statusCode == 200) {
          final data = jsonDecode(profileResp.body);
          userId = data['data']?['id'] as String?;
          if (userId != null && userId.isNotEmpty) {
            await SharedPreferencesHelper.saveUserId(userId);
          }
        }
      }

      if (userId == null || userId.trim().isEmpty) {
        debugPrint('[FCM] Unable to resolve userId for FCM sync.');
        return false;
      }

      final url = Urls.updateUserFcmToken(userId);
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'fcmToken': token}),
      );

      debugPrint(
        '[FCM] Token sync response [${response.statusCode}]: ${response.body}',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[FCM] Error syncing FCM token with backend: $e');
      return false;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // If NotificationController is active, refresh the feed & unread count
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications(refresh: true);
      Get.find<NotificationController>().fetchUnreadCount();
    }

    final title =
        message.notification?.title ??
        message.data['title'] ??
        'Notification'.tr;
    final body = message.notification?.body ?? message.data['body'] ?? '';

    if (body.isEmpty && title.isEmpty) return;

    // 1. Show system heads-up popup notification
    _localNotificationsPlugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          highImportanceChannel.id,
          highImportanceChannel.name,
          channelDescription: highImportanceChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );

    // 2. Display a sleek in-app notification banner
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF0F172A),
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      icon: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.secondaryButtonColor,
      ),
      onTap: (_) => _handleNotificationTap(message),
      mainButton: TextButton(
        onPressed: () => _handleNotificationTap(message),
        child: Text(
          'View'.tr,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryButtonColor,
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap([RemoteMessage? message]) {
    if (Get.currentRoute != AppRoutes.notificationCenterScreen) {
      Get.toNamed(AppRoutes.notificationCenterScreen);
    }
  }
}
