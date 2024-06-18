import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:neartalk/domain/chat/use_cases/add_message_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/get_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/upload_file_use_case.dart';
import 'package:neartalk/domain/notifications/notifications_controller.dart';

@inject
class OnPayloadTransferSuccessUseCase {
  OnPayloadTransferSuccessUseCase(
      this._uploadFileUseCase,
      this._addMessageUseCase,
      this._notificationsController,
      this._getChatUseCase);

  final UploadFileUseCase _uploadFileUseCase;
  final AddMessageUseCase _addMessageUseCase;
  final NotificationsController _notificationsController;
  final GetChatUseCase _getChatUseCase;

  Future<void> call({required String deviceId, required String uri}) async {
    final path = await _uploadFileUseCase(deviceId, uri, useNearby: true);
    final chat = await _getChatUseCase(deviceId);
    if (chat == null) return;
    await _notificationsController.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
        title: chat.name, body: 'Sent photo');
    await _addMessageUseCase(
        deviceId,
        Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            me: false,
            path: path,
            text: '',
            timestamp: DateTime.now()));
  }
}
