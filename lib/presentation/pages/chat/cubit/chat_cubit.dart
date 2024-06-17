import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:neartalk/domain/chat/use_cases/add_message_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/delete_message_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/get_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/upload_file_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/watch_chat_use_case.dart';
import 'package:neartalk/domain/connections/connections_controller.dart';
import 'package:neartalk/domain/connections/connections_repository.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@inject
class ChatCubit extends SafeCubit<ChatState> {
  ChatCubit(
      this._getChatUseCase,
      this._addMessageUseCase,
      this._watchChatUseCase,
      this._connectionsController,
      this._deleteMessageUseCase,
      this._uploadFileUseCase)
      : super(ChatState.initial());
  final GetChatUseCase _getChatUseCase;
  final AddMessageUseCase _addMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final WatchChatUseCase _watchChatUseCase;
  final ConnectionsController _connectionsController;
  final UploadFileUseCase _uploadFileUseCase;
  StreamSubscription<Connections>? _connectionsSubscription;
  StreamSubscription<BoxEvent>? _chatSubscription;

  Future<void> init(String id) async {
    final chat = await _getChatUseCase(id);
    if (chat == null) {
      emit(const ChatState.error('Chat not found'));
    } else {
      emit(ChatState(chat: chat, isConnected: false));

      _connectionsSubscription =
          _connectionsController.stream.listen((connections) {
        Logger().d(connections);
        var isConnected = connections.containsKey(chat.endpointId);
        if (!isConnected) {
          isConnected =
              connections.values.any((element) => element.contains(chat.id));
        }

        _chatSubscription = _watchChatUseCase(key: id).listen((event) {
          loadChat(id);
        });
        emit((state as _ChatState)
            .copyWith(chat: chat, isConnected: isConnected));
      });
    }
  }

  Stream<BoxEvent> watchChat(String id) {
    return _watchChatUseCase(key: id);
  }

  Future<void> loadChat(String id) async {
    final chat = await _getChatUseCase(id);
    if (chat == null) {
      emit(const ChatState.error('Chat not found'));
    } else {
      state.mapOrNull(
        (state) => emit(state.copyWith(chat: chat)),
      );
    }
  }

  void removeMessage(String id) {
    if (state is _Error) return;
    final chat = (state as _ChatState).chat;
    _deleteMessageUseCase(chat.id, id);
  }

  Future<void> sendMessage(String message) async {
    if (this.state is _Error) return;
    final state = this.state as _ChatState;
    final chat = state.chat;
    final newMessage = Message(
      me: true,
      text: message,
      timestamp: DateTime.now(),
      sent: state.isConnected,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    await _addMessageUseCase(chat.id, newMessage);
    await Nearby().sendBytesPayload(
        chat.endpointId, Uint8List.fromList(utf8.encode(message)));
  }

  Future<void> sendFile(XFile file) async {
    if (this.state is _Error) return;
    final state = this.state as _ChatState;
    final chat = state.chat;
    final path = await _uploadFileUseCase(chat.id, file.path);
    final newMessage = Message(
      me: true,
      text: '',
      path: path,
      timestamp: DateTime.now(),
      sent: state.isConnected,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    await _addMessageUseCase(chat.id, newMessage);
    await Nearby().sendFilePayload(chat.endpointId, path);
  }

  @override
  Future<void> close() {
    _connectionsSubscription?.cancel();
    _chatSubscription?.cancel();
    return super.close();
  }
}
