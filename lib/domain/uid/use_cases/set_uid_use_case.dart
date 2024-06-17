import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/uid/uid_repository.dart';

@inject
class SetUidUseCase {
  SetUidUseCase(this._repository);

  final UidRepository _repository;

  void call() => _repository.setUid();
}
