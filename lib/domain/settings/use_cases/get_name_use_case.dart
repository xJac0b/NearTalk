import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/settings_repository.dart';

@inject
class GetNameUseCase {
  GetNameUseCase(this._repository);

  final SettingsRepository _repository;

  String call() => _repository.loadName();
}
