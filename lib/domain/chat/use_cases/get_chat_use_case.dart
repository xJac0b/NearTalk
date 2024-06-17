import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';
import 'package:neartalk/domain/chat/models/chat.dart';

@inject
class GetChatUseCase {
  GetChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<Chat?> call(String id) => _repository.getChat(id);
}
