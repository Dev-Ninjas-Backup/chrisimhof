import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:chrisimhof/core/const/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.prefixIcon,
    this.isRequired = false,
    this.suffixIcon,
  });

  final String label;
  final bool? isRequired;
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.tr.toUpperCase(),
            style: GoogleFonts.manrope(
              color: AppColors.textSoft,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
            style: getTextStyle(
              color: AppColors.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText?.tr,
              hintStyle: getTextStyle(
                color: AppColors.textSoft,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: 18, color: AppColors.textSoft),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.white,
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
