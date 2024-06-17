import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';
import 'package:neartalk/presentation/styles/colors/app_colors.dart';

class AppTheme {
  AppTheme({
    required this.colors,
  });
  AppTheme.dark() : colors = AppColors.dark;
  AppTheme.light() : colors = AppColors.light;

  factory AppTheme.fromType(ThemeMode? type, Brightness platformBrightness) {
    return switch (type) {
      ThemeMode.light => AppTheme.light(),
      ThemeMode.dark => AppTheme.dark(),
      _ => platformBrightness == Brightness.light
          ? AppTheme.light()
          : AppTheme.dark()
    };
  }

  final BaseColors colors;

  ThemeData get theme {
    final typo = AppTypography.fromColors(colors);
    return (colors == AppColors.dark ? ThemeData.dark() : ThemeData.light())
        .copyWith(
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(colors.surfaceBright),
        trackColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return colors.primary;
            }
            return colors.hint;
          },
        ),
        trackOutlineWidth: const MaterialStatePropertyAll(0),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
      ),
      primaryColor: colors.primary,
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        indicator: BoxDecoration(color: colors.tabIndicator),
        labelColor: colors.primary,
        unselectedLabelColor: colors.hint,
        labelStyle: typo.caption,
      ),
      cardTheme: CardTheme(
        color: colors.surfaceBright,
      ),
      iconTheme: IconThemeData(size: 24.sp, color: colors.text),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.buttonText,
        sizeConstraints: BoxConstraints.tightFor(width: 48.w, height: 48.h),
        iconSize: 24.sp,
      ),
      scaffoldBackgroundColor: colors.surface,
      textTheme: const TextTheme().apply(
        displayColor: colors.text,
        bodyColor: colors.text,
        fontFamily: fontFamily,
      ),
      inputDecorationTheme: InputDecorationTheme(
        counterStyle: typo.caption.copyWith(color: colors.captionText),
        hintStyle: typo.caption.copyWith(color: colors.hint),
        labelStyle: typo.caption.copyWith(color: colors.captionText),
        fillColor: colors.inputBackground,
        constraints: BoxConstraints(
          minHeight: 50.h,
          minWidth: 315.w,
          maxWidth: 315.w,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
        suffixStyle: typo.h1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        errorStyle: typo.caption.copyWith(color: colors.error),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          foregroundColor: colors.buttonText,
          backgroundColor: colors.primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(size: 24.sp, color: colors.text),
        titleTextStyle: typo.h6,
        backgroundColor: colors.surfaceBright,
      ),
    );
  }

  AppTheme copyWith({
    BaseColors? colors,
  }) {
    return AppTheme(
      colors: colors ?? this.colors,
    );
  }
}
