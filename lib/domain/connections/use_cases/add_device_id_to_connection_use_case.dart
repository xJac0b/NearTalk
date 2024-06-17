import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@inject
class AddDeviceIdToConnection {
  AddDeviceIdToConnection(this._repository);

  final ConnectionsRepository _repository;

  void call(String connectionId, String deviceId) =>
      _repository.addDeviceIdToConnection(connectionId, deviceId);
}
