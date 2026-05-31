import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class RyvenzaTextField extends StatelessWidget {
  const RyvenzaTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.tr.toUpperCase(),
            style: GoogleFonts.manrope(
              color: AppColors.textSoft,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            cursorColor: AppColors.primaryTextColor,
            style: GoogleFonts.manrope(
              color: AppColors.primaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: hintText?.tr,
              hintStyle: GoogleFonts.manrope(
                color: AppColors.textSoft,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: 18, color: AppColors.textSoft),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: _border(AppColors.borderSoft),
              enabledBorder: _border(AppColors.borderSoft),
              focusedBorder: _border(AppColors.primaryButtonColor, width: 1.4),
              errorBorder: _border(AppColors.rose, width: 1.2),
              focusedErrorBorder: _border(AppColors.rose, width: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
