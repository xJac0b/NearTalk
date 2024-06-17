part of 'snackbar_cubit.dart';

@freezed
sealed class SnackbarState with _$SnackbarState {
  const factory SnackbarState.initial() = SnackbarStateInitial;
  const factory SnackbarState.message({
    required SnackbarMessage message,
  }) = SnackbarStateMessage;
}
