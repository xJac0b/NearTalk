part of 'theme_cubit.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState.initial() = ThemeStateInitial;
  const factory ThemeState.loading() = ThemeStateLoading;
  const factory ThemeState.loaded({
    required ThemeMode themeMode,
  }) = ThemeStateLoaded;
}
