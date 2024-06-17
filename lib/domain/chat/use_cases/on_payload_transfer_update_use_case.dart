import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/use_cases/on_payload_transfer_success_use_case.dart';
import 'package:neartalk/main.dart';

@inject
class OnPayloadTransferUpdateUseCase {
  OnPayloadTransferUpdateUseCase(this._onPayloadTransferSuccessUseCase);

  final OnPayloadTransferSuccessUseCase _onPayloadTransferSuccessUseCase;

  Future<void> call(
      String endpointId, PayloadTransferUpdate payloadTransferUpdate) async {
    Logger().i(
        'Payload transfer update: $endpointId, ${payloadTransferUpdate.id}, STATUS: ${payloadTransferUpdate.status}, ${payloadTransferUpdate.bytesTransferred}/${payloadTransferUpdate.totalBytes}');
    if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
        filesToUpload.containsKey(payloadTransferUpdate.id)) {
      final data = filesToUpload[payloadTransferUpdate.id]!;
      await _onPayloadTransferSuccessUseCase(
          deviceId: data.deviceId, uri: data.uri);
      filesToUpload.remove(payloadTransferUpdate.id);
    }
  }
}
