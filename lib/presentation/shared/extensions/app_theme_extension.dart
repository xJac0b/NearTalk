import 'package:flutter/material.dart';
import 'package:neartalk/presentation/styles/colors/app_colors.dart';
import 'package:neartalk/presentation/styles/theme/app_theme_provider.dart';

extension AppThemeProviderX on BuildContext {
  BaseColors get colors => AppThemeProvider.of(this).colors;
}
