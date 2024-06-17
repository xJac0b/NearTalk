import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@inject
class RemoveConnectionUseCase {
  RemoveConnectionUseCase(this._repository);

  final ConnectionsRepository _repository;

  void call(String id) => _repository.removeConnection(id);
}
