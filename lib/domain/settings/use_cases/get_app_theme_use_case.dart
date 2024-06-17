import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class GetAppThemeUseCase {
  GetAppThemeUseCase(this._repository);

  final SettingsRepository _repository;

  ThemeMode call() => _repository.loadTheme();
}
