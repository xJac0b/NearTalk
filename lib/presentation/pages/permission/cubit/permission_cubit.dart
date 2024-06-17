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

  Future<void> init() async {
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
    return (await DeviceInfoPlugin().androidInfo).version.sdkInt < 33
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

  Future<bool> checkPermissions() async {
    final location = await checkLocation();
    final storage = await checkStorage();
    final bluetooth = await checkBluetooth();

    if (state is _Initial && location && storage && bluetooth) {
      return true;
    }
    emit(
      PermissionState.permissions(
        location: location,
        storage: storage,
        bluetooth: bluetooth,
      ),
    );
    return false;
  }
}
