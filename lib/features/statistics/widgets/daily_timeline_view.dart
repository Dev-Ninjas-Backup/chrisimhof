import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/service/helper/timezone_helper.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/date_range_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTimelineView extends StatelessWidget {
  final StatisticsController controller;

  const DailyTimelineView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateRangeNavigationBar(controller: controller),
        const SizedBox(height: 16),

        // Main Timeline Card
        _buildTimelineCard(context),
        const SizedBox(height: 20),

        // Recommendations Section
        _buildRecommendationsSection(context),
      ],
    );
  }

  Widget _buildTimelineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chronologie quotidienne'.tr,
                style: getTextStyle2(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Obx(() {
                final tl = controller.dailyTimelineData.value;
                String cycleBadge = '24h cycle'.tr;
                if (tl?['startUtc'] != null && tl?['endUtc'] != null) {
                  try {
                    final s = TimezoneHelper.parseSessionUtcToLocal(
                      tl!['startUtc'].toString(),
                    );
                    final e = TimezoneHelper.parseSessionUtcToLocal(
                      tl['endUtc'].toString(),
                    );
                    final h = (e.difference(s).inMinutes / 60.0).round();
                    if (h > 0) {
                      cycleBadge = '${h}h cycle'.tr;
                    }
                  } catch (_) {}
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cycleBadge,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF047857),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal 6-Track Timeline container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 580,
              child: Obx(() => _buildDynamicTracks(context)),
            ),
          ),
          const SizedBox(height: 16),

          // Inline event detail card (highlighted on tap as per Brief 03)
          Obx(() {
            final ev = controller.selectedTimelineEvent;
            if (ev.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.touch_app_outlined,
                      size: 16,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'timeline_touche_event_detail'.tr,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: Color(0xFF047857),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ev['title'] ?? ''} · ${ev['time'] ?? ''}',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => controller.selectedTimelineEvent.clear(),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDynamicTracks(BuildContext context) {
    final timeline = controller.dailyTimelineData.value;
    final tracks = timeline?['tracks'] as Map<String, dynamic>?;

    DateTime windowStart;
    if (timeline?['startUtc'] != null) {
      try {
        windowStart = TimezoneHelper.parseSessionUtcToLocal(
          timeline!['startUtc'].toString(),
        );
      } catch (_) {
        final sel = controller.myDaySelectedDate.value;
        windowStart = DateTime(sel.year, sel.month, sel.day, 7, 0);
      }
    } else {
      final sel = controller.myDaySelectedDate.value;
      windowStart = DateTime(sel.year, sel.month, sel.day, 7, 0);
    }

    DateTime windowEnd;
    if (timeline?['endUtc'] != null) {
      try {
        windowEnd = TimezoneHelper.parseSessionUtcToLocal(
          timeline!['endUtc'].toString(),
        );
      } catch (_) {
        windowEnd = windowStart.add(const Duration(hours: 24));
      }
    } else {
      windowEnd = windowStart.add(const Duration(hours: 24));
    }

    final totalMinutes = windowEnd.difference(windowStart).inMinutes > 0
        ? windowEnd.difference(windowStart).inMinutes
        : 1440;

    double calcLeft(DateTime time) {
      final diff = time.difference(windowStart).inMinutes;
      return ((diff / totalMinutes) * 500.0).clamp(0.0, 480.0);
    }

    double calcWidth(int durationMin, double left) {
      return ((durationMin / totalMinutes) * 500.0).clamp(20.0, 500.0 - left);
    }

    final sleepList = (tracks?['sleep'] as List?) ?? [];
    final workList = (tracks?['work'] as List?) ?? [];
    final hydrationList = (tracks?['hydration'] as List?) ?? [];
    final caffeineList = (tracks?['caffeine'] as List?) ?? [];
    final mealsList = (tracks?['meals'] as List?) ?? [];
    final exerciseList = (tracks?['exercise'] as List?) ?? [];

    final allTracksEmpty =
        sleepList.isEmpty &&
        workList.isEmpty &&
        hydrationList.isEmpty &&
        caffeineList.isEmpty &&
        mealsList.isEmpty &&
        exerciseList.isEmpty;

    return Column(
      children: [
        // Time markers header
        _buildTimeAxisHeader(windowStart, totalMinutes),
        const SizedBox(height: 8),

        // Track 1: Sleep (Main + Nap)
        _buildTrackRow(
          label: 'Sleep'.tr,
          icon: Icons.bedtime_outlined,
          color: const Color(0xFF047857),
          child: sleepList.isNotEmpty
              ? Stack(
                  children: sleepList.map<Widget>((s) {
                    final isNap = s['type'] == 'nap';
                    final start = s['start'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            s['start'].toString(),
                          )
                        : windowStart;
                    final dur = (s['durationMin'] as num?)?.toInt() ?? 60;
                    final left = calcLeft(start);
                    final width = calcWidth(dur, left);
                    final timeStr =
                        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
                    final title = isNap
                        ? 'Nap · ${dur}m'
                        : 'Main Sleep · ${dur ~/ 60}h ${dur % 60}m';
                    return _buildEventBar(
                      left: left,
                      width: width,
                      color: isNap
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFF047857),
                      iconColor: isNap
                          ? const Color(0xFF047857)
                          : AppColors.white,
                      icon: isNap
                          ? Icons.bedtime_outlined
                          : Icons.nightlight_round,
                      title: title,
                      time: timeStr,
                      isNap: isNap,
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        // Track 2: Work
        _buildTrackRow(
          label: 'Work'.tr,
          icon: Icons.work_outline_rounded,
          color: const Color(0xFF2563EB),
          child: workList.isNotEmpty
              ? Stack(
                  children: workList.map<Widget>((w) {
                    final start = w['start'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            w['start'].toString(),
                          )
                        : windowStart.add(const Duration(hours: 14));
                    final end = w['end'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            w['end'].toString(),
                          )
                        : start.add(const Duration(hours: 8));
                    final dur = end.difference(start).inMinutes;
                    final left = calcLeft(start);
                    final width = calcWidth(dur, left);
                    final title = (w['label'] ?? 'Shift').toString();
                    final timeStr =
                        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} – ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
                    return _buildEventBar(
                      left: left,
                      width: width,
                      color: const Color(0xFF1E3A8A),
                      icon: Icons.work_outline_rounded,
                      title: title,
                      time: timeStr,
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        // Track 3: Hydration
        _buildTrackRow(
          label: 'Hydration'.tr,
          icon: Icons.water_drop_outlined,
          color: const Color(0xFF0EA5E9),
          child: hydrationList.isNotEmpty
              ? Stack(
                  children: hydrationList.map<Widget>((h) {
                    final time = h['time'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            h['time'].toString(),
                          )
                        : windowStart;
                    final left = calcLeft(time);
                    final vol = h['volumeMl'] ?? 250;
                    final timeStr =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    return _buildEventDot(
                      left: left,
                      icon: Icons.water_drop,
                      label: '${vol}ml',
                      time: timeStr,
                      dotColor: const Color(0xFF0EA5E9),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        // Track 4: Caffeine
        _buildTrackRow(
          label: 'Caffeine'.tr,
          icon: Icons.coffee_outlined,
          color: const Color(0xFFD97706),
          child: caffeineList.isNotEmpty
              ? Stack(
                  children: caffeineList.map<Widget>((c) {
                    final time = c['time'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            c['time'].toString(),
                          )
                        : windowStart;
                    final left = calcLeft(time);
                    final mg = c['mg'] ?? 80;
                    final drink = c['drinkType'] ?? 'Coffee';
                    final timeStr =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    return _buildEventDot(
                      left: left,
                      icon: Icons.coffee_rounded,
                      label: '$drink · ${mg}mg',
                      time: timeStr,
                      dotColor: const Color(0xFFD97706),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        // Track 5: Meals
        _buildTrackRow(
          label: 'Meals'.tr,
          icon: Icons.restaurant_outlined,
          color: const Color(0xFFE11D48),
          child: mealsList.isNotEmpty
              ? Stack(
                  children: mealsList.map<Widget>((m) {
                    final time = m['time'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            m['time'].toString(),
                          )
                        : windowStart;
                    final left = calcLeft(time);
                    final heaviness = (m['heaviness'] ?? 'Meal').toString();
                    final timeStr =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    return _buildEventDot(
                      left: left,
                      icon: Icons.restaurant,
                      label: '${heaviness.capitalizeFirst} meal',
                      time: timeStr,
                      dotColor: const Color(0xFFE11D48),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        // Track 6: Exercise
        _buildTrackRow(
          label: 'Exercise'.tr,
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF8B5CF6),
          child: exerciseList.isNotEmpty
              ? Stack(
                  children: exerciseList.map<Widget>((e) {
                    final start = e['start'] != null
                        ? TimezoneHelper.parseSessionUtcToLocal(
                            e['start'].toString(),
                          )
                        : windowStart;
                    final dur = (e['durationMin'] as num?)?.toInt() ?? 45;
                    final left = calcLeft(start);
                    final width = calcWidth(dur, left);
                    final sport = (e['sportType'] ?? 'Exercise').toString();
                    final timeStr =
                        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
                    return _buildEventBar(
                      left: left,
                      width: width,
                      color: const Color(0xFF8B5CF6),
                      icon: Icons.fitness_center_rounded,
                      title: '${sport.capitalizeFirst} · ${dur}m',
                      time: timeStr,
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),

        if (allTracksEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Text(
                  'timeline_activity_record'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeAxisHeader(DateTime windowStart, int totalMinutes) {
    final times = List.generate(7, (i) {
      final t = windowStart.add(Duration(minutes: (totalMinutes * i ~/ 6)));
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    });

    return Row(
      children: [
        const SizedBox(width: 80),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: times.map((t) {
              return Text(
                t,
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackRow({
    required String label,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBar({
    required double left,
    required double width,
    required Color color,
    required IconData icon,
    required String title,
    required String time,
    Color? iconColor,
    bool isNap = false,
  }) {
    return Positioned(
      left: left,
      top: 3,
      bottom: 3,
      width: width,
      child: GestureDetector(
        onTap: () {
          controller.selectedTimelineEvent.assignAll({
            'title': title,
            'time': time,
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: iconColor ?? AppColors.white),
              if (width > 60) ...[
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isNap ? const Color(0xFF047857) : AppColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDot({
    required double left,
    required IconData icon,
    required String label,
    required String time,
    Color dotColor = const Color(0xFF0EA5E9),
  }) {
    return Positioned(
      left: left,
      top: 4,
      bottom: 4,
      child: GestureDetector(
        onTap: () {
          controller.selectedTimelineEvent.assignAll({
            'title': label,
            'time': time,
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: dotColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: dotColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: dotColor),
              const SizedBox(width: 3),
              Text(
                time,
                style: getTextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: dotColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    return Obx(() {
      final tl = controller.dailyTimelineData.value;
      final apiRecs = tl?['recommendations'] as List?;
      List<Map<String, dynamic>> items = [];

      if (apiRecs != null && apiRecs.isNotEmpty) {
        items = apiRecs.map((r) {
          final cat = (r['category'] ?? '').toString().toLowerCase();
          final meta = _getRecommendationCategoryMeta(cat);
          return {
            'title': (r['title'] ?? meta['defaultTitle']).toString(),
            'time': (r['time'] ?? r['cutoffTime'] ?? '').toString(),
            'type': cat.capitalizeFirst ?? 'General',
            'icon': meta['icon'] as IconData,
            'color': meta['color'] as Color,
            'desc': (r['body'] ?? r['desc'] ?? '').toString(),
          };
        }).toList();
      }

      if (items.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommandations du jour'.tr,
              style: getTextStyle2(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Center(
                child: Text(
                  'no_recomendation_today'.tr,
                  style: getTextStyle(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommandations du jour'.tr,
            style: getTextStyle2(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: items.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (r['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        r['icon'] as IconData,
                        size: 20,
                        color: r['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  r['title'] as String,
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              if ((r['time'] as String).isNotEmpty)
                                Text(
                                  r['time'] as String,
                                  style: getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: r['color'] as Color,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            r['desc'] as String,
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Map<String, dynamic> _getRecommendationCategoryMeta(String category) {
    switch (category) {
      case 'caffeine':
        return {
          'icon': Icons.coffee_outlined,
          'color': const Color(0xFFD97706),
          'defaultTitle': 'Caffeine guidance'.tr,
        };
      case 'sleep':
      case 'nap':
        return {
          'icon': Icons.bedtime_outlined,
          'color': const Color(0xFF047857),
          'defaultTitle': 'Sleep window'.tr,
        };
      case 'sport':
      case 'exercise':
        return {
          'icon': Icons.fitness_center_rounded,
          'color': const Color(0xFF8B5CF6),
          'defaultTitle': 'Workout opportunity'.tr,
        };
      case 'hydration':
        return {
          'icon': Icons.water_drop_outlined,
          'color': const Color(0xFF0EA5E9),
          'defaultTitle': 'Hydration target'.tr,
        };
      case 'meals':
      case 'nutrition':
        return {
          'icon': Icons.restaurant_outlined,
          'color': const Color(0xFFE11D48),
          'defaultTitle': 'Meal timing'.tr,
        };
      default:
        return {
          'icon': Icons.lightbulb_outline_rounded,
          'color': const Color(0xFF10B981),
          'defaultTitle': 'Circadian tip'.tr,
        };
    }
  }
}
