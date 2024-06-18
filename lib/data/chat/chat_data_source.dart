import 'dart:async';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injecteo/injecteo.dart';
import 'package:logger/logger.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:neartalk/main.dart';
import 'package:uuid/uuid.dart';

@singleton
class ChatDataSource {
  ChatDataSource(this._chatBox);

  final Box<Chat> _chatBox;

  Future<void> addChat(Chat chat) async {
    if (_chatBox.containsKey(chat.id)) {
      Chat? c = _chatBox.get(chat.id);

      if (c == null || c.endpointId == chat.endpointId) return;
      c = c.copyWith(endpointId: chat.endpointId);
      await _chatBox.delete(chat.id);
      await _chatBox.put(chat.id, c);
    } else {
      await _chatBox.put(chat.id, chat);
    }
  }

  Future<void> deleteChat(String id) async {
    await _chatBox.delete(id);
    final Directory filesDir = Directory('${appDocumentsDir.path}/files/$id');
    if (filesDir.existsSync()) {
      filesDir.deleteSync();
    }
  }

  Future<List<Chat>> getChats() async {
    return _chatBox.values.toList();
  }

  Future<Chat?> getChat(String id) async {
    final chat = _chatBox.get(id);
    return chat;
  }

  Future<void> addMessage(String chatId, Message message) async {
    final chat = _chatBox.get(chatId);
    if (chat == null) return;
    chat.messages.add(message);
    await _chatBox.put(chatId, chat);
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    final chat = _chatBox.get(chatId);
    if (chat == null) return;
    chat.messages.removeWhere((element) => element.id == messageId);
    await _chatBox.put(chatId, chat);
  }

  Stream<BoxEvent> watchChat({dynamic key}) {
    return _chatBox.watch(key: key);
  }

  Future<void> uploadAvatar(String chatId, XFile avatar) async {
    final Directory avatarsDir =
        Directory('${appDocumentsDir.path}/avatars/$chatId');
    if (!avatarsDir.existsSync()) {
      await avatarsDir.create(recursive: true);
    }
    final oldChatBox = _chatBox.get(chatId);
    if (oldChatBox == null) return;

    final oldPath = oldChatBox.avatarPath;
    if (oldPath != null) {
      final oldFile = File(oldPath);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }
    }
    final String newFilePath = '${avatarsDir.path}/${const Uuid().v4()}.jpg';

    await avatar.saveTo(newFilePath);
    await _chatBox.put(chatId, oldChatBox.copyWith(avatarPath: newFilePath));
  }

  Future<String> uploadFile(String chatId, String path,
      {bool useNearby = false}) async {
    final Directory filesDir =
        Directory('${appDocumentsDir.path}/files/$chatId');
    if (!filesDir.existsSync()) {
      await filesDir.create(recursive: true);
    }
    final String newFilePath = '${filesDir.path}/${const Uuid().v4()}.jpg';

    if (useNearby) {
      await Nearby().copyFileAndDeleteOriginal(path, newFilePath);
    } else {
      final file = File(path);
      await file.copy(newFilePath);
    }
    final oldChat = _chatBox.get(chatId);
    if (oldChat != null) {
      await _chatBox.put(
          chatId, oldChat.copyWith(paths: [...oldChat.paths, newFilePath]));
    }
    Logger().e(newFilePath);
    return newFilePath;
  }

  Future<void> renameChat(String chatId, String name) async {
    final chat = _chatBox.get(chatId);
    if (chat == null) return;
    await _chatBox.put(chatId, chat.copyWith(name: name));
  }
}
