import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _appThemeKey = 'savedThemeType';
const _nameKey = 'savedName';
const _visibilityKey = 'savedVisibility';

@Singleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> saveTheme(ThemeMode themeType) async {
    await _sharedPreferences.setInt(
      _appThemeKey,
      themeType.index,
    );
  }

  @override
  ThemeMode loadTheme() {
    final savedType = _sharedPreferences.getInt(_appThemeKey);
    return switch (savedType) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  String loadName() {
    final name = _sharedPreferences.getString(_nameKey);
    return name ?? '';
  }

  @override
  bool loadVisibility() {
    final isVisible = _sharedPreferences.getBool(_visibilityKey);
    return isVisible ?? false;
  }

  @override
  Future<void> saveName(String name) async {
    await _sharedPreferences.setString(_nameKey, name);
  }

  @override
  Future<void> saveVisibility({required bool isVisible}) async {
    await _sharedPreferences.setBool(
      _visibilityKey,
      isVisible,
    );
  }
}
