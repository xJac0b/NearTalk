import 'package:flutter/material.dart';
import 'package:neartalk/presentation/styles/theme/app_theme.dart';

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    required this.appTheme,
    required super.child,
    super.key,
  });

  final AppTheme appTheme;

  static AppTheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    return provider!.appTheme;
  }

  @override
  bool updateShouldNotify(covariant AppThemeProvider oldWidget) {
    return oldWidget.appTheme != appTheme;
  }
}
