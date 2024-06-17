import 'package:hive/hive.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/domain/chat/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

@externalModule
abstract class StorageConfigModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @singleton
  @preResolve
  Future<Box<Chat>> get chatBox async {
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(ChatAdapter());
    return await Hive.openBox<Chat>('chat');
  }
}
