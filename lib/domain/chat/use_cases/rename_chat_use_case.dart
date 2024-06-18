import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class RenameChatUseCase {
  RenameChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(String chatId, String name) async =>
      await _repository.renameChat(chatId, name);
}
