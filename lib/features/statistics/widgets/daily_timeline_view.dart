import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/statistics/controller/statistics_controller.dart';
import 'package:chrisimhof/features/statistics/widgets/date_range_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTimelineView extends StatelessWidget {
  final StatisticsController controller;

  const DailyTimelineView({
    super.key,
    required this.controller,
  });

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '25h cycle'.tr,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal 6-Track Timeline container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 580,
              child: Column(
                children: [
                  // Time markers header
                  _buildTimeAxisHeader(),
                  const SizedBox(height: 8),

                  // Track 1: Sleep (Main + Nap)
                  _buildTrackRow(
                    label: 'Sleep'.tr,
                    icon: Icons.bedtime_outlined,
                    color: const Color(0xFF047857),
                    child: Stack(
                      children: [
                        _buildEventBar(
                          left: 0,
                          width: 140,
                          color: const Color(0xFF047857),
                          icon: Icons.nightlight_round,
                          title: 'Main Sleep · 7h 30m',
                          time: '07:00 – 14:30',
                        ),
                        _buildEventBar(
                          left: 230,
                          width: 45,
                          color: const Color(0xFFA7F3D0),
                          iconColor: const Color(0xFF047857),
                          icon: Icons.bedtime_outlined,
                          title: 'Nap · 30 min',
                          time: '17:30 – 18:00',
                          isNap: true,
                        ),
                      ],
                    ),
                  ),

                  // Track 2: Work
                  _buildTrackRow(
                    label: 'Work'.tr,
                    icon: Icons.work_outline_rounded,
                    color: const Color(0xFF2563EB),
                    child: _buildEventBar(
                      left: 310,
                      width: 200,
                      color: const Color(0xFF1E3A8A),
                      icon: Icons.work_outline_rounded,
                      title: 'Night Shift · 8h',
                      time: '22:00 – 06:00',
                    ),
                  ),

                  // Track 3: Hydration
                  _buildTrackRow(
                    label: 'Hydration'.tr,
                    icon: Icons.water_drop_outlined,
                    color: const Color(0xFF0EA5E9),
                    child: Stack(
                      children: [
                        _buildEventDot(left: 170, icon: Icons.water_drop, label: '500ml', time: '15:00'),
                        _buildEventDot(left: 250, icon: Icons.water_drop, label: '750ml', time: '18:30'),
                        _buildEventDot(left: 370, icon: Icons.water_drop, label: '500ml', time: '23:30'),
                      ],
                    ),
                  ),

                  // Track 4: Caffeine
                  _buildTrackRow(
                    label: 'Caffeine'.tr,
                    icon: Icons.coffee_outlined,
                    color: const Color(0xFFD97706),
                    child: Stack(
                      children: [
                        _buildEventDot(
                          left: 180,
                          icon: Icons.coffee_rounded,
                          label: 'Espresso · 100mg',
                          time: '15:15',
                          dotColor: const Color(0xFFD97706),
                        ),
                        _buildEventDot(
                          left: 270,
                          icon: Icons.coffee_rounded,
                          label: 'Tea · 45mg',
                          time: '19:45',
                          dotColor: const Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),

                  // Track 5: Meals
                  _buildTrackRow(
                    label: 'Meals'.tr,
                    icon: Icons.restaurant_outlined,
                    color: const Color(0xFFE11D48),
                    child: Stack(
                      children: [
                        _buildEventDot(
                          left: 190,
                          icon: Icons.restaurant,
                          label: 'Post-wake Meal',
                          time: '16:00',
                          dotColor: const Color(0xFFE11D48),
                        ),
                        _buildEventDot(
                          left: 330,
                          icon: Icons.lunch_dining_rounded,
                          label: 'Pre-shift Meal',
                          time: '21:00',
                          dotColor: const Color(0xFFE11D48),
                        ),
                      ],
                    ),
                  ),

                  // Track 6: Exercise
                  _buildTrackRow(
                    label: 'Exercise'.tr,
                    icon: Icons.fitness_center_rounded,
                    color: const Color(0xFF8B5CF6),
                    child: _buildEventBar(
                      left: 255,
                      width: 50,
                      color: const Color(0xFF8B5CF6),
                      icon: Icons.directions_run_rounded,
                      title: 'Running · 45m',
                      time: '18:45 – 19:30',
                    ),
                  ),
                ],
              ),
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
                    const Icon(Icons.touch_app_outlined, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Text(
                      'Touchez un événement pour afficher ses détails.'.tr,
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
                      const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF047857)),
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
                    child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeAxisHeader() {
    final times = ['07:00', '11:00', '15:00', '19:00', '23:00', '03:00', '07:00'];
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
    final recs = [
      {
        'title': 'Sieste stratégique'.tr,
        'time': '17:30',
        'type': 'Nap',
        'icon': Icons.bedtime_outlined,
        'color': const Color(0xFFF43F5E),
        'desc': 'Un power nap de 20-30 min restaurera votre vigilance avant votre shift de nuit.'.tr,
      },
      {
        'title': 'Fenêtre entraînement'.tr,
        'time': '18:45',
        'type': 'Exercise',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFF8B5CF6),
        'desc': 'Votre température corporelle et votre force musculaire culminent vers 19:00.'.tr,
      },
      {
        'title': 'Cut-off caféine'.tr,
        'time': '20:00',
        'type': 'Caffeine',
        'icon': Icons.coffee_outlined,
        'color': const Color(0xFFD97706),
        'desc': 'Évitez la caféine après 20:00 pour préserver la fenêtre de sommeil post-shift.'.tr,
      },
      {
        'title': 'Sommeil principal'.tr,
        'time': '07:30',
        'type': 'Sleep',
        'icon': Icons.nightlight_round,
        'color': const Color(0xFF047857),
        'desc': 'Retour au calme après votre quart de travail pour 7h-8h de récupération.'.tr,
      },
    ];

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
          children: recs.map((r) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (r['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(r['icon'] as IconData, size: 20, color: r['color'] as Color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              r['title'] as String,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
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
  }
}
