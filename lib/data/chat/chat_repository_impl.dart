import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/data/chat/chat_data_source.dart';
import 'package:neartalk/domain/chat/chat_repository.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._chatDataSource);

  final ChatDataSource _chatDataSource;

  @override
  Future<void> addChat(Chat chat) => _chatDataSource.addChat(chat);

  @override
  Future<void> addMessage(String chatId, Message message) =>
      _chatDataSource.addMessage(chatId, message);

  @override
  Future<void> deleteMessage(String chatId, String messageId) =>
      _chatDataSource.deleteMessage(chatId, messageId);

  @override
  Future<void> deleteChat(String id) => _chatDataSource.deleteChat(id);

  @override
  Future<Chat?> getChat(String id) => _chatDataSource.getChat(id);

  @override
  Future<List<Chat>> getChats() => _chatDataSource.getChats();

  @override
  Stream<BoxEvent> watchChat({dynamic key}) =>
      _chatDataSource.watchChat(key: key);

  @override
  Future<void> uploadAvatar(String chatId, XFile avatar) =>
      _chatDataSource.uploadAvatar(chatId, avatar);

  @override
  Future<String> uploadFile(String chatId, String path,
          {bool useNearby = false}) =>
      _chatDataSource.uploadFile(chatId, path, useNearby: useNearby);
}
