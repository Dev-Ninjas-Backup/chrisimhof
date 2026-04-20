import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';

class QuickEntrySelector extends StatelessWidget {
  final Function(String, int) onEntrySelected;

  const QuickEntrySelector({
    super.key,
    required this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> entries = [
      {'name': 'Espresso', 'amount': 75},
      {'name': 'Coffee', 'amount': 75},
      {'name': 'Energy Drink', 'amount': 75},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Entry",
          style: getTextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: entries.map((entry) {
              return GestureDetector(
                onTap: () => onEntrySelected(entry['name'], entry['amount']),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry['name'],
                        style: getTextStyle(
                          color: AppColors.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${entry['amount']} mg",
                        style: getTextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}