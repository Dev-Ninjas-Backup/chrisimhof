import 'package:flutter/material.dart';
import 'package:chrisimhof/core/const/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.black,
}) {
  return GoogleFonts.manrope(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getTextStyle2({
  double fontSize = 36.0,
  FontWeight fontWeight = FontWeight.w600,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.black,
}) {
  return GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
