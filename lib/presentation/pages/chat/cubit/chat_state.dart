part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required Chat chat,
    required bool isConnected,
  }) = _ChatState;

  factory ChatState.initial() => ChatState(
        chat: Chat.empty(),
        isConnected: false,
      );

  const factory ChatState.error(String error) = _Error;
}
