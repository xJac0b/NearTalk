import 'package:flutter/material.dart';
import 'package:neartalk/presentation/styles/colors/dark_app_colors.dart';
import 'package:neartalk/presentation/styles/colors/light_app_colors.dart';

class AppColors {
  const AppColors._();

  static LightAppColor get light => const LightAppColor();
  static DarkAppColor get dark => const DarkAppColor();
}

abstract class BaseColors {
  const BaseColors({
    required this.text,
    required this.captionText,
    required this.buttonText,
    required this.error,
    required this.hint,
    required this.surface,
    required this.surfaceBright,
    required this.inputBackground,
    required this.correct,
    required this.warning,
    required this.primary,
    required this.remove,
    required this.tabIndicator,
  });

  final Color text;
  final Color captionText;
  final Color buttonText;
  final Color error;
  final Color hint;
  final Color surface;
  final Color surfaceBright;
  final Color inputBackground;
  final Color correct;
  final Color warning;
  final Color primary;
  final Color remove;
  final Color tabIndicator;
}
