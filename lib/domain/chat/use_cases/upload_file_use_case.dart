import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class UploadFileUseCase {
  UploadFileUseCase(this._repository);

  final ChatRepository _repository;

  Future<String> call(String chatId, String path,
          {bool useNearby = false}) async =>
      _repository.uploadFile(chatId, path, useNearby: useNearby);
}
