import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@inject
class AddConnectionUseCase {
  AddConnectionUseCase(this._repository);

  final ConnectionsRepository _repository;

  void call(String id) => _repository.addConnection(id);
}
