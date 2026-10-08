import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/auth/widgets/icon_tile.dart';
import 'package:chrisimhof/features/notifications/controller/notification_controller.dart';
import 'package:chrisimhof/features/notifications/model/notification_model.dart';
import 'package:chrisimhof/features/notifications/widgets/notification_preferences_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            _buildHeader(context, controller),

            // Filter Tabs Row
            _buildFilterRow(controller),
            const SizedBox(height: 8),

            // Notifications List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondaryButtonColor,
                    ),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return RefreshIndicator(
                  color: AppColors.secondaryButtonColor,
                  onRefresh: () => controller.fetchNotifications(refresh: true),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      return _buildNotificationCard(context, controller, item);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    NotificationController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: IconTile(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Notifications'.tr,
                style: getTextStyle2(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() {
                if (controller.unreadCount.value == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: controller.markAllAsRead,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFA7F3D0),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Mark all as read'.tr,
                      style: getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                width: 36,
                height: 36,
                child: IconTile(
                  icon: Icons.tune_rounded,
                  onTap: () {
                    Get.bottomSheet(
                      const NotificationPreferencesBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(NotificationController controller) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Row(
        children: [
          Obx(() {
            final isAll = !controller.filterUnreadOnly.value;
            return GestureDetector(
              onTap: () {
                if (!isAll) controller.toggleUnreadFilter();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isAll
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'All'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isAll ? AppColors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          Obx(() {
            final isUnread = controller.filterUnreadOnly.value;
            final unread = controller.unreadCount.value;

            return GestureDetector(
              onTap: () {
                if (!isUnread) controller.toggleUnreadFilter();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isUnread
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      'Unread'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isUnread
                            ? AppColors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                    if (unread > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? const Color(0xFF10B981)
                              : const Color(0xFF047857),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unread',
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationController controller,
    AppNotificationItem item,
  ) {
    final meta = _getChannelMeta(item.channel);
    final icon = meta['icon'] as IconData;
    final color = meta['color'] as Color;

    String timeDisplay = '';
    final dt = item.sentAt;
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      timeDisplay = '${diff.inMinutes.clamp(1, 59)}m';
    } else if (diff.inHours < 24) {
      timeDisplay = '${diff.inHours}h';
    } else {
      timeDisplay = '${diff.inDays}d';
    }

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) {
        controller.deleteNotification(item.id);
      },
      child: GestureDetector(
        onTap: () {
          if (!item.isRead) {
            controller.markAsRead(item.id);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: item.isRead
                ? AppColors.white
                : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isRead
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFA7F3D0),
              width: item.isRead ? 1.0 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Channel Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(
                              fontSize: 13,
                              fontWeight: item.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        if (timeDisplay.isNotEmpty)
                          Text(
                            timeDisplay,
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),

              // Unread dot
              if (!item.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF047857),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(NotificationController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 44,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No notifications'.tr,
              style: getTextStyle2(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You are all caught up! Circadian and lifestyle reminders will appear here.'
                  .tr,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getChannelMeta(String channel) {
    switch (channel.toLowerCase()) {
      case 'sleep':
        return {
          'icon': Icons.bedtime_outlined,
          'color': const Color(0xFF047857),
        };
      case 'hydration':
        return {
          'icon': Icons.water_drop_outlined,
          'color': const Color(0xFF0EA5E9),
        };
      case 'caffeine':
        return {
          'icon': Icons.coffee_outlined,
          'color': const Color(0xFFD97706),
        };
      case 'meals':
      case 'nutrition':
        return {
          'icon': Icons.restaurant_outlined,
          'color': const Color(0xFFE11D48),
        };
      case 'sport':
      case 'exercise':
        return {
          'icon': Icons.fitness_center_rounded,
          'color': const Color(0xFF8B5CF6),
        };
      case 'shift':
      case 'work':
        return {
          'icon': Icons.work_outline_rounded,
          'color': const Color(0xFF2563EB),
        };
      default:
        return {
          'icon': Icons.notifications_active_outlined,
          'color': const Color(0xFF047857),
        };
    }
  }
}
