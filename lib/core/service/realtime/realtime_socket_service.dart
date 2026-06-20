import 'package:chrisimhof/features/recomendations/controller/recomendations_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io_client;
import 'package:chrisimhof/core/service/end_points.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:chrisimhof/features/dashboard/work/controller/work_controller.dart';
import 'package:chrisimhof/features/hydration/controller/hydration_controller.dart';
import 'package:chrisimhof/features/dashboard/caffeine/controller/caffeine_controller.dart';
import 'package:chrisimhof/features/nutrition/controller/nutrition_controller.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:get/get.dart';

class RealtimeSocketService {
  static final RealtimeSocketService _instance =
      RealtimeSocketService._internal();

  factory RealtimeSocketService() {
    return _instance;
  }

  RealtimeSocketService._internal();

  io_client.Socket? _socket;
  String? _currentSessionId;

  io_client.Socket? get socket => _socket;

  Future<void> connectSocket() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final sessionId = await SharedPreferencesHelper.getSessionId();

      if (token == null || token.isEmpty) {
        debugPrint('Socket.io: Cannot connect, access token is missing.');
        return;
      }

      if (_socket != null && _socket!.connected) {
        debugPrint('Socket.io: Already connected.');
        if (_currentSessionId != sessionId && sessionId != null) {
          _joinSession(sessionId);
        }
        return;
      }

      _currentSessionId = sessionId;
      debugPrint('Socket.io: Connecting to ${Urls.realtimeSocket}');

      _socket = io_client.io(
        Urls.realtimeSocket,
        io_client.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .enableForceNew()
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint(
          'Socket.io: Connected successfully, socket ID: ${_socket!.id}',
        );
        if (_currentSessionId != null) {
          _joinSession(_currentSessionId!);
        }
      });

      _socket!.onConnectError((err) {
        debugPrint('Socket.io: Connection error: $err');
      });

      _socket!.onDisconnect((reason) {
        debugPrint('Socket.io: Disconnected, reason: $reason');
      });

      _socket!.on('reconnect', (_) {
        debugPrint('Socket.io: Reconnecting...');
        if (_currentSessionId != null) {
          _joinSession(_currentSessionId!);
        }
      });

      // Events from server
      _socket!.on('live_scores', (data) {
        debugPrint('Socket.io: Received live_scores event');
        handleLiveScores(data);
      });

      _socket!.on('dashboard', (data) {
        debugPrint('Socket.io: Received dashboard event');
        _handleDashboard(data);
      });

      _socket!.on('analytics', (data) {
        debugPrint('Socket.io: Received analytics event');
      });

      _socket!.on('session_ended', (data) {
        debugPrint('Socket.io: Received session_ended event');
        _handleSessionEnded(data);
      });

      _socket!.connect();
    } catch (e) {
      debugPrint('Socket.io: Error in connectSocket: $e');
    }
  }

  void disconnectSocket() {
    try {
      if (_currentSessionId != null && _socket != null && _socket!.connected) {
        _socket!.emit('leave_session', {'sessionId': _currentSessionId});
      }
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }
      _currentSessionId = null;
      debugPrint('Socket.io: Disconnected and socket cleared.');
    } catch (e) {
      debugPrint('Socket.io: Error in disconnectSocket: $e');
    }
  }

  void _joinSession(String sessionId) {
    if (_socket != null && _socket!.connected) {
      debugPrint('Socket.io: Emitting join_session for sessionId: $sessionId');
      _socket!.emit('join_session', {'sessionId': sessionId});
    }
  }

  void handleLiveScores(dynamic data, {bool useLocalCaches = true}) {
    if (data == null) return;
    try {
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.updateFromLiveScores(
          data,
          useLocalCaches: useLocalCaches,
        );
      }

      if (Get.isRegistered<SleepController>() &&
          data['tabs']?['sleep'] != null) {
        final sleepController = Get.find<SleepController>();
        sleepController.updateFromLiveScoresTab(data['tabs']['sleep']);
      }

      // Forward forYouPreview sleep entry via socket updates
      if (Get.isRegistered<SleepController>() &&
          data['forYouPreview'] is List) {
        Get.find<SleepController>().updateFromForYouPreview(
          data['forYouPreview'] as List<dynamic>,
        );
      }

      if (Get.isRegistered<WorkController>()) {
        final workController = Get.find<WorkController>();
        if (data['tabs']?['work'] != null) {
          workController.updateFromLiveScoresTab(data['tabs']['work']);
        }
        if (data['workShapesToday'] is List) {
          workController.updateWorkShapesToday(data['workShapesToday'] as List<dynamic>);
        } else if (data['shapesToday'] is List) {
          workController.updateWorkShapesToday(data['shapesToday'] as List<dynamic>);
        }
      }

      if (Get.isRegistered<HydrationController>() &&
          data['tabs']?['hydration'] != null) {
        Get.find<HydrationController>().updateFromLiveScoresTab(
          data['tabs']['hydration'],
        );
      }

      if (Get.isRegistered<HydrationController>() &&
          data['forYouPreview'] is List) {
        Get.find<HydrationController>().updateFromForYouPreview(
          data['forYouPreview'] as List<dynamic>,
        );
      }

      if (Get.isRegistered<CaffeineController>() &&
          data['tabs']?['caffeine'] != null) {
        Get.find<CaffeineController>().updateFromLiveScoresTab(
          data['tabs']['caffeine'],
        );
      }

      // Forward forYouPreview caffeine entry via socket updates
      if (Get.isRegistered<CaffeineController>() &&
          data['forYouPreview'] is List) {
        Get.find<CaffeineController>().updateFromForYouPreview(
          data['forYouPreview'] as List<dynamic>,
        );
      }

      if (Get.isRegistered<NutritionController>() &&
          data['tabs']?['nutrition'] != null) {
        Get.find<NutritionController>().updateFromLiveScoresTab(
          data['tabs']['nutrition'],
        );
      }

      if (Get.isRegistered<SportsController>() &&
          data['tabs']?['sport'] != null) {
        Get.find<SportsController>().updateFromLiveScoresTab(
          data['tabs']['sport'],
        );
      }

      // Forward cards.sport (recoveryLoadScore + readinessNote) via socket updates
      final socketCards = data['cards'];
      if (Get.isRegistered<SportsController>() &&
          socketCards is Map &&
          socketCards['sport'] is Map) {
        Get.find<SportsController>().updateFromSportCard(
          Map<String, dynamic>.from(socketCards['sport'] as Map),
        );
      }

      // Forward forYouPreview to RecommendationController
      if (Get.isRegistered<RecommendationController>() &&
          data['forYouPreview'] is List) {
        Get.find<RecommendationController>().updateFromForYouPreview(
          data['forYouPreview'] as List<dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Socket.io: Error handling live_scores payload: $e');
    }
  }

  void _handleDashboard(dynamic data) {
    if (data == null) return;
    try {
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.updateFromDashboardEvent(data);
      }
    } catch (e) {
      debugPrint('Socket.io: Error handling dashboard payload: $e');
    }
  }

  void _handleSessionEnded(dynamic data) {
    try {
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.endMyDay();
      }
    } catch (e) {
      debugPrint('Socket.io: Error handling session_ended: $e');
    }
  }
}
