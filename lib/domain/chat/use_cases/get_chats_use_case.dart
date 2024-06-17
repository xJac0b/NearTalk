import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';
import 'package:neartalk/domain/chat/models/chat.dart';

@inject
class GetChatsUseCase {
  GetChatsUseCase(this._repository);

  final ChatRepository _repository;

  Future<List<Chat>> call() => _repository.getChats();
}
