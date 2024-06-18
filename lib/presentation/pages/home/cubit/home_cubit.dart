import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/use_cases/get_chats_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/on_payload_received_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/on_payload_transfer_update_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/watch_chat_use_case.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/notifications/notifications_controller.dart';
import 'package:neartalk/domain/settings/use_cases/get_name_use_case.dart';
import 'package:neartalk/domain/settings/visibility_controller.dart';
import 'package:neartalk/domain/uid/use_cases/get_uid_use_case.dart';
import 'package:neartalk/presentation/shared/cubit/safe_action_cubit.dart';

part 'home_action.dart';
part 'home_cubit.freezed.dart';
part 'home_state.dart';

@inject
class HomeCubit extends SafeActionCubit<HomeState, HomeAction> {
  HomeCubit(
    this._getName,
    this._visibilityController,
    this._getChatsUseCase,
    this.watchChatUseCase,
    this._connectionsController,
    this._getUid,
    this._onPayloadReceivedUseCase,
    this._onPayloadTransferUpdateUseCase,
    this._notificationsController,
  ) : super(HomeState.initial());

  final GetNameUseCase _getName;
  final VisibilityController _visibilityController;
  final GetChatsUseCase _getChatsUseCase;
  final WatchChatUseCase watchChatUseCase;
  final ConnectionsController _connectionsController;
  final GetUidUseCase _getUid;
  final OnPayloadReceivedUseCase _onPayloadReceivedUseCase;
  final OnPayloadTransferUpdateUseCase _onPayloadTransferUpdateUseCase;
  final NotificationsController _notificationsController;

  Future<void> init() async {
    await loadChats();
    _visibilityController.stream.listen((isVisible) {
      if (isVisible) {
        startAdvertising();
      } else {
        Nearby().stopAdvertising();
      }
      emit(state.copyWith(isVisible: isVisible));
    });

    watchChatUseCase().listen((event) async {
      await loadChats();
    });
  }

  Future<void> loadChats() async {
    final chats = await _getChatsUseCase();
    emit(state.copyWith(chats: []));
    emit(state.copyWith(
        chats: chats
          ..sort((a, b) {
            final dateA =
                a.messages.isEmpty ? a.createdAt : a.messages.last.timestamp;
            final dateB =
                b.messages.isEmpty ? b.createdAt : b.messages.last.timestamp;

            return dateB.compareTo(dateA);
          })));
  }

  Future<void> startAdvertising() async {
    try {
      final name = _getName();
      await Nearby().stopAdvertising();
      await Nearby().startAdvertising(
        name,
        Strategy.P2P_CLUSTER,
        onConnectionInitiated: (String id, ConnectionInfo info) async {
          // Called whenever a discoverer requests connection
          Logger().i('Connection initiated: $id, $info');
          await _notificationsController.showNotification(
            title: 'Connection request',
            body: 'Device ${info.endpointName} wants to connect',
          );
          dispatch(HomeAction.connectionRequest(id, info));
        },
        onConnectionResult: (String id, Status status) async {
          // Called when connection is accepted/rejected
          Logger().i('Connection result: $id, $status');
          if (status == Status.CONNECTED) {
            _connectionsController.addConnection(id);
            await Nearby().sendBytesPayload(
                id, Uint8List.fromList(utf8.encode(_getUid())));
          }
        },
        onDisconnected: (String id) {
          // Callled whenever a discoverer disconnects from advertiser
          Logger().i('Disconnected: $id');
          _connectionsController.removeConnection(id);
        },
        serviceId: 'com.jpietruch.neartalk', // uniquely identifies your app
      );
    } catch (exception) {
      Logger().e(exception);
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }

  Future<void> acceptConnection(String id, String name) async {
    await Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (String endpointId, Payload payload) async =>
          await _onPayloadReceivedUseCase(
        endpointId: endpointId,
        payload: payload,
        name: name,
      ),
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) =>
          _onPayloadTransferUpdateUseCase(endpointId, payloadTransferUpdate),
    );
  }

  void enableNotifications() {
    _notificationsController.enable();
  }

  void disableNotifications() {
    _notificationsController.disable();
  }
}
