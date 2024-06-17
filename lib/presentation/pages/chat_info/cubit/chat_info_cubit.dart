import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/use_cases/delete_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/get_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/upload_avatar_use_case.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';

part 'chat_info_cubit.freezed.dart';
part 'chat_info_state.dart';

@inject
class ChatInfoCubit extends SafeCubit<ChatInfoState> {
  ChatInfoCubit(this._getChatUseCase, this._deleteChatUseCase,
      this._connectionsController, this._uploadAvatarUseCase)
      : super(ChatInfoState.initial());

  final GetChatUseCase _getChatUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  final ConnectionsController _connectionsController;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  StreamSubscription<Connections>? _connectionsSubscription;

  Future<void> init(String id) async {
    final chat = await _getChatUseCase(id);
    if (chat == null) {
      emit(const ChatInfoState.error('Chat not found'));
    } else {
      _connectionsSubscription =
          _connectionsController.stream.listen((connections) {
        Logger().d(connections);
        final isConnected = connections.containsKey(chat.endpointId);
        emit(ChatInfoState(chat: chat, isConnected: isConnected));
      });
    }
  }

  Future<void> loadChat(String id) async {
    final chat = await _getChatUseCase(id);
    if (chat == null) {
      emit(const ChatInfoState.error('Chat not found'));
    } else {
      emit(ChatInfoState(chat: chat, isConnected: false));
    }
  }

  Future<void> deleteChat(String id) async {
    await _deleteChatUseCase(id);
  }

  Future<void> disconnect(String id) async =>
      await Nearby().disconnectFromEndpoint(id);

  Future<void> updateAvatar(String id, XFile file) async {
    await _uploadAvatarUseCase(id, file);
  }

  @override
  Future<void> close() {
    _connectionsSubscription?.cancel();
    return super.close();
  }
}
