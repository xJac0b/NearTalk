import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/colors/app_colors.dart';

const fontFamily = 'PublicSans';

class AppTypography {
  AppTypography(
    this.textColor,
    this.captionTextColor,
    this.buttonTextColor,
    this.error,
  );
  factory AppTypography.fromColors(BaseColors colors) => AppTypography(
        colors.text,
        colors.captionText,
        colors.buttonText,
        colors.error,
      );

  factory AppTypography.of(BuildContext context) => AppTypography(
        context.colors.text,
        context.colors.captionText,
        context.colors.buttonText,
        context.colors.error,
      );
  final Color textColor;
  final Color captionTextColor;
  final Color buttonTextColor;
  final Color error;

  //Headlines
  TextStyle get h1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 64.sp,
        height: 1.25,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

  TextStyle get h2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 48.sp,
        height: 1.33,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h3 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h4 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h5 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h6 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.sp,
        height: 1.55,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

  //Texts
  TextStyle get subtitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get subtitleSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        height: 1.57,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w500,
      );

  TextStyle get errorText => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        height: 1.5,
        color: error,
        fontWeight: FontWeight.w500,
      );

  TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        height: 1.57,
        color: textColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        height: 1.5,
        color: captionTextColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get overline => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      );

  //Buttons
  TextStyle get buttonLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        height: 1.625,
        color: buttonTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );
  TextStyle get buttonMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        height: 1.71,
        color: buttonTextColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );
  TextStyle get buttonSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        color: buttonTextColor,
        fontWeight: FontWeight.w500,
      );
}
