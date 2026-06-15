import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeRangeSelector extends StatelessWidget {
  final RxString startTime;
  final RxString endTime;
  final VoidCallback onTimeChanged;

  const TimeRangeSelector({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _pickTime(context, startTime),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'START',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    startTime.value,
                    style: getTextStyle2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4C1D95),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFF8B5CF6),
            size: 16,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _pickTime(context, endTime),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'END',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    endTime.value,
                    style: getTextStyle2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4C1D95),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> _pickTime(BuildContext context, RxString timeField) async {
    final currentParts = timeField.value.split(':');
    final currentHour = currentParts.isNotEmpty ? int.tryParse(currentParts[0]) ?? 12 : 12;
    final currentMinute = currentParts.length > 1 ? int.tryParse(currentParts[1]) ?? 0 : 0;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
    );
    if (picked != null) {
      final formattedHour = picked.hour.toString().padLeft(2, '0');
      final formattedMinute = picked.minute.toString().padLeft(2, '0');
      timeField.value = '$formattedHour:$formattedMinute';
      onTimeChanged();
    }
  }
}
