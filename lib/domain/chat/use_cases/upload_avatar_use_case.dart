import 'package:image_picker/image_picker.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';

@inject
class UploadAvatarUseCase {
  UploadAvatarUseCase(this._repository);

  final ChatRepository _repository;

  Future<void> call(String chatId, XFile file) async =>
      await _repository.uploadAvatar(chatId, file);
}
