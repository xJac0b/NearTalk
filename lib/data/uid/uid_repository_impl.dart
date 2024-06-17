import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/uid/uid_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _uidKey = 'uid';

@Singleton(as: UidRepository)
class UidRepositoryImpl implements UidRepository {
  UidRepositoryImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  String getUid() => _sharedPreferences.getString(_uidKey) ?? '';

  @override
  Future<void> setUid() async {
    String deviceId = '';
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
    }
    if (getUid().isEmpty) {
      await _sharedPreferences.setString(
          _uidKey, deviceId.isEmpty ? const Uuid().v4() : deviceId);
    }
  }
}
