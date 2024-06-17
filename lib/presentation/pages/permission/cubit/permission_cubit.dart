import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:neartalk/presentation/shared/cubit/safe_action_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_action.dart';
part 'permission_cubit.freezed.dart';
part 'permission_state.dart';

@inject
class PermissionCubit
    extends SafeActionCubit<PermissionState, PermissionAction> {
  PermissionCubit() : super(const PermissionState.initial());
  int sdk = 0;
  Future<void> init() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    sdk = androidInfo.version.sdkInt;
    if (await checkPermissions()) {
      dispatch(const PermissionAction.goHome());
    }
  }

  Future<bool> checkLocation() async {
    if (await Permission.location.isGranted) {
      return await Location.instance.requestService();
    }
    return false;
  }

  Future<void> requestLocation() async {
    await Permission.location.request();
    await checkPermissions();
  }

  Future<bool> checkStorage() async {
    // ignore: avoid_bool_literals_in_conditional_expressions
    return sdk < 33
        ? await Permission.storage.isGranted
        : true;
  }

  Future<void> requestStorage() async {
    await Permission.storage.request();
    // await Permission.manageExternalStorage.request();
    await checkPermissions();
  }

  Future<bool> checkBluetooth() async {
    return !(await Future.wait([
          Permission.bluetooth.isGranted,
          Permission.bluetoothAdvertise.isGranted,
          Permission.bluetoothConnect.isGranted,
        ]))
            .any((element) => false) &&
        await Permission.bluetoothScan.isGranted;
  }

  Future<void> requestBluetooth() async {
    Logger().d((await Permission.bluetoothScan.isGranted).toString());
    await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    await checkPermissions();
  }

  Future<bool> checkWifi() async {
    return Permission.nearbyWifiDevices.isGranted;
  }

  Future<void> requestWifi() async {
    await Permission.nearbyWifiDevices.request();
    await checkPermissions();
  }

  Future<bool> checkPermissions() async {
    final location = await checkLocation();
    final storage = await checkStorage();
    final bluetooth = await checkBluetooth();
    final wifi = sdk < 32 || await checkWifi();

    if (state is _Initial && location && storage && bluetooth && wifi) {
      return true;
    }
    emit(
      PermissionState.permissions(
        location: location,
        storage: storage,
        bluetooth: bluetooth,
        wifi: wifi,
      ),
    );
    return false;
  }
}
