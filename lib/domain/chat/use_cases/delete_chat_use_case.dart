import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class DeleteChatUseCase {
  DeleteChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(String id) => _repository.deleteChat(id);
}
