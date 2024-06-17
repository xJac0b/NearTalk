import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';
import 'package:neartalk/domain/chat/models/message.dart';

@inject
class AddMessageUseCase {
  AddMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(String chatId, Message message) =>
      _repository.addMessage(chatId, message);
}
