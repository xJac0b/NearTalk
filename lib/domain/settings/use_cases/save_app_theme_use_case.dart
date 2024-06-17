import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class SaveAppThemeUseCase {
  SaveAppThemeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(ThemeMode themeType) => _repository.saveTheme(themeType);
}
