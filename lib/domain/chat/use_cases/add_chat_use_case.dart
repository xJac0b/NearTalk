import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';
import 'package:neartalk/domain/chat/models/chat.dart';

@inject
class AddChatUseCase {
  AddChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(Chat chat) => _repository.addChat(chat);
}
