import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class SaveNameUseCase {
  SaveNameUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(String name) => _repository.saveName(name);
}
