import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class DeleteMessageUseCase {
  DeleteMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(String chatId, String messageId) =>
      _repository.deleteMessage(chatId, messageId);
}
