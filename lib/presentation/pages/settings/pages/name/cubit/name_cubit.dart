import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/use_cases/get_chat_use_case.dart';
import 'package:neartalk/domain/chat/use_cases/rename_chat_use_case.dart';
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
    this._getChat,
    this._renameChat,
  ) : super(const NameState.loading());

  final SaveNameUseCase _changeName;
  final GetNameUseCase _getName;
  final GetChatUseCase _getChat;
  final RenameChatUseCase _renameChat;
  String id = '';

  Future<void> loadName(String id, TextEditingController controller) async {
    String name = '';
    this.id = id;

    if (id.isEmpty) {
      name = _getName();
      if (name.isEmpty) name = await modelName();
    } else {
      final chat = await _getChat(id);
      if (chat == null) {
        emit(const NameState.error());
        return;
      }
      name = chat.name;
    }
    controller.text = name;
    emit(const NameState.initial());
  }

  Future<void> changeName(String name) async {
    if (id.isEmpty) {
      if (name == _getName()) {
        emit(const NameState.initial());
        SnackbarController.showInfo(
          'Device name is already set to $name',
        );
        return;
      }
      await _changeName(name);
    } else if (name.isNotEmpty) {
      final chat = await _getChat(id);
      if (chat == null) {
        emit(const NameState.error());
        return;
      }
      if (name == chat.name) {
        emit(const NameState.initial());
        SnackbarController.showInfo(
          'Chat name is already set to $name',
        );
        return;
      }

      await _renameChat(id, name);
    } else {
      SnackbarController.showError(
        'Device name cannot be empty',
      );
      emit(const NameState.initial());
      return;
    }

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
