import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> saveTheme(ThemeMode themeType);
  ThemeMode loadTheme();

  Future<void> saveVisibility({required bool isVisible});
  bool loadVisibility();

  Future<void> saveName(String name);
  String loadName();
}
