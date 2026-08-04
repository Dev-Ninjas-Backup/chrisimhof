import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/sports/controller/sports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfWorkouts extends StatelessWidget {
  const ListOfWorkouts({
    super.key,
    required this.controller,
  });

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
                      child: Image.asset(
                        session.iconPath,
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.directions_run,
                          size: 20,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
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

  void _showEditDeleteDialog(BuildContext context, SportSession session) {
    final titleLower = session.title.toLowerCase();
    String initialType = 'cardio';
    if (titleLower.contains('strength')) {
      initialType = 'strength';
    } else if (titleLower.contains('mobility') || titleLower.contains('walk')) {
      initialType = 'mobility';
    } else if (titleLower.contains('mixed')) {
      initialType = 'mixed';
    } else if (!titleLower.contains('cardio') && !titleLower.contains('run') && !titleLower.contains('cycl')) {
      initialType = 'other';
    }

    String initialZone = 'Z3';
    final subUpper = session.subtitle.toUpperCase();
    if (subUpper.contains('Z1')) initialZone = 'Z1';
    else if (subUpper.contains('Z2')) initialZone = 'Z2';
    else if (subUpper.contains('Z3')) initialZone = 'Z3';
    else if (subUpper.contains('Z4')) initialZone = 'Z4';
    else if (subUpper.contains('Z5')) initialZone = 'Z5';

    final durationCtrl = TextEditingController(text: '45');
    final distanceCtrl = TextEditingController();
    final selectedType = initialType.obs;
    final selectedIntensity = 'medium'.obs;
    final selectedZone = initialZone.obs;
    final selectedDate = DateTime.now().obs;
    final selectedTime = TimeOfDay.now().obs;

    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Workout Session Options'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.subtitle,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Date & Time'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            selectedDate.value = picked;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSoft),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSoft),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}',
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime.value,
                          );
                          if (picked != null) {
                            selectedTime.value = picked;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSoft),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_outlined, size: 14, color: AppColors.textSoft),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  selectedTime.value.format(context),
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Type'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ['cardio', 'strength', 'mobility', 'mixed', 'other'].map((typeVal) {
                    final isSel = selectedType.value == typeVal;
                    return GestureDetector(
                      onTap: () => selectedType.value = typeVal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFECFDF5) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? const Color(0xFF34D399) : AppColors.borderSoft,
                          ),
                        ),
                        child: Text(
                          typeVal,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSel ? const Color(0xFF059669) : AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Text(
                  'Duration (minutes)'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: 'min',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Intensity'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: ['low', 'medium', 'high'].map((val) {
                    final isSel = selectedIntensity.value == val;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => selectedIntensity.value = val,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primaryTextColor
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primaryTextColor
                                  : AppColors.borderSoft,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              val.toUpperCase(),
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSel
                                    ? Colors.white
                                    : AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Text(
                  'Heart Rate Zone'.tr,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: ['Z1', 'Z2', 'Z3', 'Z4', 'Z5'].map((zVal) {
                    final isSel = selectedZone.value == zVal;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => selectedZone.value = zVal,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFF3E8FF) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSel ? const Color(0xFF9333EA) : AppColors.borderSoft,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              zVal,
                              style: getTextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSel ? const Color(0xFF9333EA) : AppColors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (selectedType.value != 'cardio') ...[
                  const SizedBox(height: 14),
                  Text(
                    'Distance (km - optional)'.tr,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: distanceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. 5.0',
                      suffixText: 'km',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (session.id.isNotEmpty)
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.deleteWorkoutLog(session.id);
                },
                child: Text('Delete'.tr, style: const TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                final dur = int.tryParse(durationCtrl.text) ?? 45;
                final dist = selectedType.value != 'cardio' && distanceCtrl.text.isNotEmpty
                    ? double.tryParse(distanceCtrl.text)
                    : null;
                final d = selectedDate.value;
                final t = selectedTime.value;
                final fullDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
                Get.back();
                controller.editWorkoutLog(
                  session.id,
                  durationMinutes: dur,
                  intensity: selectedIntensity.value,
                  sportType: selectedType.value,
                  heartRateZone: selectedZone.value,
                  distanceKm: dist,
                  occurredAt: fullDateTime,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTextColor,
              ),
              child: Text('Save'.tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
