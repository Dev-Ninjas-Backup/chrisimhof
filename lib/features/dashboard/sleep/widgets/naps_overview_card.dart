import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/dashboard/sleep/controller/sleep_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NapsOverviewCard extends StatelessWidget {
  final SleepController controller;

  const NapsOverviewCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final naps = controller.loggedNaps;
      final totalMin = controller.totalNapMinutes.value;
      final napCount = naps.length;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSoft, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.wb_twilight_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Naps'.tr,
                          style: getTextStyle2(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        Text(
                          napCount > 0
                              ? '$napCount nap${napCount > 1 ? 's' : ''} · ${totalMin}m total'
                              : 'No naps logged today'.tr,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Quick + Log Nap Button
                TextButton.icon(
                  onPressed: () => _showLogNapDialog(context),
                  icon: const Icon(Icons.add, size: 16, color: AppColors.addButtonColor),
                  label: Text(
                    'Log nap'.tr,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.addButtonColor,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE8FBF3),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Explanatory badge: Naps reduce acute debt without resetting the day
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Naps reduce 7-day sleep debt with zero reset to your circadian day.'.tr,
                      style: getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (naps.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: AppColors.borderSoft, height: 1),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: naps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final nap = naps[index];
                  final duration = (nap['durationMinutes'] as num?)?.toInt() ?? 30;
                  final timeStr = nap['timestamp'] as String? ?? 'Nap';
                  final quality = nap['quality'] as String? ?? 'refreshing';
                  final notes = nap['notes'] as String?;
                  final napId = nap['id'] as String? ?? '';

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFBFB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.bedtime_outlined,
                            size: 18,
                            color: Color(0xFF065F46),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$duration min',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2E8F0),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      timeStr,
                                      style: getTextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (notes != null && notes.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  notes,
                                  style: getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSoft,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF64748B)),
                          onPressed: () => _showEditNapDialog(context, napId, duration, quality, notes),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.rose),
                          onPressed: () => _confirmDeleteNap(context, napId),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      );
    });
  }

  void _showLogNapDialog(BuildContext context) {
    int selectedDuration = 30;
    String selectedQuality = 'refreshing';
    final notesController = TextEditingController();
    DateTime napTime = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Log a Nap'.tr,
                    style: getTextStyle2(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a recommended preset or set custom duration.'.tr,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSoft,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Duration Presets
                  Text(
                    'DURATION'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [20, 30, 45, 90].map((dur) {
                      final isSelected = selectedDuration == dur;
                      String label = '$dur min';
                      if (dur == 20) label = '20m (Power)';
                      if (dur == 90) label = '90m (Anchor)';
                      return ChoiceChip(
                        label: Text(
                          label,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.white : AppColors.primaryTextColor,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.addButtonColor,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.addButtonColor : Colors.transparent,
                          ),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => selectedDuration = dur);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Quality selector
                  Text(
                    'NAP QUALITY'.tr,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildQualityChip('refreshing', 'Refreshing'.tr, selectedQuality, (q) {
                        setState(() => selectedQuality = q);
                      }),
                      const SizedBox(width: 8),
                      _buildQualityChip('normal', 'Normal'.tr, selectedQuality, (q) {
                        setState(() => selectedQuality = q);
                      }),
                      const SizedBox(width: 8),
                      _buildQualityChip('grogginess', 'Grogginess'.tr, selectedQuality, (q) {
                        setState(() => selectedQuality = q);
                      }),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Notes input
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: 'Notes (e.g. pre-night shift anchor nap)'.tr,
                      hintStyle: getTextStyle(fontSize: 13, color: AppColors.textSoft),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        controller.logNap(
                          occurredAt: napTime,
                          durationMinutes: selectedDuration,
                          quality: selectedQuality,
                          notes: notesController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.addButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Nap'.tr,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQualityChip(
    String key,
    String label,
    String current,
    ValueChanged<String> onSelected,
  ) {
    final isSelected = key == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8FBF3) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.secondaryButtonColor : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.mintSoftText : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditNapDialog(
    BuildContext context,
    String entryId,
    int currentDuration,
    String currentQuality,
    String? currentNotes,
  ) {
    int duration = currentDuration;
    String quality = currentQuality;
    final notesController = TextEditingController(text: currentNotes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Nap'.tr,
                    style: getTextStyle2(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [20, 30, 45, 60, 90].map((dur) {
                      final isSelected = duration == dur;
                      return ChoiceChip(
                        label: Text('$dur min'),
                        selected: isSelected,
                        selectedColor: AppColors.addButtonColor,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.primaryTextColor,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => duration = dur);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: 'Notes'.tr,
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        controller.updateNapEntry(
                          entryId: entryId,
                          durationMinutes: duration,
                          quality: quality,
                          notes: notesController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.addButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Update Nap'.tr,
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteNap(BuildContext context, String entryId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Nap'.tr),
        content: Text('Are you sure you want to delete this nap?'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteNapEntry(entryId: entryId);
            },
            child: Text('Delete'.tr, style: const TextStyle(color: AppColors.rose)),
          ),
        ],
      ),
    );
  }
}
