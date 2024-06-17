import 'dart:convert';

import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:neartalk/domain/chat/use_cases/add_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/add_message_use_case.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/connections/use_cases/get_device_id_use_case.dart';
import 'package:neartalk/main.dart';

@inject
class OnPayloadReceivedUseCase {
  OnPayloadReceivedUseCase(
    this._addChatUseCase,
    this._addMessageUseCase,
    this._connectionsController,
    this._getDeviceIdUseCase,
  );

  final AddChatUseCase _addChatUseCase;
  final AddMessageUseCase _addMessageUseCase;
  final ConnectionsController _connectionsController;
  final GetDeviceIdUseCase _getDeviceIdUseCase;

  Future<void> call({
    required String endpointId,
    required Payload payload,
    required String name,
  }) async {
    Logger().d('payload id: ${payload.id}');
    var deviceId = _getDeviceIdUseCase(endpointId);
    if (deviceId.isEmpty) {
      deviceId = utf8.decode(payload.bytes?.toList() ?? []);
      _connectionsController.addDeviceIdToConnection(endpointId, deviceId);
      await _addChatUseCase(Chat(
          id: deviceId,
          endpointId: endpointId,
          messages: [],
          name: name,
          paths: []));
    } else {
      await _addChatUseCase(Chat(
          id: deviceId,
          endpointId: endpointId,
          messages: [],
          name: name,
          paths: []));
      if (payload.type == PayloadType.FILE && payload.uri != null) {
        filesToUpload[payload.id] = (deviceId: deviceId, uri: payload.uri!);

        return;
      }

      await _addMessageUseCase(
          deviceId,
          Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              me: false,
              text: payload.type == PayloadType.BYTES
                  ? utf8.decode(payload.bytes?.toList() ?? [])
                  : '',
              timestamp: DateTime.now()));
    }
  }
}
