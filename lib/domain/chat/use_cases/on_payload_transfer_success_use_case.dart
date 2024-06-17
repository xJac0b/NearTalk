import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:neartalk/domain/chat/use_cases/add_message_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/upload_file_use_case.dart';

@inject
class OnPayloadTransferSuccessUseCase {
  OnPayloadTransferSuccessUseCase(
      this._uploadFileUseCase, this._addMessageUseCase);

  final UploadFileUseCase _uploadFileUseCase;
  final AddMessageUseCase _addMessageUseCase;

  Future<void> call({required String deviceId, required String uri}) async {
    final path = await _uploadFileUseCase(deviceId, uri, useNearby: true);

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
