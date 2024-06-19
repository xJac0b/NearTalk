part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required List<Chat> chats,
    required List<({String chatId, String? avatarPath, String name})>
        connectedChats,
    required bool isVisible,
  }) = _HomeState;
  factory HomeState.initial() => const HomeState(
        chats: [],
        connectedChats: [],
        isVisible: false,
      );
}
