import 'package:chrisimhof/core/common/widgets/custom_switch.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPreferencesBottomSheet extends StatelessWidget {
  const NotificationPreferencesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notification preferences'.tr,
                    style: getTextStyle2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 22),
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Customize the categories of circadian and lifestyle guidance you receive.'
                    .tr,
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Notification Categories
              Text(
                'REMINDERS & ALERTS'.tr,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                final prefs = controller.preferences.value;
                final bedtime = prefs?.bedtimeAlerts ?? true;
                final shift = prefs?.shiftReminders ?? true;
                final caffeine = prefs?.caffeineCutoff ?? true;
                final hydration = prefs?.hydrationReminders ?? true;
                final circadian = prefs?.circadianTransitions ?? true;
                final sport = prefs?.weeklySportReport ?? true;

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      // Bedtime
                      _buildRow(
                        icon: Icons.bedtime_outlined,
                        color: const Color(0xFF047857),
                        title: 'Bedtime & Wind-down alerts'.tr,
                        subtitle: 'Optimal bedtime & wind-down reminders'.tr,
                        value: bedtime,
                        onChanged: (val) =>
                            controller.updatePreferences(bedtimeAlerts: val),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),

                      // Shift
                      _buildRow(
                        icon: Icons.work_outline_rounded,
                        color: const Color(0xFF2563EB),
                        title: 'Shift reminders'.tr,
                        subtitle: 'Pre-shift alerts & light protocol'.tr,
                        value: shift,
                        onChanged: (val) =>
                            controller.updatePreferences(shiftReminders: val),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),

                      // Caffeine
                      _buildRow(
                        icon: Icons.coffee_outlined,
                        color: const Color(0xFFD97706),
                        title: 'Caffeine cut-off alerts'.tr,
                        subtitle: 'Clearance alerts before sleep windows'.tr,
                        value: caffeine,
                        onChanged: (val) =>
                            controller.updatePreferences(caffeineCutoff: val),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),

                      // Hydration
                      _buildRow(
                        icon: Icons.water_drop_outlined,
                        color: const Color(0xFF0EA5E9),
                        title: 'Hydration reminders'.tr,
                        subtitle: 'Pacing sips throughout your shift'.tr,
                        value: hydration,
                        onChanged: (val) => controller.updatePreferences(
                          hydrationReminders: val,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),

                      // Circadian
                      _buildRow(
                        icon: Icons.auto_mode_rounded,
                        color: const Color(0xFF8B5CF6),
                        title: 'Circadian transitions'.tr,
                        subtitle: 'Multi-day shift rotation adaptations'.tr,
                        value: circadian,
                        onChanged: (val) => controller.updatePreferences(
                          circadianTransitions: val,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),

                      // Weekly Sport
                      _buildRow(
                        icon: Icons.fitness_center_rounded,
                        color: const Color(0xFF10B981),
                        title: 'Weekly sport report'.tr,
                        subtitle: 'Workout pace & adaptive rest summary'.tr,
                        value: sport,
                        onChanged: (val) => controller.updatePreferences(
                          weeklySportReport: val,
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
