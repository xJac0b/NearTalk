part of 'chat_info_cubit.dart';

@freezed
class ChatInfoState with _$ChatInfoState {
  const factory ChatInfoState({
    required Chat chat,
    required bool isConnected,
  }) = _ChatState;

  factory ChatInfoState.initial() => ChatInfoState(
        chat: Chat.empty(),
        isConnected: false,
      );
  const factory ChatInfoState.error(String error) = _Error;
}
