import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';

abstract class ChatRepository {
  Future<void> addChat(Chat chat);
  Future<void> deleteChat(String id);
  Future<List<Chat>> getChats();
  Future<Chat?> getChat(String id);
  Future<void> addMessage(String chatId, Message message);
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> uploadAvatar(String chatId, XFile avatar);
  Future<void> renameChat(String chatId, String name);
  Future<String> uploadFile(String chatId, String path,
      {bool useNearby = false});
  Stream<BoxEvent> watchChat({dynamic key});
}
