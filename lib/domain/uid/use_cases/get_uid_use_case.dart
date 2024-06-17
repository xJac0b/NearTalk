import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/uid/uid_repository.dart';

@inject
class GetUidUseCase {
  GetUidUseCase(this._repository);

  final UidRepository _repository;

  String call() => _repository.getUid();
}
