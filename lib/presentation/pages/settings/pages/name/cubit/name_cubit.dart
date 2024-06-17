import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/use_cases/get_name_use_case.dart';
import 'package:neartalk/domain/settings/use_cases/save_name_use_case.dart';
import 'package:neartalk/presentation/shared/extensions/cubit/safe_cubit.dart';
import 'package:neartalk/presentation/snackbar/snackbar_controller.dart';

part 'name_cubit.freezed.dart';
part 'name_state.dart';

@inject
class NameCubit extends SafeCubit<NameState> {
  NameCubit(
    this._changeName,
    this._getName,
  ) : super(const NameState.initial());

  final SaveNameUseCase _changeName;
  final GetNameUseCase _getName;

  Future<void> loadName(TextEditingController controller) async {
    var name = _getName();
    if (name.isEmpty) name = await modelName();
    controller.text = name;
  }

  Future<void> changeName(String name) async {
    emit(const NameState.loading());
    await _changeName(name);
    emit(const NameState.initial());
    SnackbarController.showSuccessful(
      'Device name changed successfully',
    );
  }

  Future<String> modelName() async {
    String model = '';
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      model = '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      model = iosInfo.name;
    }
    return model;
  }
}
