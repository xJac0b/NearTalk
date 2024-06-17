import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/app_theme_controller.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';

part 'theme_cubit.freezed.dart';
part 'theme_state.dart';

@inject
class ThemeCubit extends SafeCubit<ThemeState> {
  ThemeCubit(
    this._appThemeController,
  ) : super(const ThemeState.initial()) {
    _appThemeSubscription = _appThemeController.stream.listen(
      (mode) {
        state.mapOrNull(
          loaded: (state) => emit(state.copyWith(themeMode: mode)),
        );
      },
    );
  }

  late final StreamSubscription<ThemeMode> _appThemeSubscription;
  final AppThemeController _appThemeController;

  void init() {
    emit(ThemeState.loaded(themeMode: _appThemeController.themeType));
  }

  Future<void> changeTheme(ThemeMode? value) async {
    if (value == null) return;
    _appThemeController.changeTheme(value);
  }

  @override
  Future<void> close() async {
    await _appThemeSubscription.cancel();
    return super.close();
  }
}
