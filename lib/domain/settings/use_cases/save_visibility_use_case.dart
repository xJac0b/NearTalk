import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class SaveVisibilityUseCase {
  SaveVisibilityUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call({required bool isVisible}) =>
      _repository.saveVisibility(isVisible: isVisible);
}
