part of 'permission_cubit.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState.initial() = _Initial;
  const factory PermissionState.permissions({
    required bool location,
    required bool storage,
    required bool bluetooth,
  }) = _Permissions;
}
