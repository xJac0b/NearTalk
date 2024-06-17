part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required List<Chat> chats,
    required bool isVisible,
  }) = _HomeState;
  factory HomeState.initial() => const HomeState(
        chats: [],
        isVisible: false,
      );
}
