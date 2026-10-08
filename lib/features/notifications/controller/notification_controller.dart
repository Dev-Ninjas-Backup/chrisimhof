import 'package:chrisimhof/features/notifications/model/notification_model.dart';
import 'package:chrisimhof/features/notifications/model/notification_preferences_model.dart';
import 'package:chrisimhof/features/notifications/service/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  final RxList<AppNotificationItem> notifications = <AppNotificationItem>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxInt totalCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool filterUnreadOnly = false.obs;
  final Rxn<NotificationPreferencesModel> preferences =
      Rxn<NotificationPreferencesModel>();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
    loadPreferences();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;
    try {
      if (!refresh) isLoading.value = true;
      final result = await _service.getNotifications(
        unreadOnly: filterUnreadOnly.value,
      );
      notifications.assignAll(result['notifications'] as List<AppNotificationItem>);
      unreadCount.value = result['unreadCount'] as int? ?? 0;
      totalCount.value = result['total'] as int? ?? 0;
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await _service.getUnreadCount();
      unreadCount.value = count;
    } catch (e) {
      debugPrint('Error fetching unread notification count: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !notifications[idx].isRead) {
      final item = notifications[idx];
      notifications[idx] = AppNotificationItem(
        id: item.id,
        title: item.title,
        body: item.body,
        channel: item.channel,
        isRead: true,
        sentAt: item.sentAt,
      );
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    }
    await _service.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    try {
      EasyLoading.show(status: 'Marking all as read...'.tr);
      final ok = await _service.markAllAsRead();
      if (ok) {
        notifications.assignAll(
          notifications
              .map(
                (item) => AppNotificationItem(
                  id: item.id,
                  title: item.title,
                  body: item.body,
                  channel: item.channel,
                  isRead: true,
                  sentAt: item.sentAt,
                ),
              )
              .toList(),
        );
        unreadCount.value = 0;
        EasyLoading.showSuccess('All notifications marked as read'.tr);
      } else {
        EasyLoading.showError('Failed to mark all as read'.tr);
      }
    } catch (e) {
      debugPrint('Error marking all notifications read: $e');
      EasyLoading.showError('Error updating notifications'.tr);
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final item = notifications.firstWhereOrNull((n) => n.id == id);
      notifications.removeWhere((n) => n.id == id);
      if (item != null && !item.isRead && unreadCount.value > 0) {
        unreadCount.value--;
      }
      await _service.deleteNotification(id);
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  Future<void> toggleUnreadFilter() async {
    filterUnreadOnly.value = !filterUnreadOnly.value;
    await fetchNotifications(refresh: true);
  }

  // Notification Preferences
  Future<void> loadPreferences() async {
    try {
      final prefs = await _service.getPreferences();
      preferences.value = prefs;
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
    }
  }

  Future<void> updatePreferences({
    bool? shiftReminders,
    int? shiftReminderMinutes,
    bool? bedtimeAlerts,
    int? bedtimeReminderMinutes,
    bool? caffeineCutoff,
    int? caffeineReminderMinutes,
    bool? hydrationReminders,
    bool? circadianTransitions,
    bool? weeklySportReport,
  }) async {
    try {
      final current = preferences.value ?? NotificationPreferencesModel();
      final updated = NotificationPreferencesModel(
        shiftReminders: shiftReminders ?? current.shiftReminders,
        shiftReminderMinutes:
            shiftReminderMinutes ?? current.shiftReminderMinutes,
        bedtimeAlerts: bedtimeAlerts ?? current.bedtimeAlerts,
        bedtimeReminderMinutes:
            bedtimeReminderMinutes ?? current.bedtimeReminderMinutes,
        caffeineCutoff: caffeineCutoff ?? current.caffeineCutoff,
        caffeineReminderMinutes:
            caffeineReminderMinutes ?? current.caffeineReminderMinutes,
        hydrationReminders: hydrationReminders ?? current.hydrationReminders,
        circadianTransitions:
            circadianTransitions ?? current.circadianTransitions,
        weeklySportReport: weeklySportReport ?? current.weeklySportReport,
      );

      preferences.value = updated;
      final Map<String, dynamic> body = {};
      if (shiftReminders != null) body['shiftReminders'] = shiftReminders;
      if (shiftReminderMinutes != null) {
        body['shiftReminderMinutes'] = shiftReminderMinutes;
      }
      if (bedtimeAlerts != null) body['bedtimeAlerts'] = bedtimeAlerts;
      if (bedtimeReminderMinutes != null) {
        body['bedtimeReminderMinutes'] = bedtimeReminderMinutes;
      }
      if (caffeineCutoff != null) body['caffeineCutoff'] = caffeineCutoff;
      if (caffeineReminderMinutes != null) {
        body['caffeineReminderMinutes'] = caffeineReminderMinutes;
      }
      if (hydrationReminders != null) {
        body['hydrationReminders'] = hydrationReminders;
      }
      if (circadianTransitions != null) {
        body['circadianTransitions'] = circadianTransitions;
      }
      if (weeklySportReport != null) {
        body['weeklySportReport'] = weeklySportReport;
      }

      await _service.updatePreferences(body);
    } catch (e) {
      debugPrint('Error updating notification preferences: $e');
    }
  }
}
