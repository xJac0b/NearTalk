import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class GetVisibilityUseCase {
  GetVisibilityUseCase(this._repository);

  final SettingsRepository _repository;

  bool call() => _repository.loadVisibility();
}
