import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.rows, this.accent = false});

  final List<SettingsRowData> rows;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderSoft),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(rows.length, (index) {
          return SettingsRow(
            data: rows[index],
            accent: accent,
            showDivider: index < rows.length - 1,
          );
        }),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.data,
    required this.accent,
    required this.showDivider,
  });

  final SettingsRowData data;
  final bool accent;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: data.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            border: showDivider
                ? const Border(bottom: BorderSide(color: AppColors.borderSoft))
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent ? AppColors.mintSoft : AppColors.subtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  data.icon,
                  color: accent
                      ? AppColors.secondaryButtonColor
                      : AppColors.primaryTextColor,
                  size: 15,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.label.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: AppColors.primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (data.trailing != null) ...[
                const SizedBox(width: 8),
                Text(
                  data.trailing!.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.manrope(
                    color: data.highlightTrailing
                        ? AppColors.primaryButtonColor
                        : AppColors.textSoft,
                    fontSize: 11,
                    fontWeight: data.highlightTrailing
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsRowData {
  const SettingsRowData({
    required this.icon,
    required this.label,
    this.trailing,
    this.highlightTrailing = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final bool highlightTrailing;
  final VoidCallback? onTap;
}
