typedef Connections
    = Map<String, String>; // connectionId/endpointId, deviceId/chatId

abstract class ConnectionsRepository {
  void addConnection(String id);
  String getDeviceId(String id);
  void addDeviceIdToConnection(String connectionId, String deviceId);
  void removeConnection(String id);
  Connections getConnections();
}
