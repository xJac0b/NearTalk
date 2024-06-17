import 'package:hive/hive.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class WatchChatUseCase {
  WatchChatUseCase(this._repository);

  final ChatRepository _repository;

  Stream<BoxEvent> call({dynamic key}) => _repository.watchChat(key: key);
}
