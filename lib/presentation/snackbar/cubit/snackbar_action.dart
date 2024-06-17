part of 'snackbar_cubit.dart';

@freezed
sealed class SnackbarAction with _$SnackbarAction {
  const factory SnackbarAction.show() = SnackbarActionShow;
  const factory SnackbarAction.dismissed() = SnackbarActionDismissed;
}
