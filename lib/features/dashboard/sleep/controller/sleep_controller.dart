import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chrisimhof/core/service/helper/shared_preferences_helper.dart';
import 'package:chrisimhof/core/service/realtime/realtime_socket_service.dart';
import 'package:chrisimhof/features/dashboard/sleep/service/sleep_service.dart';
import 'package:chrisimhof/features/dashboard/sleep/model/sleep_log.dart';
import 'package:chrisimhof/features/dashboard/main_dashboard/controller/dashboard_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SleepController extends GetxController {
  // Default to midnight / 06:00 — overridden from DashboardController's optimalBedtime on init
  final bedtimeHour = 22.obs;
  final bedtimeMinute = 30.obs;

  final wakeupHour = 6.obs;
  final wakeupMinute = 0.obs;

  final historyLogs = <SleepLog>[].obs;

  List<SleepLog> get filteredHistoryLogs {
    final idx = selectedDebtIndex.value;
    if (idx == -1 || sleepDebtChartData.isEmpty) return historyLogs;
    
    final todayIndex = sleepDebtChartData.indexWhere((d) => d['isToday'] == true);
    if (todayIndex == -1) return historyLogs;

    final offsetDays = idx - todayIndex;
    final targetDate = DateTime.now().add(Duration(days: offsetDays));

    return historyLogs.where((log) {
      final localDate = log.date.toLocal();
      return localDate.year == targetDate.year &&
             localDate.month == targetDate.month &&
             localDate.day == targetDate.day;
    }).toList();
  }

  final tonightBedtime = Rxn<Map<String, dynamic>>();
  final tonightNote = RxnString();

  /// From forYouPreview[sleep].body — e.g. "Aim for bed by 22:30 — your circadian window opens then."
  final forYouSleepBody = RxnString();

  /// From forYouPreview[sleep].bodyParams.bedtime — e.g. "22:30"
  final forYouSleepBedtime = RxnString();

  // Sleep Debt observables
  final sleepDebtLabel = RxString('rolling 7 days');
  final sleepDebtTotalDisplay = RxString('--');
  final sleepDebtChartData = <Map<String, dynamic>>[].obs;
  final selectedDebtIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    loadSleepHistory();
    // Preload tonight's bedtime and note from DashboardController if available
    if (Get.isRegistered<DashboardController>()) {
      final dbController = Get.find<DashboardController>();
      // Seed bedtime picker from the API's optimal bedtime
      _initBedtimeFromDashboard(dbController);
      if (dbController.sleepTabData.value != null) {
        updateFromLiveScoresTab(dbController.sleepTabData.value!);
      }
      // Seed forYouPreview sleep entry if DashboardController already has it
      final preview = dbController.forYouPreviewData.value;
      if (preview != null) updateFromForYouPreview(preview);
    }
  }

  void _initBedtimeFromDashboard(DashboardController dbController) {
    try {
      final optimal = dbController.dashboardData.value.optimalBedtime;
      final parts = optimal.split(':');
      if (parts.length == 2) {
        bedtimeHour.value = int.tryParse(parts[0]) ?? 22;
        bedtimeMinute.value = int.tryParse(parts[1]) ?? 30;
      }
    } catch (_) {}
  }

  Future<void> loadSleepHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString('sleepHistoryLogs');
      if (jsonStr != null) {
        final List decoded = jsonDecode(jsonStr);
        historyLogs.assignAll(decoded.map((item) => SleepLog(
          id: item['id'],
          date: DateTime.parse(item['date']),
          bedtime: TimeOfDay(hour: item['bedtimeHour'], minute: item['bedtimeMinute']),
          wakeupTime: TimeOfDay(hour: item['wakeupHour'], minute: item['wakeupMinute']),
          quality: item['quality'],
        )).toList());
      } else {
        _initializeMockHistory();
      }
    } catch (e) {
      debugPrint('Error loading sleep history: $e');
      _initializeMockHistory();
    }
  }

  Future<void> saveSleepHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listToSave = historyLogs.map((log) => {
        'id': log.id,
        'date': log.date.toIso8601String(),
        'bedtimeHour': log.bedtime.hour,
        'bedtimeMinute': log.bedtime.minute,
        'wakeupHour': log.wakeupTime.hour,
        'wakeupMinute': log.wakeupTime.minute,
        'quality': log.quality,
      }).toList();
      await prefs.setString('sleepHistoryLogs', jsonEncode(listToSave));
    } catch (e) {
      debugPrint('Error saving sleep history: $e');
    }
  }

  void _initializeMockHistory() async {
    // No mock data — start with an empty history and save empty state
    historyLogs.clear();
    await saveSleepHistory();
  }

  // Bedtime adjusters
  void incrementBedtimeHour() {
    bedtimeHour.value = (bedtimeHour.value + 1) % 24;
  }

  void decrementBedtimeHour() {
    bedtimeHour.value = (bedtimeHour.value - 1 + 24) % 24;
  }

  void incrementBedtimeMinute() {
    bedtimeMinute.value = (bedtimeMinute.value + 1) % 60;
  }

  void decrementBedtimeMinute() {
    bedtimeMinute.value = (bedtimeMinute.value - 1 + 60) % 60;
  }

  // Wakeup adjusters
  void incrementWakeupHour() {
    wakeupHour.value = (wakeupHour.value + 1) % 24;
  }

  void decrementWakeupHour() {
    wakeupHour.value = (wakeupHour.value - 1 + 24) % 24;
  }

  void incrementWakeupMinute() {
    wakeupMinute.value = (wakeupMinute.value + 1) % 60;
  }

  void decrementWakeupMinute() {
    wakeupMinute.value = (wakeupMinute.value - 1 + 60) % 60;
  }

  String get currentSleepDuration {
    final bedMinutes = bedtimeHour.value * 60 + bedtimeMinute.value;
    final wakeupMinutes = wakeupHour.value * 60 + wakeupMinute.value;

    int diffMinutes = wakeupMinutes - bedMinutes;
    if (diffMinutes < 0) {
      diffMinutes += 1440;
    }

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    return '${hours}h ${minutes}m';
  }

  void loadLogForEditing(SleepLog log) {
    bedtimeHour.value = log.bedtime.hour;
    bedtimeMinute.value = log.bedtime.minute;
    wakeupHour.value = log.wakeupTime.hour;
    wakeupMinute.value = log.wakeupTime.minute;
    EasyLoading.showToast('Loaded sleep log to edit'.tr);
  }

  final isNewMainWake = false.obs;
  final TextEditingController noteController = TextEditingController();

  void saveSleep() async {
    final oldLogs = List<SleepLog>.from(historyLogs);

    final now = DateTime.now();
    DateTime baseDate = now;
    final idx = selectedDebtIndex.value;
    if (idx != -1 && sleepDebtChartData.isNotEmpty) {
      final todayIndex = sleepDebtChartData.indexWhere((d) => d['isToday'] == true);
      if (todayIndex != -1) {
        final offsetDays = idx - todayIndex;
        baseDate = now.add(Duration(days: offsetDays));
      }
    }

    var wakeDt = DateTime(baseDate.year, baseDate.month, baseDate.day, wakeupHour.value, wakeupMinute.value);
    var sleepDt = DateTime(baseDate.year, baseDate.month, baseDate.day, bedtimeHour.value, bedtimeMinute.value);
    if (sleepDt.isAfter(wakeDt)) {
      sleepDt = sleepDt.subtract(const Duration(days: 1));
    }
    // Waking up cannot be in the future; if wakeDt is after current time, it refers to the past wake cycle
    if (wakeDt.isAfter(now)) {
      wakeDt = wakeDt.subtract(const Duration(days: 1));
      sleepDt = sleepDt.subtract(const Duration(days: 1));
    }

    final sleepStartedAt = sleepDt.toUtc().toIso8601String();
    final wakeRecordedAt = wakeDt.toUtc().toIso8601String();

    // Add to history logs
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      bedtime: TimeOfDay(hour: bedtimeHour.value, minute: bedtimeMinute.value),
      wakeupTime: TimeOfDay(hour: wakeupHour.value, minute: wakeupMinute.value),
      quality: 0,
    );

    final today = DateTime.now();
    final index = historyLogs.indexWhere(
      (log) => log.date.year == today.year && log.date.month == today.month && log.date.day == today.day
    );
    if (index != -1) {
      historyLogs[index] = newLog;
    } else {
      historyLogs.insert(0, newLog);
    }
    
    await saveSleepHistory();

    EasyLoading.show(status: 'Saving sleep...'.tr);
    try {
      final sessionId = await SharedPreferencesHelper.getSessionId();
      if (sessionId != null && sessionId.isNotEmpty) {
        bool sendIsNewMainWake = isNewMainWake.value;
        if (!sendIsNewMainWake && Get.isRegistered<DashboardController>()) {
          final currentStatus = Get.find<DashboardController>().sessionStatus.value;
          if (currentStatus == 'PENDING_WAKE' || currentStatus == 'FINALIZED') {
            sendIsNewMainWake = true;
          }
        }

        final result = await SleepService().saveSleep(
          sessionId: sessionId,
          sleepStartedAt: sleepStartedAt,
          wakeRecordedAt: wakeRecordedAt,
          isNewMainWake: sendIsNewMainWake,
          note: noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
        );

        final data = result['data'] as Map<String, dynamic>?;

        // Inspect conflicts returned by backend validation
        final dynamic rawConflicts = result['conflicts'] ?? data?['conflicts'];
        final List<dynamic>? conflictsList = rawConflicts is List ? rawConflicts : null;
        bool hasHardConflict = false;
        String? conflictMessage;
        String? softWarningMessage;

        if (conflictsList != null && conflictsList.isNotEmpty) {
          for (final c in conflictsList) {
            if (c is Map<String, dynamic>) {
              final isHard = c['isHard'] == true;
              final msg = c['message'] as String? ?? '';
              if (isHard) {
                hasHardConflict = true;
                conflictMessage = msg;
                break;
              } else if (softWarningMessage == null && msg.isNotEmpty) {
                softWarningMessage = msg;
              }
            }
          }
        }

        if (result['success'] == false || hasHardConflict || (data != null && data['saved'] == false)) {
          historyLogs.assignAll(oldLogs);
          await saveSleepHistory();

          final conflictMsg = conflictMessage ??
              (data?['message'] as String?) ??
              (result['message'] as String?) ??
              'Sleep overlap conflict detected. Please adjust.'.tr;
          EasyLoading.showError(conflictMsg);
          return;
        }

        if (softWarningMessage != null && softWarningMessage.isNotEmpty) {
          EasyLoading.showInfo(softWarningMessage);
        }

        final returnedSessionId = data?['sessionId'] as String?;
        final returnedStatus = data?['status'] as String?;

        if (returnedSessionId != null && returnedSessionId.isNotEmpty) {
          await SharedPreferencesHelper.saveSessionId(returnedSessionId);
          await RealtimeSocketService().connectSocket();
        }

        if (data != null && data['liveScores'] != null) {
          RealtimeSocketService().handleLiveScores(data['liveScores'], useLocalCaches: false);
        }

        try {
          if (Get.isRegistered<DashboardController>()) {
            final dashboardController = Get.find<DashboardController>();
            if (returnedSessionId != null && returnedSessionId.isNotEmpty) {
              dashboardController.currentSessionId.value = returnedSessionId;
            }
            if (returnedStatus != null && returnedStatus.isNotEmpty) {
              dashboardController.sessionStatus.value = returnedStatus;
            }
            await dashboardController.fetchDashboardData();
          }
        } catch (_) {}

        isNewMainWake.value = false;
        noteController.clear();

        EasyLoading.showSuccess('Sleep logged successfully!'.tr);
        Get.back();
      } else {
        EasyLoading.showError('No active session found.'.tr);
      }
    } catch (e) {
      historyLogs.assignAll(oldLogs);
      await saveSleepHistory();
      debugPrint('Error saving sleep: $e');
      final msg = e.toString().replaceFirst('Exception: ', '');
      EasyLoading.showError(msg.isNotEmpty ? msg : 'Failed to save sleep log.'.tr);
    }
  }

  void addSleepLog({
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) async {
    final newLog = SleepLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      bedtime: bedtime,
      wakeupTime: wakeupTime,
      quality: quality,
    );
    historyLogs.insert(0, newLog);
    historyLogs.sort((a, b) => b.date.compareTo(a.date));
    await saveSleepHistory();
    EasyLoading.showSuccess('Sleep log added!'.tr);
  }

  void updateSleepLog({
    required String id,
    required DateTime date,
    required TimeOfDay bedtime,
    required TimeOfDay wakeupTime,
    required int quality,
  }) async {
    final index = historyLogs.indexWhere((log) => log.id == id);
    if (index != -1) {
      historyLogs[index] = SleepLog(
        id: id,
        date: date,
        bedtime: bedtime,
        wakeupTime: wakeupTime,
        quality: quality,
      );
      historyLogs.sort((a, b) => b.date.compareTo(a.date));
      await saveSleepHistory();
      EasyLoading.showSuccess('Sleep log updated!'.tr);
    }
  }

  void deleteLog(String id) async {
    historyLogs.removeWhere((log) => log.id == id);
    await saveSleepHistory();
    EasyLoading.showSuccess('Sleep log deleted!'.tr);
  }

  /// Called with the top-level liveScores payload to extract forYouPreview sleep entry.
  void updateFromForYouPreview(List<dynamic> forYouPreview) {
    try {
      final sleepEntry = forYouPreview.firstWhereOrNull(
        (item) => (item as Map<String, dynamic>)['category'] == 'sleep',
      ) as Map<String, dynamic>?;

      if (sleepEntry != null) {
        forYouSleepBody.value = sleepEntry['body'] as String?;
        final bodyParams = (sleepEntry['bodyParams'] ?? sleepEntry['params']) as Map<String, dynamic>?;
        forYouSleepBedtime.value = (bodyParams?['bedtime'] ?? bodyParams?['time']) as String?;
      } else {
        forYouSleepBody.value = null;
        forYouSleepBedtime.value = null;
      }
    } catch (e) {
      debugPrint('SleepController forYouPreview parse error: $e');
    }
  }

  /// Updates bedtime and wakeup window from work.nextSleepWindow (shift-aware calculation)
  void updateFromNextSleepWindow(Map<String, dynamic> sleepWindow) {
    try {
      final start = (sleepWindow['sleepStart'] ?? sleepWindow['time']) as String?;
      final end = (sleepWindow['sleepEnd'] ?? sleepWindow['wakeTime']) as String?;

      if (start != null && start.isNotEmpty) {
        final currentMap = tonightBedtime.value != null
            ? Map<String, dynamic>.from(tonightBedtime.value!)
            : <String, dynamic>{};
        currentMap['sleepStart'] = start;
        if (end != null && end.isNotEmpty) {
          currentMap['wakeTime'] = end;
          final wParts = end.split(':');
          if (wParts.length == 2) {
            wakeupHour.value = int.tryParse(wParts[0]) ?? wakeupHour.value;
            wakeupMinute.value = int.tryParse(wParts[1]) ?? wakeupMinute.value;
          }
        }
        tonightBedtime.value = currentMap;

        final bParts = start.split(':');
        if (bParts.length == 2) {
          bedtimeHour.value = int.tryParse(bParts[0]) ?? bedtimeHour.value;
          bedtimeMinute.value = int.tryParse(bParts[1]) ?? bedtimeMinute.value;
        }
      }
    } catch (e) {
      debugPrint('SleepController updateFromNextSleepWindow error: $e');
    }
  }

  void updateFromLiveScoresTab(Map<String, dynamic> tabData) {
    try {
      if (tabData['sleepStartTime'] != null && tabData['sleepStartTime'] is String) {
        final parts = (tabData['sleepStartTime'] as String).split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            bedtimeHour.value = h;
            bedtimeMinute.value = m;
          }
        }
      }

      if (tabData['wakeTime'] != null && tabData['wakeTime'] is String) {
        final parts = (tabData['wakeTime'] as String).split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            wakeupHour.value = h;
            wakeupMinute.value = m;
          }
        }
      }

      // Handle tonightBedtime (supports String e.g. "20:15" or Map e.g. {"sleepStart": "20:15", "wakeTime": "04:00"})
      String? parsedBedtimeStr;
      if (tabData['tonightBedtime'] != null) {
        if (tabData['tonightBedtime'] is Map) {
          final map = Map<String, dynamic>.from(tabData['tonightBedtime']);
          tonightBedtime.value = map;
          parsedBedtimeStr = (map['sleepStart'] ?? map['time']) as String?;
          if (map['wakeTime'] != null && map['wakeTime'] is String) {
            final wParts = (map['wakeTime'] as String).split(':');
            if (wParts.length == 2) {
              wakeupHour.value = int.tryParse(wParts[0]) ?? wakeupHour.value;
              wakeupMinute.value = int.tryParse(wParts[1]) ?? wakeupMinute.value;
            }
          }
        } else if (tabData['tonightBedtime'] is String) {
          parsedBedtimeStr = tabData['tonightBedtime'] as String;
          final currentMap = tonightBedtime.value != null
              ? Map<String, dynamic>.from(tonightBedtime.value!)
              : <String, dynamic>{};
          currentMap['sleepStart'] = parsedBedtimeStr;
          tonightBedtime.value = currentMap;
        }
      } else {
        tonightBedtime.value = null;
      }

      if (parsedBedtimeStr != null && parsedBedtimeStr.isNotEmpty) {
        final parts = parsedBedtimeStr.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            bedtimeHour.value = h;
            bedtimeMinute.value = m;
          }
        }
      }

      tonightNote.value = tabData['tonightNote'] as String?;

      if (tabData['sleepDebt7d'] != null) {
        final debtData = tabData['sleepDebt7d'];
        sleepDebtLabel.value = debtData['label'] as String? ?? 'rolling 7 days';
        sleepDebtTotalDisplay.value = debtData['display'] as String? ?? '--';
        
        if (debtData['chartData'] != null) {
          final chartList = List<Map<String, dynamic>>.from(debtData['chartData']);
          sleepDebtChartData.assignAll(chartList);
          
          // Auto-select today if nothing is selected or if we just loaded
          final todayIndex = chartList.indexWhere((day) => day['isToday'] == true);
          if (todayIndex != -1) {
            selectedDebtIndex.value = todayIndex;
          } else if (chartList.isNotEmpty && selectedDebtIndex.value == -1) {
            selectedDebtIndex.value = chartList.length - 1;
          }
        }
      }

      final List? historyList = tabData['history'] as List?;
      if (historyList != null) {
        final List<SleepLog> parsedLogs = [];
        for (var item in historyList) {
          try {
            final date = DateTime.tryParse(item['date'] ?? '') ?? DateTime.now();
            final bedTimeStr = item['sleepStartTime'] as String? ?? '23:00';
            final wakeTimeStr = item['wakeTime'] as String? ?? '07:00';

            final bedParts = bedTimeStr.split(':');
            final wakeParts = wakeTimeStr.split(':');

            final bedtime = TimeOfDay(
              hour: bedParts.length == 2 ? int.parse(bedParts[0]) : 23,
              minute: bedParts.length == 2 ? int.parse(bedParts[1]) : 0,
            );

            final wakeupTime = TimeOfDay(
              hour: wakeParts.length == 2 ? int.parse(wakeParts[0]) : 7,
              minute: wakeParts.length == 2 ? int.parse(wakeParts[1]) : 0,
            );

            parsedLogs.add(SleepLog(
              id: item['id'] as String? ?? 'server_${date.millisecondsSinceEpoch}',
              date: date,
              bedtime: bedtime,
              wakeupTime: wakeupTime,
              quality: (item['quality'] as num?)?.toInt() ?? 85,
            ));
          } catch (e) {
            debugPrint('SleepController socket item parsing error: $e');
          }
        }
        
        // Preserve optimistic logs that are not yet returned by the server on the same day
        final optimisticLogs = historyLogs.where((log) => int.tryParse(log.id) != null).toList();
        for (var optLog in optimisticLogs) {
          final hasSameDay = parsedLogs.any((pLog) =>
              pLog.date.year == optLog.date.year &&
              pLog.date.month == optLog.date.month &&
              pLog.date.day == optLog.date.day);
          if (!hasSameDay) {
            parsedLogs.add(optLog);
          }
        }
        parsedLogs.sort((a, b) => b.date.compareTo(a.date));
        historyLogs.assignAll(parsedLogs);
        saveSleepHistory();
      }
    } catch (e) {
      debugPrint('SleepController socket update error: $e');
    }
  }
}
