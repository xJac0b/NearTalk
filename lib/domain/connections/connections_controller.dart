import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';
import 'package:neartalk/domain/connections/use_cases/add_connection_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/add_device_id_to_connection_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/get_connections_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/remove_connection_use_case.dart';
import 'package:rxdart/rxdart.dart';

class ConnectionsController {
  ConnectionsController._(this._addConnectionUseCase,
      this._removeConnectionUseCase, this._addDeviceIdToConnection);

  @factoryMethod
  static Future<ConnectionsController> create(
    AddConnectionUseCase addConnectionUseCase,
    RemoveConnectionUseCase removeConnectionUseCase,
    GetConnectionsUseCase getConnectionsUseCase,
    AddDeviceIdToConnection addDeviceIdToConnection,
  ) async {
    final initialConnections = getConnectionsUseCase();
    final instance = ConnectionsController._(
        addConnectionUseCase, removeConnectionUseCase, addDeviceIdToConnection);
    await instance._initialize(initialConnections);
    return instance;
  }

  late final BehaviorSubject<Connections> _connectionsSubject;
  final AddConnectionUseCase _addConnectionUseCase;
  final RemoveConnectionUseCase _removeConnectionUseCase;
  final AddDeviceIdToConnection _addDeviceIdToConnection;

  Stream<Connections> get stream => _connectionsSubject.stream;

  Future<void> _initialize(Connections connections) async {
    _connectionsSubject = BehaviorSubject.seeded(connections);
  }

  void addConnection(String id) {
    _addConnectionUseCase(id);
    _connectionsSubject.add(_connectionsSubject.value..[id] = '');
  }

  void addDeviceIdToConnection(String connectionId, String deviceId) {
    _addDeviceIdToConnection(connectionId, deviceId);
    _connectionsSubject
        .add(_connectionsSubject.value..[connectionId] = deviceId);
  }

  void removeConnection(String id) {
    _removeConnectionUseCase(id);
    _connectionsSubject.add(_connectionsSubject.value..remove(id));
  }
}
