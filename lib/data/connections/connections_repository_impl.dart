import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';

@Singleton(as: ConnectionsRepository)
class ConnectionsRepositoryImpl implements ConnectionsRepository {
  ConnectionsRepositoryImpl();

  final Connections _connections = {};

  @override
  void addConnection(String id) => _connections[id] = '';

  @override
  void removeConnection(String id) => _connections.remove(id);

  @override
  Connections getConnections() => _connections;

  @override
  void addDeviceIdToConnection(String connectionId, String deviceId) =>
      _connections[connectionId] = deviceId;

  @override
  String getDeviceId(String id) => _connections[id] ?? '';
}
