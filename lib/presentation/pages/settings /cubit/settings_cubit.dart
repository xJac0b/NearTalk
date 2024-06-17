import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/visibility_controller.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

@inject
class SettingsCubit extends SafeCubit<SettingsState> {
  SettingsCubit(this._visibilityController)
      : super(const SettingsState.initial());

  final VisibilityController _visibilityController;
  Future<void> init() async {
    emit(
      SettingsState.loaded(
        isVisible: _visibilityController.isVisible,
      ),
    );
  }

  Future<void> changeVisibility({required bool isVisible}) async {
    await state.mapOrNull(
      loaded: (loaded) async {
        _visibilityController.changeVisibility(isVisible: isVisible);
        emit(loaded.copyWith(isVisible: isVisible));
      },
    );
  }
}
