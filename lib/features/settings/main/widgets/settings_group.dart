import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.rows, this.accent = false});

  final List<SettingsRowData> rows;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.white,
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
            iconpath: rows[index].iconpath,
          );
        }),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.data,
    required this.accent,
    required this.showDivider,
    required this.iconpath,
  });

  final SettingsRowData data;
  final bool accent;
  final bool showDivider;
  final String iconpath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent ? AppColors.mintSoft : AppColors.subtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  data.iconpath,
                  color: accent
                      ? AppColors.secondaryButtonColor
                      : AppColors.primaryTextColor,
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.label.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                  style: getTextStyle(
                    color: data.highlightTrailing
                        ? AppColors.primaryButtonColor
                        : AppColors.textSoft,
                    fontSize: 14,
                    fontWeight: data.highlightTrailing
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.gray300,
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
    required this.label,
    this.trailing,
    this.highlightTrailing = false,
    this.onTap,
    required this.iconpath,
  });

  final String label;
  final String? trailing;
  final bool highlightTrailing;
  final VoidCallback? onTap;
  final String iconpath;
}
