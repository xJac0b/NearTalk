import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@inject
class GetConnectionsUseCase {
  GetConnectionsUseCase(this._repository);

  final ConnectionsRepository _repository;

  Connections call() => _repository.getConnections();
}
