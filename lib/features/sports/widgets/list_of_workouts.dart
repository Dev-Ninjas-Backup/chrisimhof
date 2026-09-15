import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/core/const/icon_path.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:chrisimhof/features/sports/widgets/add_sport_session_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfWorkouts extends StatelessWidget {
  const ListOfWorkouts({super.key, required this.controller});

  final SportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: controller.sessionsList.map((session) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GestureDetector(
              onTap: () => _showEditDeleteDialog(context, session),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: _buildWorkoutIcon(session),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.title.tr,
                            style: getTextStyle2(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            session.subtitle.tr,
                            style: getTextStyle2(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSoft,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildWorkoutIcon(SportSession session) {
    final title = session.title.toLowerCase().trim();
    final isRest = title.contains('rest') || title.contains('repos');

    if (isRest) {
      return Image.asset(
        IconPath.restDay,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.bedtime_rounded,
          size: 20,
          color: AppColors.textSoft,
        ),
      );
    }

    if (title.contains('strength') ||
        title.contains('force') ||
        title.contains('renforcement') ||
        title.contains('musculation') ||
        title.contains('weight') ||
        title.contains('dumbbell') ||
        title.contains('haltère')) {
      return Image.asset(
        IconPath.strength,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.fitness_center_rounded,
          size: 20,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    if (title.contains('cycl') ||
        title.contains('vélo') ||
        title.contains('velo') ||
        title.contains('bike')) {
      return const Icon(
        Icons.directions_bike_rounded,
        size: 22,
        color: Color(0xFF7C3AED),
      );
    }

    if (title.contains('swim') ||
        title.contains('natation') ||
        title.contains('nage')) {
      return const Icon(Icons.pool_rounded, size: 22, color: Color(0xFF0284C7));
    }

    if (title.contains('walk') || title.contains('marche')) {
      return const Icon(
        Icons.directions_walk_rounded,
        size: 22,
        color: Color(0xFF059669),
      );
    }

    if (title.contains('cardio')) {
      return Image.asset(
        IconPath.yoga,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.self_improvement_rounded,
          size: 22,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    if (title.contains('run') ||
        title.contains('course') ||
        title.contains('jogging') ||
        title.contains('sprint')) {
      return Image.asset(
        IconPath.running,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.directions_run_rounded,
          size: 22,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    if (title.contains('mobility') ||
        title.contains('mobilité') ||
        title.contains('yoga') ||
        title.contains('stretch') ||
        title.contains('étirement') ||
        title.contains('pilates')) {
      return Image.asset(
        IconPath.running,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.self_improvement_rounded,
          size: 22,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    if (title.contains('mixed') || title.contains('mixte')) {
      return Image.asset(
        IconPath.mixed,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.sports_gymnastics_rounded,
          size: 20,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    if (session.iconPath.isNotEmpty && session.iconPath != IconPath.restDay) {
      return Image.asset(
        session.iconPath,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.sports_gymnastics_rounded,
          size: 20,
          color: Color(0xFF7C3AED),
        ),
      );
    }

    return Image.asset(
      IconPath.sport,
      width: 22,
      height: 22,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.sports_gymnastics_rounded,
        size: 20,
        color: Color(0xFF7C3AED),
      ),
    );
  }

  void _showEditDeleteDialog(BuildContext context, SportSession session) {
    AddSportSessionBottomsheet.show(
      context,
      controller: controller,
      sessionToEdit: session,
    );
  }
}
