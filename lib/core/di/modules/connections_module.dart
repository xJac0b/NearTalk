import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/connections/use_cases/add_connection_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/add_device_id_to_connection_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/get_connections_use_case.dart';
import 'package:neartalk/domain/connections/use_cases/remove_connection_use_case.dart';

@externalModule
abstract class ConnectionsModule {
  @preResolve
  @singleton
  Future<ConnectionsController> connectionsModule(
          AddConnectionUseCase addConnectionUseCase,
          RemoveConnectionUseCase removeConnectionUseCase,
          GetConnectionsUseCase getConnectionsUseCase,
          AddDeviceIdToConnection addDeviceIdToConnection) =>
      ConnectionsController.create(
          addConnectionUseCase,
          removeConnectionUseCase,
          getConnectionsUseCase,
          addDeviceIdToConnection);
}
