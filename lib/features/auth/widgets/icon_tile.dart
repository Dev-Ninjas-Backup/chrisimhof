import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  const IconTile({required this.icon, this.onTap, super.key});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.subtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryTextColor),
      ),
    );
  }
}
