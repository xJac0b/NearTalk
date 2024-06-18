import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/use_cases/add_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/on_payload_received_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/on_payload_transfer_update_use_case.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/connections/use_cases/get_device_id_use_case.dart';
import 'package:neartalk/domain/settings/use_cases/get_name_use_case.dart';
import 'package:neartalk/domain/uid/use_cases/get_uid_use_case.dart';
import 'package:neartalk/presentation/pages/scan/cubit/scan_result.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';

part 'scan_cubit.freezed.dart';
part 'scan_state.dart';

@inject
class ScanCubit extends SafeCubit<ScanState> {
  ScanCubit(
      this._getName,
      this._addChatUseCase,
      this._connectionsController,
      this._getUid,
      this._getDeviceIdUseCase,
      this._onPayloadReceivedUseCase,
      this._onPayloadTransferUpdateUseCase)
      : super(ScanState.initial());

  final AddChatUseCase _addChatUseCase;
  final ConnectionsController _connectionsController;
  final GetUidUseCase _getUid;
  final GetDeviceIdUseCase _getDeviceIdUseCase;
  final OnPayloadReceivedUseCase _onPayloadReceivedUseCase;
  final OnPayloadTransferUpdateUseCase _onPayloadTransferUpdateUseCase;

  StreamSubscription<Map<String, String>>? _connectionsSubscription;

  final GetNameUseCase _getName;
  Future<void> init() async {
    try {
      final name = _getName();
      await Nearby().stopDiscovery();
      await Nearby().startDiscovery(
        name,
        Strategy.P2P_CLUSTER,
        onEndpointFound: (String id, String username, String serviceId) async {
          Logger().i('Endpoint found: $id, $username, $serviceId');
          final Map<String, ScanResult> scanResults =
              Map.from(state.scanResults);
          final connected =
              (await _connectionsController.stream.first).containsKey(id);
          scanResults[id] = ScanResult(
            name: username,
            state: connected ? DeviceState.connected : DeviceState.idle,
          );
          emit(state.copyWith(scanResults: scanResults));
        },
        onEndpointLost: (String? id) {
          Logger().i('Endpoint lost: $id');
          final Map<String, ScanResult> scanResults =
              Map.from(state.scanResults);
          scanResults.remove(id);
          emit(state.copyWith(scanResults: scanResults));
        },
        serviceId: 'com.jpietruch.neartalk',
      );
    } catch (e) {
      Logger().e(e);
    }

    _connectionsSubscription = _connectionsController.stream.listen((event) {
      Logger().d('Connections: $event');

      final scanResults = state.scanResults.entries.toList();
      scanResults.sort((a, b) => event.containsKey(a.key) ? -1 : 1);
      for (int i = 0; i < scanResults.length; i++) {
        if (event.containsKey(scanResults[i].key)) {
          scanResults[i] = MapEntry(scanResults[i].key,
              scanResults[i].value.copyWith(state: DeviceState.connected));
        } else {
          scanResults[i] = MapEntry(scanResults[i].key,
              scanResults[i].value.copyWith(state: DeviceState.idle));
        }
      }
      emit(state.copyWith(scanResults: Map.fromEntries(scanResults)));
    });
  }

  Future<String?> writeMessage(String id, String name) async {
    final deviceId = _getDeviceIdUseCase(id);
    if (deviceId.isEmpty) return null;
    await _addChatUseCase(Chat(
        id: deviceId, endpointId: id, messages: [], name: name, paths: []));
    return deviceId;
  }

  Future<void> requestConnection(String id) async {
    final scanResults = Map<String, ScanResult>.from(state.scanResults);
    final result = state.scanResults[id];
    if (result == null) return;
    try {
      scanResults[id] = result.copyWith(state: DeviceState.requested);
      emit(state.copyWith(scanResults: scanResults));

      await Nearby().requestConnection(
        _getName(),
        id,
        onConnectionInitiated: (id, info) async {
          Logger().i('Connection initiated: $id, $info');
          await Nearby().acceptConnection(
            id,
            onPayLoadRecieved: (String endpointId, Payload payload) async =>
                await _onPayloadReceivedUseCase(
                    endpointId: endpointId,
                    payload: payload,
                    name: info.endpointName),
            onPayloadTransferUpdate:
                (endpointId, payloadTransferUpdate) async =>
                    await _onPayloadTransferUpdateUseCase(
                        endpointId, payloadTransferUpdate),
          );
        },
        onConnectionResult: (id, status) async {
          Logger().i('Connection result: $id, $status');
          final scanResults = Map<String, ScanResult>.from(state.scanResults);
          final result = state.scanResults[id];
          if (result == null) return;
          switch (status) {
            case Status.CONNECTED:
              _connectionsController.addConnection(id);
              await Nearby().sendBytesPayload(
                  id, Uint8List.fromList(utf8.encode(_getUid())));
            case Status.REJECTED:
              Logger().d(scanResults);
              scanResults[id] = result.copyWith(state: DeviceState.rejected);
              emit(ScanState(scanResults: Map.from(scanResults)));
              Logger().d(scanResults);
            case Status.ERROR:
              scanResults[id] = result.copyWith(state: DeviceState.error);
              emit(ScanState(scanResults: scanResults));
          }
        },
        onDisconnected: (id) {
          Logger().i('Disconnected: $id');
          _connectionsController.removeConnection(id);
        },
      );
    } catch (exception) {
      // called if request was invalid
      Logger().e(exception);
      scanResults[id] = result.copyWith(state: DeviceState.error);
      Logger().d(scanResults == state.scanResults);

      emit(const ScanState(scanResults: {}));
      emit(ScanState(scanResults: scanResults));
      Logger().d(scanResults);
    }
  }

  Future<void> disconnect(String id) async {
    await Nearby().disconnectFromEndpoint(id);
  }

  @override
  Future<void> close() async {
    await _connectionsSubscription?.cancel();
    await Nearby().stopDiscovery();
    return super.close();
  }
}
