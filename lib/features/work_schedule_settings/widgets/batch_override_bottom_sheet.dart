import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:chrisimhof/features/work_schedule_settings/controller/work_schedule_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchOverrideBottomSheet extends StatefulWidget {
  final WorkScheduleSettingsController controller;

  const BatchOverrideBottomSheet({super.key, required this.controller});

  @override
  State<BatchOverrideBottomSheet> createState() =>
      _BatchOverrideBottomSheetState();
}

class _BatchOverrideBottomSheetState extends State<BatchOverrideBottomSheet> {
  late DateTime _startDate;
  late DateTime _endDate;
  String _selectedShiftCode = 'Off';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate.add(const Duration(days: 6));
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondaryButtonColor,
              onPrimary: AppColors.white,
              onSurface: AppColors.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  String _formatDisplayDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final daysCount = _endDate.difference(_startDate).inDays + 1;
    final allShifts = ['Off', 'Day', 'Evening', 'Night', ...widget.controller.shiftTimes.keys.where(
      (k) {
        final l = k.toLowerCase();
        return l != 'day' && l != 'evening' && l != 'night' && l != 'off';
      },
    )];

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 20
            : MediaQuery.of(context).padding.bottom + 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.date_range_rounded,
                        color: AppColors.secondaryButtonColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Batch Shift Override'.tr,
                      style: getTextStyle2(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSoft),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Set vacation, leave, or block shifts across multiple dates in a single action.'.tr,
              style: getTextStyle(
                fontSize: 13,
                color: AppColors.textSoft,
              ),
            ),
            const SizedBox(height: 20),

            // Date range card
            Text(
              'DATE RANGE'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ).copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDateRange,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.secondaryButtonColor,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_formatDisplayDate(_startDate)}  —  ${_formatDisplayDate(_endDate)}',
                            style: getTextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '@days days selected'.trParams({'days': daysCount.toString()}),
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryButtonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_calendar_rounded,
                      color: AppColors.textSoft,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Shift selection
            Text(
              'SELECT SHIFT TO APPLY'.tr,
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ).copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allShifts.map((shift) {
                final isSelected = _selectedShiftCode.toLowerCase() == shift.toLowerCase();
                final isOff = shift.toLowerCase() == 'off';

                return ChoiceChip(
                  label: Text(
                    isOff ? 'Off (Vacation/Leave)'.tr : shift.tr,
                    style: getTextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.primaryTextColor,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: isOff
                      ? const Color(0xFF059669)
                      : AppColors.secondaryButtonColor,
                  backgroundColor: AppColors.gray50,
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.borderSoft,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedShiftCode = shift;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await widget.controller.applyBatchOverrides(
                    _startDate,
                    _endDate,
                    _selectedShiftCode,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply to Range'.tr,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Clear overrides in range button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await widget.controller.clearBatchOverrides(
                    _startDate,
                    _endDate,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDC2626)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.layers_clear_rounded,
                      size: 16,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Clear Overrides in Range'.tr,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
