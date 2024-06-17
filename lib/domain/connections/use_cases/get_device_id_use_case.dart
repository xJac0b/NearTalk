import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@inject
class GetDeviceIdUseCase {
  GetDeviceIdUseCase(this._repository);

  final ConnectionsRepository _repository;

  String call(String id) => _repository.getDeviceId(id);
}
